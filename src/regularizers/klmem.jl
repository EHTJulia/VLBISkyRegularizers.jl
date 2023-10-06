export KLEntropy

"""
    KLEntropy <: AbstractRegularizer

Regularizer using the KL divergence.

# fields
- `hyperparameter::Number`: the hyperparameter of the regularizer
- `prior`: the prior image
- `domain::AbstractRegularizerDomain`: the image domain where the regularization funciton will be computed. L1Norm can be computed only in `LinearDomain()`.
"""
struct KLEntropy{S,T,D} <: AbstractRegularizer
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
@inline function klentropy_base(I::IntensityMap, p::AbstractArray)
    # compute the ttotal flux
    totalflux = sum_floop(I)
    # compute xlogx
    @inbounds xnorm = I ./ totalflux
    @inbounds xlogx = xnorm .* log.(xnorm ./ p)
    return sum(filter(!isnan, xlogx))
end

"""
    evaluate(::AbstractRegularizer, skymodel::AbstractImage2DModel, x::AbstractArray)
"""
# skymodel::AbstractImage2DModel, x::AbstractArray needs to be changed! 
function evaluate(::LinearDomain, reg::KLEntropy, skymodel::IntensityMap, x::AbstractArray)
    return klentropy_base(transform_linear_forward(skymodel, x), reg.prior)
end
