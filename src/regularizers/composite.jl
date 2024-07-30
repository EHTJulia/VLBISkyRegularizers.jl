export WeightRegularizer, AddRegularizer, regularizers, evaluate

struct AddRegularizer{R1<:AbstractRegularizer, R2<:AbstractRegularizer, ID<:AbstractDomain} <: AbstractRegularizer
    r1::R1
    r2::R2
    image_domain::ID

    function AddRegularizer(r1::AbstractRegularizer, r2::AbstractRegularizer)
        if r1.image_domain == r2.image_domain
            return new{typeof(r1), typeof(r2), typeof(r1.image_domain)}(r1, r2, r1.image_domain)
        end
        error("Image domains of regularizers must be the same")
    end
end

struct WeightRegularizer{R<:AbstractRegularizer, W<:Number, ID<:AbstractDomain} <: AbstractRegularizer
    regularizer::R
    weight::W
    image_domain::ID

    function WeightRegularizer(r::AbstractRegularizer, w::Number)
        return new{typeof(r), typeof(w), typeof(r.image_domain)}(r, w, r.image_domain)
    end
end

@inline added(r1::AbstractRegularizer, r2::AbstractRegularizer) = AddRegularizer(r1, r2)
@inline weighted(r::AbstractRegularizer, w::Number) = WeightRegularizer(r, w)

Base.:+(r1::AbstractRegularizer, r2::AbstractRegularizer) = added(r1, r2)
Base.:*(r::AbstractRegularizer, w::Number) = weighted(r, w)
Base.:*(w::Number, r::AbstractRegularizer) = weighted(r, w)


regularizers(r::AbstractRegularizer) = (r,)
function regularizers(r::AddRegularizer{R1, R2}) where {R1<:AbstractRegularizer, R2<:AbstractRegularizer}
    return (regularizers(r.r1,)..., regularizers(r.r2)...)
end
function regularizers(r::WeightRegularizer{R1, w}) where {R1<:AbstractRegularizer, w<:Number}
    return (regularizers(r.regularizer),)
end


function evaluate(r::AddRegularizer{R1, R2}, x::AbstractArray) where {R1<:AbstractRegularizer, R2<:AbstractRegularizer}
    return evaluate(r.r1, x) + evaluate(r.r2, x)
end

function evaluate(r::WeightRegularizer{R1, w}, x::AbstractArray) where {R1<:AbstractRegularizer, w<:Number}
    return r.weight*evaluate(r.regularizer, x)
end