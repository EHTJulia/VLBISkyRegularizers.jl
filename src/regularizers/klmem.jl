export KLE, klentropy_base

"""
    KLEntropy <: AbstractRegularizer

Regularizer using the Kullback-Leibler divergence (or a relative entropy)

# fields
- `hyperparameter::Number`: the hyperparameter of the regularizer
- `prior`: the prior image
- `domain::AbstractRegularizerDomain`: the image domain where the regularization funciton will be computed.
    KLEntropy can be computed only in `LinearDomain()`.
"""
struct KLE{H<:Number,ID<:AbstractDomain,ED<:AbstractDomain,P<:AbstractArray,G<:RectiGrid} <: AbstractRegularizer
    hyperparameter::H
    image_domain::ID
    evaluation_domain::ED
    prior::P
    grid::G

    function KLE(h::Number, id::AbstractDomain, ed::AbstractDomain, g::RectiGrid)
        fovGx, fovGy = fieldofview(g)
        gaussPrior = modify(Gaussian(), Stretch(fovGx/2., fovGy/2.))
        gpArray = Array(intensitymap(gaussPrior, g))
        gpArray = gpArray ./ sum(gpArray)
        return new{typeof(h), typeof(id), typeof(ed), typeof(gpArray), typeof(g)}(h,id,ed,gpArray,g)
    end

    function KLE(h::Number, id::AbstractDomain, ed::AbstractDomain, p::AbstractArray, g::RectiGrid)
        # shortcut for normalizing p and enforcing positivity
        pnorm = transform_linear(LinearDomain(), p)
        return new{typeof(h), typeof(id), typeof(ed), typeof(pnorm), typeof(g)}(h,id,ed,pnorm,g)
    end

end

# function label
functionlabel(::KLE) = "KL Entropy"

"""
    klentropy_base(x::AbstractArray, p::AbstractArray)

Base function of the KL-Entropy norm.

# Arguments
- `I::IntensityMap`: the image
- `p::IntensityMap`: the prior image
"""
function klentropy_base(x::AbstractArray, p::AbstractArray)
    # shortcut for normalizing x and enforcing positivity
    xnorm = transform_image(LinearDomain(), x)
    @inbounds xlogx = xnorm .* log.((xnorm .+ 10e-100) ./ p)
    return sum(xlogx)
end

function klentropy_base(x::AbstractArray, p::AbstractArray, w::Number)
    return w * klentropy_base(x,p)
end

function evaluate(reg::KLE, x::AbstractArray)
    return klentropy_base(transform_domain(reg.image_domain, reg.evaluation_domain, x), reg.prior, reg.hyperparameter)
end
