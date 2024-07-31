using VLBISkyRegularizers
using Test

@testset "VLBISkyRegularizers.jl" begin
    include(joinpath(@__DIR__, "gradients.jl"))
end
