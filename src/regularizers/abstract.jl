export AbstractRegularizer, image_domain, evaluation_domain, evaluate, functionlabel, grid

"""
    AbstractRegularizer

Used to define the regularizer functions. See `subtypes(AbstractRegularizer)` for a list of implemented regularizers.

# Mandatory fields

- `hyperparameter::Number`: the hyperparameter of the regularization function.
- `image_domain::AbstractDomain`: the domain of the image space 
- `evaluation_domain::AbstractDomain`: the domain on which the regularizer is to be evaluated
- `grid`: grid on which image is defined
"""
abstract type AbstractRegularizer <: ContinuousMatrixDistribution end

# function to get the label for regularizer
functionlabel(::AbstractRegularizer) = :namelessregularizer


# functions to get domains and hyperparameter
"""
    image_domain(reg::AbstractRegularizer)

Return the image domain of the given regularizer.
"""
image_domain(reg::AbstractRegularizer) = reg.image_domain

"""
    evaluation_domain(reg::AbstractRegularizer)

Return the evaluation domain of the given regularizer.
"""
evaluation_domain(reg::AbstractRegularizer) = reg.evaluation_domain

"""
    grid(reg::AbstractRegularizer)

Return the grid on which an image to be regularized is defined.
"""
grid(reg::AbstractRegularizer) = reg.grid

"""
    regularizers(::AbstractRegularizer)

List regularizers used.
"""
regularizers(r::AbstractRegularizer) = (r,)

"""
    evaluate(::AbstractRegularizer, ::AbstractArray)

Compute the value of the given regularization function on the input image.
By default, return 0.
"""
evaluate(reg::AbstractRegularizer, image::AbstractArray) = 0


Base.size(r::AbstractRegularizer) = size(grid(r))
Base.length(r::AbstractRegularizer) = length(grid(r))

function HypercubeTransform.asflat(r::AbstractRegularizer)
    return as(Array, size(r))
end


"""
    Distributions._logpdf(d::Regularizers, image::AbstractMatrix{<:Real})
The log density of the regularizers evaluated at the input image. .

# Arguments
- `reg::Regularizers`: the regularizer functions.
- `image::AbstractMatrix{<:Real}`: the model of the input image
"""
function Distributions._logpdf(r::AbstractRegularizer, x::AbstractMatrix{<:Real})
    return -1*evaluate(r, x)
end

"""
    Distributions._rand!(rng::Random.AbstractRNG, ::Regularizers, x::AbstractMatrix)
Return a random sample of shape equal to the shape of the input matrix

# Arguments
- `rng::Random.AbstractRNG`: an RNG seed object
- `::Regularizers`: any set of regularizer functions
- `x::AbstractMatrix`: input matrix
"""
function Distributions._rand!(rng::Random.AbstractRNG, ::AbstractRegularizer, x::AbstractMatrix)
    return rand!(rng, x)
end


function Base.show(io::IO, r::AbstractRegularizer)
    println(io, ' '^get(io, :indent, 0), "Regularizer:          ", functionlabel(r) )
    println(io, ' '^get(io, :indent, 0), "Hyperparameter:       ", r.hyperparameter )
    println(io, ' '^get(io, :indent, 0), "Evaluation Domain:    ", evaluation_domain(r) )
    id = get(io, :id, true)
    if id
        println(io, ' '^get(io, :indent, 0), "Image Domain:         ", image_domain(r))
        fovX, fovY = rad2μas.(values(fieldofview(grid(r))))
        println(io, ' '^get(io, :indent, 0), "Grid FOV:             ", round(fovX, digits=2), "x", round(fovY, digits=2), " μas")
        sx, sy = size(grid(r))
        println(io, ' '^get(io, :indent, 0), "Grid Size:            ", sx, "x", sy)
    end
end