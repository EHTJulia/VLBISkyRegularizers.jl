using VLBISkyRegularizers
using Comrade
using FiniteDifferences
using Enzyme

@testset "RegularizerGradients" begin
    grid = imagepixels(μas2rad(150.0), μas2rad(150.0), 256, 256)
    
    for imageDomain in [LinearDomain(), LogDomain(), CLRDomain(), ALRDomain()]
        a = L1(rand(), imageDomain, LinearDomain(), grid)
        b = TSV(rand(), imageDomain, LogDomain(), grid)
        c = TV(rand(), imageDomain, ParameterDomain(), grid)
        d = WaveletL1(rand(), imageDomain, LinearDomain(), WVType(), grid)
        comb = a + 2*(b+c) + 3*d
        x = rand(comb)
        @test evaluate(comb, x) == evaluate(a) + 2*evaluate(b) + 2*evaluate(c) + 3*evaluate(d)

        dx = zeros(shape(x))
        autodiff(Enzyme.Reverse, evaluate, Active, Const(comb), Duplicated(x, dx))
        finite_dx = grad(central_fdm(5,1), x->evaluate(comb,x), x)[1]
        @test dx ≈ finite_dx
    end
end