export TV, evaluate

"""
    TV <: AbstractRegularizer

Regularizer using the Isotropic Total Variation.

# fields
- `hyperparameter::Number`: the hyperparameter of the regularizer
- `domain::AbstractRegularizerDomain`: the image domain where the regularization funciton will be computed.
"""
struct TV{H<:Number,ID<:AbstractDomain,ED<:AbstractDomain,G<:RectiGrid} <: AbstractRegularizer
    hyperparameter::H
    image_domain::ID
    evaluation_domain::ED
    grid::G
end

# function label
functionlabel(::TV) = :tv

"""
    tv_base(x::AbstractArray)

Base function of the isotropic total variation.

# Arguments
- `x::AbstractArray`: the image
"""
tv_base(x::AbstractArray) = @tullio tvF = sqrt(abs2(x[i,j] - x[i+1,j]) + abs2(x[i,j] - x[i,j+1]))


"""
    tv_base(x::AbstractArray, w::Number)

Base function of the isotropic total variation.

# Arguments
- `x::AbstractArray`: the image
- 'w::Number' : the regularization weight
"""
@inline tv_base(x::AbstractArray, w::Number) =  w * tv_base(x)


"""
    evaluate(reg::TV, x::AbstractArray)

Evaluate the TV regularizer at an image.

# Arguments
- `reg::TV`: TV regularizer
- `x::AbstractArray`: the image
"""
function evaluate(reg::TV, x::AbstractArray)
    return tv_base(transform_domain(reg.image_domain, reg.evaluation_domain, x), reg.hyperparameter)
end