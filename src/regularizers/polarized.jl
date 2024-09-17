export PSDistance, evaluate, PolarizationDomain, LP, CP, chordDistance, angularDistance

abstract type PolarizationDomain <: AbstractDomain end
abstract type PSDDomain <: AbstractDomain end

struct LP <: PolarizationDomain end
struct CP <: PolarizationDomain end
struct chordDistance <: PSDDomain end
struct angularDistance <: PSDDomain end

struct PSDistance{H<:Number,PD<:PolarizationDomain, DD<:PSDDomain, G<:RectiGrid} <: AbstractRegularizer
    hyperparameter::H
    polarization_domain::PD
    distance_domain::DD
    grid::G
end

# function label
functionlabel(::PSDistance) = "Poincare Sphere Distance"
functionlabel(::chordDistance) = "Chord Length"
functionlabel(::angularDistance) = "Angular Distance"
functionlabel(::LP) = "Linear Polarization"
functionlabel(::CP) = "Full Polarization"

function psd_base(λ1::Number, λ2::Number, ϕ1::Number, ϕ2::Number)
    return acos(sin(2*ϕ1) * sin(2*ϕ2) + cos(2*ϕ1) * cos(2*ϕ2) * cos(abs(2*λ1 - 2*λ2)))
end

function linear_psd_base(λ1::Number, λ2::Number)
    return acos(cos(abs(2*λ1 - 2*λ2)))
end

function chord_base(θ::Number)
    return 2(1-cos(θ))
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

function chord_psd_base(θ::AbstractArray{Float64, 3})
    @tullio td = chord_base(psd_base(θ[i,j,1], θ[i+1,j,1], θ[i,j,2], θ[i+1,j,2]))
    @tullio td += chord_base(psd_base(θ[i,j,1], θ[i,j+1,1], θ[i,j,2], θ[i,j+1,2]))
    return td
end 

function chord_psd_base(θ::AbstractArray{Float64, 2})
    @tullio td = chord_base(2θ[i,j]-2θ[i+1,j])
    @tullio td += chord_base(2θ[i,j]-2θ[i,j+1])
    return td
end 



function psd_base(θ::AbstractArray, w::Number, ::chordDistance)
    return w * chord_psd_base(θ)
end

function psd_base(θ::AbstractArray, w::Number, ::angularDistance)
    return w * psd_base(θ)
end

function evaluate(reg::PSDistance, θ::AbstractArray)
    return psd_base(θ, reg.hyperparameter, reg.distance_domain)
end

image_domain(::PSDistance) = nothing
evaluation_domain(::PSDistance) = nothing


Base.size(r::PSDistance{A, CP, B, C}) where {A,B,C} = (size(grid(r))..., 2)
Base.size(r::PSDistance{A, LP, B, C}) where {A,B,C} = size(grid(r))

function HypercubeTransform.asflat(r::PSDistance)
    return as(Array, (size(r)))
end

function Distributions._rand!(rng::Random.AbstractRNG, ::PSDistance{A, CP, B, C}, x::AbstractArray{<:Real}) where {A, B, C}
    g_size = size(x)[1:2]
    ψ = rand(rng, Uniform(0, π), g_size)
    χ = rand(rng, Uniform(0, π/2), g_size)
    x[:,:,1] = ψ
    x[:,:,2] = χ
    return x
end

function Distributions._rand!(rng::Random.AbstractRNG, ::PSDistance{A, LP, B, C}, x::AbstractMatrix{<:Real}) where {A, B, C}
    return rand!(rng, Uniform(0, π), x)
end

function Distributions.logpdf(r::PSDistance, x::AbstractArray{<:Real})
    return -1*evaluate(r, x)
end


function Base.show(io::IO, r::PSDistance)
    println(io, ' '^get(io, :indent, 0), "Regularizer:          ", functionlabel(r) )
    println(io, ' '^get(io, :indent, 0), "Hyperparameter:       ", r.hyperparameter )
    println(io, ' '^get(io, :indent, 0), "Distance:             ", functionlabel(r.distance_domain) )
    println(io, ' '^get(io, :indent, 0), "Polarization:         ", functionlabel(r.polarization_domain) )
    id = get(io, :id, true)
    if id
        fovX, fovY = rad2μas.(values(fieldofview(grid(r))))
        println(io, ' '^get(io, :indent, 0), "Grid FOV:             ", round(fovX, digits=2), "x", round(fovY, digits=2), " μas")
        sx, sy = size(grid(r))
        println(io, ' '^get(io, :indent, 0), "Grid Size:            ", sx, "x", sy)
    end
end