export domain, evaluate, functionlabel, hyperparameter, LinearDomain, LogDomain, WaveletDomain, transform_domain

"""
    AbstractRegularizer

# Mandatory fields

- `hyperparameter::Number`: the hyper parameter of the regularization function. In default, it should be a number.
- `image_domain::AbstractDomain`: the domain of the image space 
- `evaluation_domain::AbstractDomain`: the domain on which the regularizer is to be evaluated
- `grid`


# Mandatory methods

- `evaluate(::RegularizerDomain, ::Regularizer, ::ImageModel, ::AbstractArray)`:
    Evaluate the regularization function for the given input sky image.
- `evaluate(::Regularizer, ::ImageModel, ::AbstractArray)`:
    Evaluate the regularization function for the given input sky image.
- `cost(::AbstractRegularizer, ::AbstractImageModel, ::AbstractArray)`:
    Evaluate the cost function for the given input sky image. The cost function is defined by the product of its hyperparameter and regularization function.
- ``
"""
abstract type AbstractRegularizer <: ContinuousMatrixDistribution end

# function to get the label for regularizer
functionlabel(::AbstractRegularizer) = :namelessregularizer


# function to get domain and hyper parameter
"""
    domain(reg::AbstractRegularizer) = reg.domain

Return the computing domain of the given regularizer.
"""
#image_domain(reg::AbstractRegularizer) = reg.image_domain
#evaluation_domain(reg::AbstractRegularizer) = reg.evaluation_domain

"""
    hyperparameter(reg::AbstractRegularizer) = reg.hyperparameter

Return the hyperparameter of the given regularizer.
"""
#hyperparameter(reg::AbstractRegularizer) = reg.hyperparameter


"""
    evaluate(::AbstractRegularizer, ::AbstractArray)

Compute the value of the given regularization function on the input image.
By default, return 0.
"""
evaluate(reg::AbstractRegularizer, image::AbstractArray) = 0


Base.size(d::AbstractRegularizer) = size(d.grid)
Base.length(d::AbstractRegularizer) = length(d.grid)

function HypercubeTransform.asflat(d::AbstractRegularizer)
    return as(Array, size(d))
end


"""
    Distributions._logpdf(d::Regularizers, image::AbstractMatrix{<:Real})
The log density of the regularizers evaluated at the input image. .

# Arguments
- `reg::Regularizers`: the regularizer functions.
- `image::AbstractMatrix{<:Real}`: the model of the input image
"""
function Distributions._logpdf(d::AbstractRegularizer, x::AbstractMatrix{<:Real})
    return -1*evaluate(d, x)
end

"""
    Distributions._rand!(rng::Random.AbstractRNG, ::Regularizers, x::AbstractMatrix)
Return a random sample of shape equal to the shape of the input matrix

# Arguments
- `rng::Random.AbstractRNG`: an RNG seed object
- `::Regularizers`: any set of regularizer functions
- `x::AbstractMatrix`: input matrix
"""

function Distributions._rand!(rng::Random.AbstractRNG, ::AbstractRegularizer, x::AbstractMatrix)
    return rand!(rng, x)
end
