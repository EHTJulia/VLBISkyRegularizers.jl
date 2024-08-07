export WeightRegularizer, AddRegularizer, regularizers, evaluate, grid, image_domain, evaluation_domain

"""
    AddRegularizer{R1<:AbstractRegularizer, R2<:AbstractRegularizer} <: AbstractRegularizer

Structure for adding two regularizers. 
    
The two regularizers must have the same grid and image domain.
"""
struct AddRegularizer{R1<:AbstractRegularizer, R2<:AbstractRegularizer} <: AbstractRegularizer
    r1::R1
    r2::R2

    function AddRegularizer(r1::AbstractRegularizer, r2::AbstractRegularizer)
        if image_domain(r1) != image_domain(r2)
            error("Image domains of regularizers must be the same")
        end
        if grid(r1) != grid(r2)
            error("Regularizer grids must be the same")
        end
        return new{typeof(r1), typeof(r2)}(r1, r2)
    end
end

"""
    WeightRegularizer{R<:AbstractRegularizer, W<:Number} <: AbstractRegularizer

Structure for weighting a regularizer by a scalar.
"""
struct WeightRegularizer{R<:AbstractRegularizer, W<:Number} <: AbstractRegularizer
    regularizer::R
    weight::W
end

# Functions for composite regularizers
added(r1::AbstractRegularizer, r2::AbstractRegularizer) = AddRegularizer(r1, r2)
weighted(r::AbstractRegularizer, w::Number) = WeightRegularizer(r, w)

Base.:+(r1::AbstractRegularizer, r2::AbstractRegularizer) = added(r1, r2)
Base.:*(r::AbstractRegularizer, w::Number) = weighted(r, w)
Base.:*(w::Number, r::AbstractRegularizer) = weighted(r, w)


function regularizers(r::AddRegularizer{R1, R2}) where {R1<:AbstractRegularizer, R2<:AbstractRegularizer}
    return (regularizers(r.r1)..., regularizers(r.r2)...)
end
function regularizers(r::WeightRegularizer{R1, w}) where {R1<:AbstractRegularizer, w<:Number}
    return regularizers(r.regularizer)
end

function evaluate(r::AddRegularizer{R1, R2}, x::AbstractArray) where {R1<:AbstractRegularizer, R2<:AbstractRegularizer}
    return evaluate(r.r1, x) + evaluate(r.r2, x)
end

function evaluate(r::WeightRegularizer{R1, w}, x::AbstractArray) where {R1<:AbstractRegularizer, w<:Number}
    return r.weight*evaluate(r.regularizer, x)
end

evaluation_domain(r::WeightRegularizer) = (evaluation_domain(r.regularizer),)
evaluation_domain(r::AddRegularizer) = (evaluation_domain(r.r1)..., evaluation_domain(r.r2)...)

image_domain(r::WeightRegularizer) = image_domain(r.regularizer)
image_domain(r::AddRegularizer) = image_domain(r.r1)

grid(r::WeightRegularizer) = grid(r.regularizer)
grid(r::AddRegularizer) = grid(r.r1)

#function Base.show(io::IO, mime::MIME"text/plain", r::AddRegularizer)
function Base.show(io::IO, r::AddRegularizer)
    indent = get(io, :indent, 0)
    println(io, ' '^indent, "Added Regularizer:")

    println(io, ' '^indent, "   Regularizer 1:")
    #show(IOContext(io, :indent => indent+6, :id => false), mime, r.r1)
    show(IOContext(io, :indent => indent+6, :id => false), r.r1)

    println(io, ' '^indent, "   Regularizer 2:")
    #show(IOContext(io, :indent => indent+6, :id => false), mime, r.r2)
    show(IOContext(io, :indent => indent+6, :id => false), r.r2)

    id = get(io, :id, true)
    if id    
        println(io, ' '^indent, "   Image Domain:   ", image_domain(r))
    end
    
end

function Base.show(io::IO, r::WeightRegularizer)
    indent = get(io, :indent, 0)
    println(io, ' '^indent, "Weighted Regularizer:")

    show(IOContext(io, :indent => indent+6, :id => false), r.regularizer)

    println(io, ' '^indent, "   Weight:   ", r.weight)
    id = get(io, :id, true)
    if id    
        println(io, ' '^indent, "   Image Domain:   ", image_domain(r))
    end
end
