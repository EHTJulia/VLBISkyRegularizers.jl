export LinearDomain, LogDomain, ParameterDomain, CLRDomain, ALRDomain, WaveletDomain
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
# image/evaluation domain
abstract type AbstractDomain end

# computing domain
struct LinearDomain <: AbstractDomain end
struct LogDomain <: AbstractDomain end
struct ParameterDomain <: AbstractDomain end
struct CLRDomain <: AbstractDomain end
struct ALRDomain <: AbstractDomain end
struct WaveletDomain{wt<:OrthoFilter, l} <: AbstractDomain
    wavelet::wt
    level::l

    function WaveletDomain(wt::OrthoFilter, levels::Integer)
        return new{typeof(wt), typeof(levels)}(wt, levels)
    end

    function WaveletDomain(wt::OrthoFilter, image::AbstractArray)
        levels = floor(Int, log2(size(image)[1]))
        return new{typeof(wt), typeof(levels)}(wt, levels)
    end
    
    function WaveletDomain(wt::OrthoFilter)
        levels = nothing
        return new{typeof(wt), typeof(levels)}(wt, levels)
    end

    function WaveletDomain()
        levels = nothing
        wt = wavelet(WT.db2)
        return new{typeof(wt), typeof(levels)}
    end
end

@inline transform_linear(::LinearDomain, x::AbstractArray) = x
@inline transform_linear(::LogDomain, x::AbstractArray) = exp.(x)
@inline transform_linear(::CLRDomain, x::AbstractArray) = to_simplex(CenteredLR(), x)
@inline transform_linear(::ALRDomain, x::AbstractArray) = to_simplex(AdditiveLR(), x)

"""
    transform_domain(::LinearDomain, x::AbstractArray)

Transform the domain of the image. For Linear Domain, this does not change the image.
"""
@inline transform_domain(::AbstractDomain, ::ParameterDomain, x::AbstractArray) = x
@inline transform_domain(::D, ::D, x::AbstractArray) where {D <: AbstractDomain} = x

@inline transform_domain(id::AbstractDomain, ::LogDomain, x::AbstractArray) = @inbounds log.(abs.(real(transform_linear(id, x))))
@inline transform_domain(id::AbstractDomain, ::LinearDomain, x::AbstractArray) = transform_linear(id, x)
@inline transform_domain(id::AbstractDomain, wd::WaveletDomain, x::AbstractArray) = isnothing(wd.level) ? dwt(transform_linear(id, x), wd.wavelet) : dwt(transform_linear(id, x), wd.wavelet, wd.level)