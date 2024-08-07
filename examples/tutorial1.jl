# # Full Visibilities Imaging

import Pkg #hide
__DIR = @__DIR__ #hide
pkg_io = open(joinpath(__DIR, "pkg.log"), "w") #hide
Pkg.activate(__DIR; io=pkg_io) #hide
Pkg.develop(; path=joinpath(__DIR, ".."), io=pkg_io) #hide
Pkg.instantiate(; io=pkg_io) #hide
Pkg.precompile(; io=pkg_io) #hide
close(pkg_io) #hide

ENV["GKSwstype"] = "nul"; #hide

# ## Loading the Data

# We start by loading Comrade and VLBISkyRegularizers.
using Comrade
using VLBISkyRegularizers

# We use Pyehtim to load the uvfits files.
using Pyehtim

# We also use a stable random number generator
using StableRNGs
rng = StableRNG(100)

# Load the observation data with Pyehtim and do some preprocessing
file = joinpath(__DIR, "data", "L2V1_M87_2018_111_b3_hops_netcal_10s_StokesI.uvfits")
obseht = ehtim.obsdata.load_uvfits(file)
obs = Pyehtim.scan_average(obseht).add_fractional_noise(0.02)

# Extract the visibilities from the obsdata object
dvis = extract_table(obs, Visibilities())

# ## Build sky model
# We build a model consisting of a raster of pixels and an extended Gaussian component.
# The pixel raster is convolved with a pulse to make a `ContinuousImage` object. The 
# Gaussian component is used to model the zero baselines. The sky model consists of two
# components, `θ` and `metadata`. `θ` is a NamedTuple with parameters we want to fit.
# `impixel` here is the pixel raster, and `fg` controls the relative scaling between the
# raster and the Gaussian component. `metadata` is also a NamedTuple with constant 
# parameters. `ftot` controls the total flux scaling, `pulse` is the pulse with which the
# pixel raster is convolved, and `regularizers` is the set of regularizers we will be using.
function sky(θ, metadata)
    (; impixel, fg) = θ
    (; ftot, pulse, regularizers) = metadata

    ## Transform image to the image simplex domain and scale
    rast = ftot*(1-fg).*transform_image(image_domain(regularizers), impixel)
	## Form the image
    img = IntensityMap(rast, VLBISkyRegularizers.grid(regularizers))
    m = ContinuousImage(img, pulse)
    ## Add an extended Gaussian
    gauss = modify(Gaussian(), Stretch(μas2rad(250.0)), Renormalize(fg*ftot))
    return m + gauss
end

# ## Define Image and Regularizers

# Next, we define the grid on which our image model will exist. 
global fov = 150
global npix = 32
grid_p = imagepixels(μas2rad(fov), μas2rad(fov), npix, npix)

# Now we define the regularizers we want to use. The available regulariers are:
using InteractiveUtils#hide
subtypes(AbstractRegularizer)

# Each regularizer must be passed with four arguments: the hyperparameter, the image domain,
# the evaluation domain, and the grid. The hyperparameter defines the weight of the regularizer,
# the image domain defines the domain to which the image will be transformed, the evaluation 
# domain defines the domain on which the regularizer will be evaluated, and the grid defines
# the grid of pixels on which the regularizer will be evaluated. The available [domains](@ref Domains) are:
subtypes(AbstractDomain)

# !!! note
#       When using multiple regularizers, the image domains and grids of all regularizers must match.
#-

# We will use a TSV regularizer in the log domain and a wavelet-space L1-norm regularizer in the
# linear domain, and have a log image domain.
r1 = TSV(1, LogDomain(), ParameterDomain(), grid_p)
r2 = WaveletL1(1, LogDomain(), LinearDomain(), WVType(), grid_p)
regularizers = r1 + r2

# ## Build Posterior

# Now we build our sky model.
using Distributions
skymeta = (;ftot = 1.1, pulse = BSplinePulse{3}(), regularizers)
skyprior = (
    impixel=regularizers,
    fg=Uniform(0,1)
) 
skymodel = SkyModel(sky, skyprior, grid_p, metadata=skymeta)

# And next our intstrument model.
G = SingleStokesGain() do x
    lg = x.lg
    gp = x.gp
    return exp(lg + 1im*gp)
end

intpr = (
    lg= ArrayPrior(IIDSitePrior(ScanSeg(), Normal(0.0, 0.2)); LM = IIDSitePrior(ScanSeg(), Normal(0.0, 1.0))),
    gp= ArrayPrior(IIDSitePrior(ScanSeg(), DiagonalVonMises(0.0, inv(π^2))); refant=SEFDReference(0.0), phase=true)
        )
intmodel = InstrumentModel(G, intpr)

# Now we can make our posterior.
post = VLBIPosterior(skymodel, intmodel, dvis)

# ## Image Reconstruction

# We use the [`solve_opt`](@ref) function to solve for the MAP estimate. By default, this
# uses an Adam optimizer from the `OptimizationOptimisers.jl` package and automatic
# differentiation with Enzyme from the `Optimization.jl` package. This function runs
# the optimization `ntrials` number of times. Each optimization trial first runs half of `maxiters`
# number of iterations, adds some random noise, then runs `maxiters` iterations from that point.
# The output values are sorted by order of objective value.
using Optimization
using OptimizationOptimisers
using Logging#hide
gl = global_logger()#hide
global_logger(NullLogger())#hide
xopts, ℓopts = solve_opt(post, Optimisers.Adam(), Optimization.AutoEnzyme(); 
                        ntrials=5, maxiters=10_000, verbose=false)
global_logger(gl)

# Now we plot the MAP estimate.
using DisplayAs #hide
import CairoMakie as CM
grid_plot = imagepixels(μas2rad(fov), μas2rad(fov), npix*4, npix*4)
img = intensitymap(Comrade.skymodel(post, xopts[1]), grid_plot)
fig = Comrade.imageviz(img, size(600,500));
DisplayAs.Text(DisplayAs.PNG(fig))#hide