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

Base function of the l1norm.

# Arguments
- `I::IntensityMap`: the image
- `p::IntensityMap`: the prior image
"""
@inline function klentropy_base(I::IntensityMap, p::IntensityMap)
    # compute the ttotal flux
    totalflux = sum(I)
    # compute xlogx
    @inbounds xnorm = I ./ totalflux
    @inbounds xlogx = xnorm .* log.(xnorm ./ p)
    return sum(filter(!isnan, xlogx))
end

"""
    evaluate(::AbstractRegularizer, skymodel::IntensityMap, x::IntensityMap)
"""
function evaluate(::LinearDomain, reg::KLEntropy, skymodel::IntensityMap, x::IntensityMap)
    return klentropy_base(transform_linear_forward(skymodel, x), reg.prior)
end
