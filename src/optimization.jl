export solve_opt

mutable struct FCallback{F}
    counter::Int
    stride::Int
    const f::F
end

FCallback(stride, f) = FCallback(0, stride, f)

function (c::FCallback)(x, p)
    c.counter += 1
    if c.counter % c.stride == 0
        @info "On step $(c.counter)"
        return false
    else
        return false
    end
end

function solve_opt(post::VLBIPosterior, opttype=Optimisers.Adam(), adtype=Optimization.AutoEnzyme(); 
    ntrials=5, maxiters=10_000, init_params=nothing, verbose=false, stride=1000)
    tpost = asflat(post)
    mapout = map(1:ntrials) do i
        verbose && @info("$i/$(ntrials): Start Imaging")
        g = OptimizationFunction(tpost, adtype)
        initial_params = isnothing(init_params) ? prior_sample(tpost) : inverse(tpost, init_params)
        
        prob = OptimizationProblem(g, initial_params, nothing)
        verbose && (cb = FCallback(stride, g))
        sol = verbose ? solve(prob, opttype; maxiters=maxiters/2, g_tol=1e-1, callback=cb) : solve(prob, opttype; maxiters=maxiters/2, g_tol=1e-1)

        prob2 = OptimizationProblem(g, sol.u .+ (prior_sample(tpost).*0.2), nothing)
        sol = verbose ? solve(prob2, opttype; maxiters=maxiters, g_tol=1e-1, callback=cb) : solve(prob2, opttype; maxiters=maxiters, g_tol=1e-1)
        
        return transform(tpost, sol), sol
    end
    
    xopts = [mapout[i][1] for i in 1:ntrials]
    sols = [mapout[i][2] for i in 1:ntrials]
    lmaps = logdensityof.(Ref(tpost), sols)
    inds = sortperm(filter(!isnan, lmaps), rev=true)

    return xopts[inds], lmaps[inds]
end
