export domain, evaluate, functionlabel, hyperparameter, LinearDomain, LogDomain, WaveletDomain, transform_domain

"""
    AbstractRegularizer

# Mandatory fields

- `hyperparameter::Number`: the hyper parameter of the regularization function. In default, it should be a number.
- `domain::AbstractRegularizerDomain`: the domain of the image space where the regularization function will be computed.

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

