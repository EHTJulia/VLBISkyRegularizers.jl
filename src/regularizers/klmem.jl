export KLEntropy

"""
    KLEntropy <: AbstractRegularizer

Regularizer using the Kullback-Leibler divergence (or a relative entropy)

# fields
- `hyperparameter::Number`: the hyperparameter of the regularizer
- `prior`: the prior image
- `domain::AbstractRegularizerDomain`: the image domain where the regularization funciton will be computed.
    KLEntropy can be computed only in `LinearDomain()`.
"""
struct KLEntropy{S<:Number,T,D<:AbstractRegularizerDomain} <: AbstractRegularizer
    hyperparameter::S
    prior::T
    domain::D
end

# function label
functionlabel(::KLEntropy) = :klentropy

"""
    klentropy_base(I::IntensityMap, p::IntensityMap)

Base function of the KL-Entropy norm.

# Arguments
- `I::IntensityMap`: the image
- `p::IntensityMap`: the prior image
"""
@inline function klentropy_base(I::IntensityMap, p::IntensityMap)
    # compute the total flux
    totalflux = sum(I)
    # compute xlogx
    @inbounds xnorm = I ./ totalflux
    @inbounds xnorm = xnorm
    @inbounds xlogx = xnorm .* log.((xnorm .+ 10e-100) ./ p)
    return sum(xlogx)
end

"""
@inline function klentropy_base_grad_pixel(I::IntensityMap, p::IntensityMap, ix::Integer, iy::Integer)
    totalflux = sum(I)
    xnorm = I[ix, iy]/totalflux
    Δxnorm = (totalflux - I[ix, iy])/(totalflux^2)
    Δxlogx = Δxnorm*log((xnorm+10e-10)/p[ix, iy]) + Δxnorm

    nx = size(I, 1)
    ny = size(I, 2)
    exlSum = 0
    for i = 1:ny, j = 1:nx
        term = I[i,j]/(totalflux^2)
        term *= log((I[i,j]/totalflux + 10e-10)/p[i,j]) + 1
        exlSum -= term
    end

    exlSum += (I[ix,iy]/(totalflux^2))*(log((I[ix,iy]/totalflux + 10e-10)/p[ix,iy]) + 1)

    return Δxlogx + exlSum
end


@inline function klentropy_base_grad(I::IntensityMap, p::IntensityMap)
    nx = size(I, 1)
    ny = size(I, 2)
    grad = zeros(nx, ny)
    for iy = 1:ny, ix = 1:nx
        @inbounds grad[ix, iy] = klentropy_base_grad_pixel(I, p, ix, iy)
    end
    return grad
end

function ChainRulesCore.rrule(::typeof(klentropy_base), I::IntensityMap, p::IntensityMap)
    y = klentropy_base(I, p)
    function pullback(Δy)
        fbar = NoTangent()
        xbar = @thunk(klentropy_base_grad(I, p) .* Δy)
        return fbar, xbar
    end
    return y, pullback
end
"""

"""
    evaluate(::AbstractRegularizer, skymodel::IntensityMap, x::IntensityMap)
"""
function evaluate(::LinearDomain, reg::KLEntropy, skymodel::IntensityMap, x::IntensityMap)
    return klentropy_base(transform_linear_forward(skymodel, x), reg.prior)
end
