export L1, evaluate

"""
    L1 <: AbstractRegularizer

Regularizer using the L1 norm.

# fields
- `hyperparameter::Number`: the hyperparameter of the regularization function.
- `image_domain::AbstractDomain`: the domain of the image space 
- `evaluation_domain::AbstractDomain`: the domain on which the regularizer is to be evaluated
- `grid`: grid on which image is defined
"""
struct L1{H<:Number,ID<:AbstractDomain,ED<:AbstractDomain,G<:RectiGrid} <: AbstractRegularizer
    hyperparameter::H
    image_domain::ID
    evaluation_domain::ED
    grid::G
end

# function label
functionlabel(::L1) = "L1-Norm"

"""
    l1_base(x::AbstractArray)

Base function of the L1 norm.

# Arguments
- `x::AbstractArray`: the image
"""
l1_base(x::AbstractArray) = sum(abs.(x))


"""
    l1_base(x::AbstractArray, w::Number)

Base function of the L1 norm.

# Arguments
- `x::AbstractArray`: the image
- 'w::Number' : the regularization weight
"""
l1_base(x::AbstractArray, w::Number) =  w * l1_base(x)



"""
    evaluate(reg::L1, x::AbstractArray)

Evaluate the L1 norm regularizer at an image.

# Arguments
- `reg::L1`: L1 norm regularizer
- `x::AbstractArray`: the image
"""
function evaluate(reg::L1, x::AbstractArray)
    return l1_base(transform_domain(reg.image_domain, reg.evaluation_domain, x), reg.hyperparameter)
end