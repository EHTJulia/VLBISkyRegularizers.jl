using VLBISkyRegularizers
using Documenter

DocMeta.setdocmeta!(VLBISkyRegularizers, :DocTestSetup, :(using VLBISkyRegularizers); recursive=true)

makedocs(;
    modules=[VLBISkyRegularizers],
    authors="Andy Nilipour, Kazunori Akiyama",
    repo="https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/{commit}{path}#{line}",
    sitename="VLBISkyRegularizers.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://EHTJulia.github.io/VLBISkyRegularizers.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/EHTJulia/VLBISkyRegularizers.jl",
    devbranch="main",
)
