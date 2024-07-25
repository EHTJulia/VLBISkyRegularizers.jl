export domain, evaluate, functionlabel, hyperparameter, LinearDomain, LogDomain, transform_domain

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

# computing domain
abstract type AbstractRegularizerDomain end

# computing domain
struct LinearDomain <: AbstractRegularizerDomain end
struct LogDomain <: AbstractRegularizerDomain end

# function to get the label for regularizer
functionlabel(::AbstractRegularizer) = :namelessregularizer


# function to get domain and hyper parameter
"""
    domain(reg::AbstractRegularizer) = reg.domain

Return the computing domain of the given regularizer.
"""
domain(reg::AbstractRegularizer) = reg.domain

"""
    hyperparameter(reg::AbstractRegularizer) = reg.hyperparameter

Return the hyperparameter of the given regularizer.
"""
hyperparameter(reg::AbstractRegularizer) = reg.hyperparameter


"""
    evaluate(::AbstractRegularizer, ::AbstractArray)

Compute the value of the given regularization function on the input image.
By default, return 0.
"""
evaluate(reg::AbstractRegularizer, image::AbstractArray) = 0


"""
    transform_domain(::LinearDomain, x::AbstractArray)

Transform the domain of the image. For Linear Domain, this does not change the image.
"""
@inline transform_domain(::LinearDomain, x::AbstractArray) = x

"""
    transform_domain(::LogDomain, x::AbstractArray)

Transform the domain of the image. For Log Domain, return the log of the image.
"""
@inline transform_domain(::LogDomain, x::AbstractArray) =  @inbounds log.(abs.(real(x)))