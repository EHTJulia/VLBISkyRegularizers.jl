# # Tutorial 1

# Show RML imaging here

import Pkg #hide
__DIR = @__DIR__ #hide
pkg_io = open(joinpath(__DIR, "pkg.log"), "w") #hide
Pkg.activate(__DIR; io=pkg_io) #hide
Pkg.develop(; path=joinpath(__DIR, ".."), io=pkg_io) #hide
Pkg.instantiate(; io=pkg_io) #hide
Pkg.precompile(; io=pkg_io) #hide
close(pkg_io) #hide

ENV["GKSwstype"] = "nul" #hide

# ## Loading the Data

using Comrade
using VLBISkyRegularizers
using Pyehtim
