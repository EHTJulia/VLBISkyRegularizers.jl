export PoincareSphereAngles2Map

function PoincareSphereAngles2Map(I, p, θ, grid)
    ψ, χ = θ[:,:,1], θ[:,:,2]
    Q = cos.(2ψ) .* cos.(2χ)
    U = sin.(2ψ) .* cos.(2χ)
    V = sin.(2χ)
    return PoincareSphere2Map(I, p, (Q, U, V), grid)
end

function PoincareSphereAngles2Map(I::IntensityMap, p, θ)
    return PoincareSphereAngles2Map(baseimage(I), p, θ, axisdims(I))
end