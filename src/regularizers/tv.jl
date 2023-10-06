export TV

"""
    TV <: AbstractRegularizer

Regularizer using the Isotropic Total Variation.

# fields
- `hyperparameter::Number`: the hyperparameter of the regularizer
- `weight`: the weight of the regularizer, which could be a number or an array.
- `domain::AbstractRegularizerDomain`: the image domain where the regularization funciton will be computed. L1Norm can be computed only in `LinearDomain()`.
"""
struct TV{S,T,D} <: AbstractRegularizer
    hyperparameter::S
    weight::T
    domain::D
end

# function label
functionlabel(::TV) = :tv

"""
    tv_base_pixel(I::AbstractArray, ix::Integer, iy::Integer)

Evaluate the isotropic variation term for the given pixel

# Arguments
- `I::IntensityMap`: the image
"""
@inline function tv_base_pixel(I::IntensityMap, ix::Integer, iy::Integer)
    nx = size(I, 1)
    ny = size(I, 2)

    if ix < nx
        @inbounds ΔIx = I[ix+1, iy] - I[ix, iy]
    else
        ΔIx = 0
    end

    if iy < ny
        @inbounds ΔIy = I[ix, iy+1] - I[ix, iy]
    else
        ΔIy = 0
    end

    return √(ΔIx^2 + ΔIy^2)
end

"""
    tv_base(I::IntensityMap)

Base function of the isotropic total variation.

# Arguments
- `I::IntensityMap`: the image
"""
@inline function tv_base(I::IntensityMap)
    value = 0.0
    for iy = 1:size(I, 2), ix = 1:size(I, 1)
        value += tv_base_pixel(I, ix, iy)
    end
    return value
end


"""
    tv_base(I::IntensityMap, w::Number)

Base function of the isotropic total variation.

# Arguments
- `I::IntensityMap`: the image
- 'w::Number' : the regularization weight
"""
@inline function tv_base(I::AbstractArray, w::Number)
    return w * tv_base(I)
end


"""
    evaluate(::AbstractRegularizer, skymodel::AbstractImage2DModel, x::AbstractArray)
"""
function evaluate(::LinearDomain, reg::TV, skymodel::IntensityMap, x::AbstractArray)
    return tv_base(transform_linear_forward(skymodel, x), reg.weight)
end