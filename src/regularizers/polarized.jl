export PSDistance, evaluate

struct PSDistance{H<:Number,G<:RectiGrid} <: AbstractRegularizer
    hyperparameter::H
    grid::G
end

# function label
functionlabel(::PSDistance) = "Poincare Sphere Distance"


function psd_base(λ1::Number, λ2::Number, ϕ1::Number, ϕ2::Number)
    return acos(sin(ϕ1) * sin(ϕ2) + cos(ϕ1) * cos(ϕ2) * cos(abs(λ1 - λ2)))
end

function psd_base(θ::AbstractArray{Float64, 3})
    @tullio td = psd_base(θ[i,j,1], θ[i+1,j,1], θ[i,j,2], θ[i+1,j,2])
    @tullio td += psd_base(θ[i,j,1], θ[i,j+1,1], θ[i,j,2], θ[i,j+1,2])
    return td
end 

function psd_base(θ::AbstractArray{Float64, 3}, w::Number)
    return w * psd_base(θ)
end

function evaluate(reg::PSDistance, θ::AbstractArray{Float64, 3})
    return psd_base(θ, reg.hyperparameter)
end

image_domain(::PSDistance) = nothing
evaluation_domain(::PSDistance) = nothing


Base.size(r::PSDistance) = (size(grid(r))..., 2)

function HypercubeTransform.asflat(r::PSDistance)
    return as(Array, (size(r)))
end

function Distributions._rand!(rng::Random.AbstractRNG, ::PSDistance, x::AbstractMatrix)
    return rand!(rng, Uniform(0, 2π), x)
end

function Distributions.logpdf(r::PSDistance, x::AbstractArray{<:Real})
    return -1*evaluate(r, x)
end
