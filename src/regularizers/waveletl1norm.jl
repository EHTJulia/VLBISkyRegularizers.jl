export WaveletL1Norm
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
struct WaveletL1Norm{H<:Number,ID<:RegularizerDomain,ED<:RegularizerDomain,G<:Rectigrid,L<:Integer,W<:OrthoFilter} <: Regularizer
    hyperparameter::H
    image_domain::ID
    evaluation_domain::ED
    grid::G
    levels::L
    wavelet::W

    function WaveletL1Norm(hyperparameter::Number, image_domain::RegularizerDomain, evaluation_domain::RegularizerDomain,
        grid::RectiGrid, image::AbstractArray, wavelet::OrthoFilter)
        levels = floor(Int, log2(size(image)[1])-1)
        return new{typeof(hyperparameter), typeof(image_domain), typeof(evaluation_domain), typeof(grid), typeof(levels),typeof(wavelet)}(
            hyperparameter, image_domain, evaluation_domain, grid, levels, wavelet
            )
    end

    function WaveletL1Norm(hyperparameter::Number, image_domain::RegularizerDomain, evaluation_domain::RegularizerDomain,
        grid::RectiGrid, levels::Integer, wavelet::OrthoFilter)
        return new{typeof(hyperparameter), typeof(image_domain), typeof(evaluation_domain), typeof(grid), typeof(levels),typeof(wavelet)}(
            hyperparameter, image_domain, evaluation_domain, grid, levels, wavelet
            )
    end


end

# function label
functionlabel(::WaveletL1Norm) = :waveletl1norm

"""
    waveletl1norm(I::IntensityMap, levels::Integer, wavelet::OrthoFilter)

Base function of the wavelet-l1norm.

# Arguments
- `I::IntensityMap`: the image
- `levels::Integer`: number of levels for wavelet transform
- `wavelet::OrthoFilter`: wavelet type
"""
function l1norm(I::AbstractArray, levels::Integer, wavelet::OrthoFilter)
    wvim = dwt(I, wavelet, levels)
    return sum(abs.(wvim))
end


"""
function ChainRulesCore.rrule(::typeof(l1norm), I::IntensityMap, levels::Integer, wavelet::OrthoFilter)
    y = sum(abs.(dwt(I, wavelet, levels)))
    function pullback(Δy)
        fbar = NoTangent()
        Ibar = @thunk(idwt(I, wavelet, levels)*Δy)
        lbar = NoTangent()
        wbar = NoTangent()
        return fbar, Ibar, lbar, wbar
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
@inline l1norm(I::AbstractArray, w::Number, levels::Integer, wavelet::OrthoFilter) = w * l1norm(I,levels,wavelet)

"""
    evaluate(::AbstractRegularizer, skymodel::IntensityMap, x::IntensityMap)
"""
function evaluate(::LinearDomain, reg::WaveletL1Norm, skymodel::AbstractArray, x::AbstractArray)
    return l1norm(transform_domain(skymodel, x), reg.weight, reg.levels, reg.wavelet)
end
