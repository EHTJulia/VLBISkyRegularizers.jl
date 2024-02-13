export TV

"""
    TV <: AbstractRegularizer

Regularizer using the Isotropic Total Variation.

# fields
- `hyperparameter::Number`: the hyperparameter of the regularizer
- `weight`: the weight of the regularizer, which could be a number or an array.
- `domain::AbstractRegularizerDomain`: the image domain where the regularization funciton will be computed. L1Norm can be computed only in `LinearDomain()`.
"""
struct TV{S<:Number,T,D<:AbstractRegularizerDomain} <: AbstractRegularizer
    hyperparameter::S
    weight::T
    domain::D
end

# function label
functionlabel(::TV) = :tv

"""
    tv_base_pixel(I::IntensityMap, ix::Integer, iy::Integer)

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
    tv_base_grad_pixel(I::IntensityMap, ix::Integer, iy::Integer)

Evaluate the gradient of the isotropic variation term for the given pixel

# Arguments
- `I::IntensityMap`: the image
"""

@inline function tv_base_grad_pixel(I::IntensityMap, ix::Integer, iy::Integer)
    nx = size(I, 1)
    ny = size(I, 2)
    
    i1 = ix
    j1 = iy
    i0 = i1 - 1
    j0 = j1 - 1
    i2 = i1 + 1
    j2 = j1 + 1

    grad = 0.0

    # For ΔIx = I[i+1, j] - I[i,j], ΔIy = I[i, j+1] - I[i,j]
    if i2 > nx
        ΔIx = 0.0
    else
        @inbounds ΔIx = I[i2, j1] - I[i1, j1]
    end

    if j2 > ny
        ΔIy = 0.0
    else
        @inbounds ΔIy = I[i1, j2] - I[i1, j1]
    end

    tv = √(ΔIx^2 + ΔIy^2)
    if tv > 0
        grad += -(ΔIx + ΔIy) / tv
    end

    # For ΔIx = I[i, j] - I[i-1,j], ΔIy = I[i-1, j+1] - I[i-1,j]
    if (i0 > 0)
        @inbounds ΔIx = I[i1, j1] - I[i0, j1]

        if j2 > ny
            ΔIy = 0.0
        else
            @inbounds ΔIy = I[i0, j2] - I[i0, j1]
        end

        tv = √(ΔIx^2 + ΔIy^2)
        if tv > 0
            grad += ΔIx / tv
        end
    end

    # For ΔIx = I[i+1, j-1] - I[i,j-1], ΔIy = I[i, j] - I[i,j-1]
    if (j0 > 0)
        if i2 > nx
            ΔIx = 0.0
        else
            @inbounds ΔIx = I[i2, j0] - I[i1, j0]
        end

        @inbounds ΔIy = I[i1, j1] - I[i1, j0]

        tv = √(ΔIx^2 + ΔIy^2)
        if tv > 0
            grad += ΔIy / tv
        end
    end

    return grad
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
    tv_base_gradl(I::IntensityMap)

Evaluate the gradient of the isotropic variation term

# Arguments
- `I::IntensityMap`: the image
"""

@inline function tv_base_grad(I::IntensityMap)
    nx = size(I, 1)
    ny = size(I, 2)
    grad = zeros(nx, ny)
    for iy = 1:ny, ix = 1:nx
        @inbounds grad[ix, iy] = tv_base_grad_pixel(I, ix, iy)
    end
    return grad
end


function ChainRulesCore.rrule(::typeof(tv_base), I::IntensityMap)
    y = tv_base(I)
    function pullback(Δy)
        fbar = NoTangent()
        xbar = @thunk(tv_base_grad(I) .* Δy)
        return fbar, xbar
    end
    return y, pullback
end



"""
    tv_base(I::IntensityMap, w::Number)

Base function of the isotropic total variation.

# Arguments
- `I::IntensityMap`: the image
- 'w::Number' : the regularization weight
"""
@inline function tv_base(I::IntensityMap, w::Number)
    return w * tv_base(I)
end


function ChainRulesCore.rrule(::typeof(tv_base), I::IntensityMap, w::Number)
    y = tv_base(I, w)
    function pullback(Δy)
        fbar = NoTangent()
        xbar = @thunk(w .* tv_base_grad(I) .* Δy)
        wbar = NoTangent()
        return fbar, xbar, wbar
    end
    return y, pullback
end



"""
    evaluate(::AbstractRegularizer, skymodel::IntensityMap, x::IntensityMap)
"""
function evaluate(::LinearDomain, reg::TV, skymodel::IntensityMap, x::IntensityMap)
    return tv_base(transform_linear_forward(skymodel, x), reg.weight)
end
