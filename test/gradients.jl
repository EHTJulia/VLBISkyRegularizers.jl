using VLBISkyRegularizers
using Comrade
using FiniteDifferences
using Enzyme
using StableRNGs

@testset "RegularizerGradients" begin
    grid = imagepixels(μas2rad(150.0), μas2rad(150.0), 64, 64)
    rng = StableRNG(123)
    
    for imageDomain in [LinearDomain(), LogDomain(), CLRDomain(), ALRDomain()]
        a = L1(rand(), imageDomain, LinearDomain(), grid)
        b = TSV(rand(), imageDomain, LogDomain(), grid)
        c = TV(rand(), imageDomain, ParameterDomain(), grid)
        d = WaveletL1(rand(), imageDomain, LinearDomain(), WVType(), grid)
        comb = a + 2*(b+c) + 3*d
        x = rand(rng, comb)
        @test isapprox(evaluate(comb, x), evaluate(a, x) + 2*evaluate(b, x) + 2*evaluate(c, x) + 3*evaluate(d, x))

        dx = zeros(size(x))
        autodiff(Enzyme.Reverse, evaluate, Active, Const(comb), Duplicated(x, dx))
        finite_dx = grad(central_fdm(3,1), x->evaluate(comb,x), x)[1]
        @test isapprox(dx, finite_dx)
    end
end