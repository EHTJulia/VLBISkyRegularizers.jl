export WaveletL1, evaluate, WVType

"""
    WVType

Wavelet type used for Wavelet Transform L1 Regularizer.
By default, this is the full Daubechies 2 wavelet.
"""
struct WVType{wt<:OrthoFilter, l}
    wavelet::wt
    level::l

    function WVType(wt::OrthoFilter, levels::Integer)
        return new{typeof(wt), typeof(levels)}(wt, levels)
    end

    function WVType(wt::OrthoFilter, image::AbstractArray)
        levels = floor(Int, log2(size(image)[1]))
        return new{typeof(wt), typeof(levels)}(wt, levels)
    end
    
    function WVType(wt::OrthoFilter)
        levels = nothing
        return new{typeof(wt), typeof(levels)}(wt, levels)
    end

    function WVType()
        levels = nothing
        wt = wavelet(WT.db2)
        return new{typeof(wt), typeof(levels)}(wt, levels)
    end
end

"""
    WaveletL1 <: AbstractRegularizer

Regularizer using the l1-norm with a wavelet transform

# fields
- `hyperparameter::Number`: the hyperparameter of the regularization function.
- `image_domain::AbstractDomain`: the domain of the image space 
- `evaluation_domain::AbstractDomain`: the domain on which the regularizer is to be evaluated
- `wavelet::WVType`: wavelet type
- `grid`: grid on which image is defined
"""
struct WaveletL1{H<:Number,ID<:AbstractDomain,ED<:AbstractDomain,WT<:WVType, G<:RectiGrid} <: AbstractRegularizer
    hyperparameter::H
    image_domain::ID
    evaluation_domain::ED
    w_type::WT
    grid::G
end

# function label
functionlabel(::WaveletL1) = "Wavelet L1"

"""
    wavelet_l1_base(x::AbstractArray, wv::WaveletL1)

Base function of the Wavelet L1 norm.

# Arguments
- `x::AbstractArray`: the image
- `wv::WVType` : the wavelet transform type
"""
@inline wavelet_transform(x::AbstractArray, wv::WVType) = isnothing(wv.level) ? dwt(x, wv.wavelet) : dwt(x, wv.wavelet, wv.level)
@inline inv_wavelet_transform(x::AbstractArray, wv::WVType) = isnothing(wv.level) ? idwt(x, wv.wavelet) : idwt(x, wv.wavelet, wv.level)

@inline wavelet_l1_base(x::AbstractArray, wv::WVType) = @inbounds sum(abs.(wavelet_transform(x, wv)))


"""
    l1_base_wavelet(x::AbstractArray, wv::WaveletL1, w::Number)

Base function of the Wavelet L1 norm.

# Arguments
- `x::AbstractArray`: the image
- `wv::WVType` : the wavelet transform type
- `w::Number` : weight of the regularizer
"""

@inline l1_base_wavelet(x::AbstractArray, wv::WVType, w::Number) =  w * wavelet_l1_base(x, wv)


"""
    evaluate(reg::WaveletL1, x::AbstractArray)

Evaluate the Wavelet L1 norm regularizer at an image.

# Arguments
- `reg::WaveletL1`: WaveletL1 norm regularizer
- `x::AbstractArray`: the image
"""

function evaluate(reg::WaveletL1, x::AbstractArray)
    return l1_base_wavelet(transform_domain(reg.image_domain, reg.evaluation_domain, x), reg.w_type, reg.hyperparameter)
end


# Custom rules for wavelet transform
# For some reason, Enzyme sometimes want wv as a Const, sometimes as a MixedDuplicated, so implement both
function EnzymeRules.augmented_primal(config::ConfigWidth{1}, func::Const{typeof(wavelet_l1_base)}, ::Type{<:Active}, x::Duplicated, wv::MixedDuplicated)
    # Compute primal
    primal = func.val(x.val, wv.val)
    # Return an AugmentedReturn object with shadow = nothing
    return AugmentedReturn(primal, nothing, x.val)
end

function EnzymeRules.reverse(config::ConfigWidth{1}, func::Const{typeof(wavelet_l1_base)}, dret::Active, tape, x::Duplicated, wv::MixedDuplicated)
    ddx = zeros(size(x.val))
    p = wavelet_transform(x.val, wv.val)
    autodiff(Enzyme.Reverse, l1_base, Active, Duplicated(p, ddx))
    x.dval .+=  inv_wavelet_transform(ddx, wv.val) .* dret.val
    return (nothing, nothing)
end

function EnzymeRules.augmented_primal(config::ConfigWidth{1}, func::Const{typeof(wavelet_l1_base)}, ::Type{<:Active}, x::Duplicated, wv::Const)
    # Compute primal (not needed here?)
    primal = func.val(x.val, wv.val)
    # Return an AugmentedReturn object with shadow = nothing
    return AugmentedReturn(nothing, nothing, x.val)
end

function EnzymeRules.reverse(config::ConfigWidth{1}, func::Const{typeof(wavelet_l1_base)}, dret::Active, tape, x::Duplicated, wv::Const)
    ddx = zeros(size(x.val))
    p = wavelet_transform(x.val, wv.val)
    autodiff(Enzyme.Reverse, l1_base, Active, Duplicated(p, ddx))
    x.dval .+=  inv_wavelet_transform(ddx, wv.val) .* dret.val
    return (nothing, nothing)
end