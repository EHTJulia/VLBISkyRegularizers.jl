export WaveletL1, evaluate, WVType
"""
    Wavelet L1Norm <: AbstractRegularizer

Regularizer using the l1-norm with a wavelet transform

# fields
- `hyperparameter::Number`: the hyperparameter of the regularizer
- `weight`: the weight of the regularizer, which could be a number or an array.
- `domain::AbstractRegularizerDomain`: the image domain where the regularization funciton will be computed.
- `levels`: number of levels to transform (can also give image, in which case the number of levels is calculated from the image size)
- `wavelet`: wavelet type
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

struct WaveletL1{H<:Number,ID<:AbstractDomain,ED<:AbstractDomain,WT<:WVType, G<:RectiGrid} <: AbstractRegularizer
    hyperparameter::H
    image_domain::ID
    evaluation_domain::ED
    w_type::WT
    grid::G
end

# function label
functionlabel(::WaveletL1) = :waveletL1

"""
    l1_base(x::AbstractArray)

Base function of the L1 norm.

# Arguments
- `x::AbstractArray`: the image
"""
@inline wavelet_transform(x::AbstractArray, wv::WaveletL1) = isnothing(wv.w_type.level) ? dwt(x, wv.w_type.wavelet) : dwt(x, wv.w_type.wavelet, wv.w_type.level)
@inline inv_wavelet_transform(x::AbstractArray, wv::WaveletL1) = isnothing(wv.w_type.level) ? idwt(x, wv.w_type.wavelet) : idwt(x, wv.w_type.wavelet, wv.w_type.level)

@inline wavelet_l1_base(x::AbstractArray, wv::WaveletL1) = @inbounds sum(abs.(wavelet_transform(x, wv)))


"""
    l1_base(x::AbstractArray, w::Number)

Base function of the L1 norm.

# Arguments
- `x::AbstractArray`: the image
- 'w::Number' : the regularization weight
"""

@inline l1_base_wavelet(x::AbstractArray, wv::WaveletL1, w::Number) =  w * wavelet_l1_base(x, wv)


"""
    evaluate(reg::L1, x::AbstractArray)

Evaluate the L1 norm regularizer at an image.

# Arguments
- `reg::L1`: L1 norm regularizer
- `x::AbstractArray`: the image
"""

function evaluate(reg::WaveletL1, x::AbstractArray)
    return l1_base_wavelet(transform_domain(reg.image_domain, reg.evaluation_domain, x), reg, reg.hyperparameter)
end



function EnzymeRules.augmented_primal(config::ConfigWidth{1}, func::Const{typeof(wavelet_l1_base)}, ::Type{<:Active}, x::Duplicated, wv::Const)
    println("In custom augmented primal rule 2.")
    # Compute primal

    primal = func.val(x.val, wv.val)
    println("hello")
    # Return an AugmentedReturn object with shadow = nothing
    return AugmentedReturn(nothing, nothing, x.val)
end

function EnzymeRules.reverse(config::ConfigWidth{1}, func::Const{typeof(wavelet_l1_base)}, dret::Active, tape, x::Duplicated, wv::Const)
    println("In custom reverse rule.")
    # accumulate dret into x's shadow. don't assign!
    ddx = zeros(size(x.val))
    p = wavelet_transform(x.val, wv.val)
    autodiff(Enzyme.Reverse, l1_base, Active, Duplicated(p, ddx))
    x.dval .+=  inv_wavelet_transform(ddx, wv.val) .* dret.val
    return (nothing, nothing)
end



"""dwt(transform_linear(id, x), wd.wavelet)
function ChainRulesCore.rrule(::typeof(dwt), x::AbstractArray, wavelet::OrthoFilter)
    y = dwt(x, wavelet)
    function pullback(Δy)
        fbar = NoTangent()
        xbar = @thunk(idwt(x, wavelet)*Δy)
        wbar = NoTangent()
        return fbar, xbar, wbar
    end
    return y, pullback
end
"""

"""
    l1norm(I::IntensityMap, w::Number, levels::Integer, wavelet::OrthoFilter)

Base function of the wavelet-l1norm.

# Arguments
- `I::IntensityMap`: the image
- `w::Number`: the regularization weight
- `levels::Integer`: number of levels for wavelet transform
- `wavelet::OrthoFilter`: wavelet type
"""
#@inline l1norm(I::AbstractArray, w::Number, levels::Integer, wavelet::OrthoFilter) = w * l1norm(I,levels,wavelet)

"""
    evaluate(::AbstractRegularizer, skymodel::IntensityMap, x::IntensityMap)
"""
#function evaluate(::LinearDomain, reg::WaveletL1Norm, skymodel::AbstractArray, x::AbstractArray)
#    return l1norm(transform_domain(skymodel, x), reg.weight, reg.levels, reg.wavelet)
#end
