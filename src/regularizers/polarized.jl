export PSDistance, evaluate, PolarizationDomain, LP, CP

abstract type PolarizationDomain <: AbstractDomain end

struct LP <: PolarizationDomain end
struct CP <: PolarizationDomain end

struct PSDistance{H<:Number,PD<:PolarizationDomain, G<:RectiGrid} <: AbstractRegularizer
    hyperparameter::H
    polarization_domain::PD
    grid::G
end

# function label
functionlabel(::PSDistance) = "Poincare Sphere Distance"


function psd_base(λ1::Number, λ2::Number, ϕ1::Number, ϕ2::Number)
    return acos(sin(2*ϕ1) * sin(2*ϕ2) + cos(2*ϕ1) * cos(2*ϕ2) * cos(abs(2*λ1 - 2*λ2)))
end

function linear_psd_base(λ1::Number, λ2::Number)
    return acos(cos(abs(2*λ1 - 2*λ2)))
end


function psd_base(θ::AbstractArray{Float64, 3})
    @tullio td = psd_base(θ[i,j,1], θ[i+1,j,1], θ[i,j,2], θ[i+1,j,2])
    @tullio td += psd_base(θ[i,j,1], θ[i,j+1,1], θ[i,j,2], θ[i,j+1,2])
    return td
end 

function psd_base(θ::AbstractArray{Float64, 2})
    @tullio td = linear_psd_base(θ[i,j], θ[i+1,j])
    @tullio td += linear_psd_base(θ[i,j], θ[i,j+1])
    return td
end 

function psd_base(θ::AbstractArray, w::Number)
    return w * psd_base(θ)
end

function evaluate(reg::PSDistance, θ::AbstractArray)
    return psd_base(θ, reg.hyperparameter)
end


image_domain(::PSDistance) = nothing
evaluation_domain(::PSDistance) = nothing


Base.size(r::PSDistance{A, CP, B}) where {A,B} = (size(grid(r))..., 2)
Base.size(r::PSDistance{A, LP, B}) where {A,B} = size(grid(r))

function HypercubeTransform.asflat(r::PSDistance)
    return as(Array, (size(r)))
end

function Distributions._rand!(rng::Random.AbstractRNG, ::PSDistance{A, CP, B}, x::AbstractArray{<:Real}) where {A, B}
    g_size = size(x)[1:2]
    ψ = rand(rng, Uniform(0, π), g_size)
    χ = rand(rng, Uniform(0, π/2), g_size)
    x[:,:,1] = ψ
    x[:,:,2] = χ
    return x
end

function Distributions._rand!(rng::Random.AbstractRNG, ::PSDistance{A, LP, B}, x::AbstractMatrix{<:Real}) where {A, B}
    return rand!(rng, Uniform(0, π), x)
end

function Distributions.logpdf(r::PSDistance, x::AbstractArray{<:Real})
    return -1*evaluate(r, x)
end
