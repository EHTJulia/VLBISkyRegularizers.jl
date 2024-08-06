using Pkg; Pkg.activate(@__DIR__)
using Literate

preprocess(path, str) = replace(str, "__DIR = @__DIR__" => "__DIR = \"$(dirname(path))\"")


withenv("JULIA_DEBUG"=>"Literate") do 
    p_in = joinpath(@__DIR__, "..", "examples", "tutorial1.jl")
    p_out = joinpath(@__DIR__, "src", "tutorials")
    name = "tutorial1"
    Literate.markdown(p_in, p_out; name=name, execute=false, flavor=Literate.DocumenterFlavor(), preprocess=Base.Fix1(preprocess, "$(p_in)"))
end