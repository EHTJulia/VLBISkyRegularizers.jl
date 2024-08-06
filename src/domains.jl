export LinearDomain, LogDomain, ParameterDomain, CLRDomain, ALRDomain, AbstractDomain, transform_image
"""
    AbstractDomain

Used to define the image and evaluation domains. See `subtypes(AbstractDomain)` for a list of possible domains.
"""
# Image and evaluation domains
abstract type AbstractDomain end

"""
    LinearDomain

Can be used as an image and evaluation domain.
No transformation in evaluation. Image transformation normalizes the image by the sum and absolute value.
"""
struct LinearDomain <: AbstractDomain end

"""
    LogDomain

Can be used as an image and evaluation domain.
Logarithmic transformation in evaluation. Image transformation is the softmax function (applies the exponential
function and normalizes by the sum).
"""
struct LogDomain <: AbstractDomain end

"""
    ParameterDomain

Can only be used as an evaluation domain. Sets the evaluation domain equal to the image domain.
"""
struct ParameterDomain <: AbstractDomain end

"""
    CLRDomain

Centered Log-Ratio transformation. Can only be used as an image domain. 
Image transformation is the softmax function (applies the exponential function and normalizes by the sum).
"""
struct CLRDomain <: AbstractDomain end

"""
    ALRDomain

Additive Log-Ratio transform. Can only be used as an image domain.
Image transformation is the inverse ALR function. Similar to softmax but treats one pixel (the last pixel) as special.
"""
struct ALRDomain <: AbstractDomain end

# Standard image transforms
"""
    transform_image(::AbstractDomain, x::AbstractArray)

Transforms an array to the normalized, non-negative image domain.
"""
transform_image(::AbstractDomain, ::AbstractArray) = error("Invalid image domain.")
transform_image(::LinearDomain, x::AbstractArray) = abs.(x./sum(x))
transform_image(::LogDomain, x::AbstractArray) = to_simplex(CenteredLR(), x)
transform_image(::CLRDomain, x::AbstractArray) = to_simplex(CenteredLR(), x)
transform_image(::ALRDomain, x::AbstractArray) = to_simplex(AdditiveLR(), x)

# Linear transforms
"""
    _transform_linear(::AbstractDomain, x::AbstractArray)

Transforms an array to the linear domain. Same as transform_image but does not necessarily impose
non-negativity and normalization.
"""
_transform_linear(::AbstractDomain, ::AbstractArray) = error("Invalid image domain.")
_transform_linear(::LinearDomain, x::AbstractArray) = x
_transform_linear(::LogDomain, x::AbstractArray) = exp.(x)
_transform_linear(::CLRDomain, x::AbstractArray) = to_simplex(CenteredLR(), x)
_transform_linear(::ALRDomain, x::AbstractArray) = to_simplex(AdditiveLR(), x)

# Evaluation transform
"""
    transform_domain(::LinearDomain, x::AbstractArray)

Transform the domain of the image to the evaluation domain.
"""
transform_domain(::AbstractDomain, ::AbstractDomain, ::AbstractArray) = error("Invalid evaluation domain")
transform_domain(::ParameterDomain, ::AbstractDomain, ::AbstractArray) = error("Image domain can not be ParameterDomain")
transform_domain(::AbstractDomain, ::ParameterDomain, x::AbstractArray) = x
transform_domain(::LogDomain, ::LogDomain, x::AbstractArray) = x
transform_domain(::LinearDomain, ::LinearDomain, x::AbstractArray) = x

transform_domain(id::AbstractDomain, ::LogDomain, x::AbstractArray) = log.(abs.(real(_transform_linear(id, x))))
transform_domain(id::AbstractDomain, ::LinearDomain, x::AbstractArray) = _transform_linear(id, x)