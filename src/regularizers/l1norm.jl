export L1Norm

"""
    L1Norm <: AbstractRegularizer

Regularizer using the l1-norm.

# fields
- `hyperparameter::Number`: the hyperparameter of the regularizer
- `weight`: the weight of the regularizer, which could be a number or an array.
- `domain::AbstractRegularizerDomain`: the image domain where the regularization funciton will be computed. L1Norm can be computed only in `LinearDomain()`.
"""
struct L1Norm{S<:Number,T,D<:AbstractRegularizerDomain} <: AbstractRegularizer
    hyperparameter::S
    weight::T
    domain::D
end

# function label
functionlabel(::L1Norm) = :l1norm

"""
    l1norm(I::IntensityMap)

Base function of the l1norm.

# Arguments
- `I::IntensityMap`: the image
"""
@inline l1norm(I::IntensityMap) = @inbounds sum(abs.(I))

"""
    l1norm(I::IntensityMap, w::Number)

Base function of the l1norm.

# Arguments
- `I::IntensityMap`: the image
- `w::Number`: the regularization weight
"""
@inline l1norm(I::IntensityMap, w::Number) = w * l1norm(I)


@inline transform_linear_forward(skymodel::IntensityMap, x::IntensityMap) = x

"""
    evaluate(::AbstractRegularizer, skymodel::IntensityMap, x::IntensityMap)
"""
function evaluate(::LinearDomain, reg::L1Norm, skymodel::IntensityMap, x::IntensityMap)
    return l1norm(transform_linear_forward(skymodel, x), reg.weight)
end
