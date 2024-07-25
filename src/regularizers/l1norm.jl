export L1, evaluate

"""
    L1 <: AbstractRegularizer

Regularizer using the L1 norm.

# fields
- `hyperparameter::Number`: the hyperparameter of the regularizer
- `domain::AbstractRegularizerDomain`: the image domain where the regularization funciton will be computed.
"""
struct L1{S<:Number,D<:AbstractRegularizerDomain} <: AbstractRegularizer
    hyperparameter::S
    domain::D
end

# function label
functionlabel(::L1) = :l1

"""
    l1_base(x::AbstractArray)

Base function of the L1 norm.

# Arguments
- `x::AbstractArray`: the image
"""
@inline l1_base(x::AbstractArray) = @inbounds sum(abs.(I))


"""
    l1_base(x::AbstractArray, w::Number)

Base function of the L1 norm.

# Arguments
- `x::AbstractArray`: the image
- 'w::Number' : the regularization weight
"""
@inline l1_base(x::AbstractArray, w::Number) =  w * l1_base(x)


"""
    evaluate(reg::L1, x::AbstractArray)

Evaluate the L1 norm regularizer at an image.

# Arguments
- `reg::L1`: L1 norm regularizer
- `x::AbstractArray`: the image
"""
function evaluate(reg::L1, x::AbstractArray)
    return l1_base(transform_domain(reg.domain, x), reg.hyperparameter)
end