export Regularizers

"""
    Regularizers

# Mandatory fields
- `regularizers::NTuple{N, AbstractRegularizer}`: Tuple of AbstractRegularizer objects
- `grid`: grid on which the image is defined
"""
struct Regularizers{rr<:NTuple{N, AbstractRegularizer} where N, g} <: ContinuousMatrixDistribution
    regularizers::rr
    grid::g
end

# Base Functions
Base.size(d::Regularizers) = size(d.grid)
Base.length(d::Regularizers) = length(d.grid)

function HypercubeTransform.asflat(d::Regularizers)
    return as(Array, size(d))
end


"""
    Distributions._logpdf(d::Regularizers, image::AbstractMatrix{<:Real})
The log density of the regularizers evaluated at the input image. .

# Arguments
- `reg::Regularizers`: the regularizer functions.
- `image::AbstractMatrix{<:Real}`: the model of the input image
"""
function Distributions._logpdf(d::Regularizers, x::AbstractMatrix{<:Real})
    rrs = d.regularizers
    return sum(map(r -> -1*evaluate(r, x), rrs))
end

"""
    Distributions._rand!(rng::Random.AbstractRNG, ::Regularizers, x::AbstractMatrix)
Return a random sample of shape equal to the shape of the input matrix

# Arguments
- `rng::Random.AbstractRNG`: an RNG seed object
- `::Regularizers`: any set of regularizer functions
- `x::AbstractMatrix`: input matrix
"""
function Distributions._rand!(rng::Random.AbstractRNG, ::Regularizers, x::AbstractMatrix)
    return rand!(rng, x)
end

