export L1Norm

"""
    L1Norm <: AbstractRegularizer

Regularizer using the l1-norm.

# fields
- `hyperparameter::Number`: the hyperparameter of the regularizer
- `weight`: the weight of the regularizer, which could be a number or an array.
- `domain::AbstractRegularizerDomain`: the image domain where the regularization funciton will be computed. L1Norm can be computed only in `LinearDomain()`.
"""
struct L1Norm{S,T,D} <: AbstractRegularizer
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
@inline l1norm(x::IntensityMap) = @inbounds sum(abs.(x))

"""
    l1norm(I::IntensityMap, w::Number)

Base function of the l1norm.

# Arguments
- `I::IntensityMap`: the image
- `w::Number`: the regularization weight
"""
@inline l1norm(x::IntensityMap, w::Number) = w * l1norm(x)


@inline transform_linear_forward(skymodel::IntensityMap, x::AbstractArray) = x

"""
    evaluate(::AbstractRegularizer, skymodel::IntensityMap, x::AbstractArray)
"""
# skymodel::AbstractImage2DModel, x::AbstractArray needs to be changed! 
function evaluate(::LinearDomain, reg::L1Norm, skymodel::IntensityMap, x::AbstractArray)
    return l1norm(transform_linear_forward(skymodel, x), reg.weight)
end
