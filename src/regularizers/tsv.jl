export TSV, evaluate

"""
    TSV <: AbstractRegularizer

Regularizer using the Isotropic Total Squared Variation.

# fields
- `hyperparameter::Number`: the hyperparameter of the regularization function.
- `image_domain::AbstractDomain`: the domain of the image space 
- `evaluation_domain::AbstractDomain`: the domain on which the regularizer is to be evaluated
- `grid`: grid on which image is defined
"""
struct TSV{H<:Number,ID<:AbstractDomain,ED<:AbstractDomain,G<:RectiGrid} <: AbstractRegularizer
    hyperparameter::H
    image_domain::ID
    evaluation_domain::ED
    grid::G
end

# function label
functionlabel(::TSV) = "TSV"

"""
    tsv_base(x::AbstractArray)

Base function of the isotropic total squared variation.

# Arguments
- `x::AbstractArray`: the image
"""
tsv_base(x) = @tullio tv2 = abs2(x[i,j] - x[i+1,j]) + abs2(x[i,j] - x[i,j+1])


"""
    tsv_base(x::AbstractArray, w::Number)

Base function of the isotropic total squared variation.

# Arguments
- `x::AbstractArray`: the image
- 'w::Number' : the regularization weight
"""
tsv_base(x::AbstractArray, w::Number) =  w * tsv_base(x)


"""
    evaluate(reg::TSV, x::AbstractArray)

Evaluate the TSV regularizer at an image.

# Arguments
- `reg::TSV`: TSV regularizer
- `x::AbstractArray`: the image
"""
function evaluate(reg::TSV, x::AbstractArray)
    return tsv_base(transform_domain(reg.image_domain, reg.evaluation_domain, x), reg.hyperparameter)
end