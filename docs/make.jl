using VLBISkyRegularizers
using Documenter
using DocumenterVitepress
using Distributions

DocMeta.setdocmeta!(VLBISkyRegularizers, :DocTestSetup, :(using VLBISkyRegularizers); recursive=true)

makedocs(;
    modules=[VLBISkyRegularizers],
    authors="Andy Nilipour, Kazunori Akiyama",
    repo="https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/{commit}{path}#{line}",
    sitename="VLBISkyRegularizers.jl",
    format=MarkdownVitepress(;
        repo="https://github.com/EHTJulia/VLBISkyRegularizers.jl",
        devurl = "dev",
        devbranch = "main",
    ),
    pages=[
        "Home" => "index.md",
        "introduction.md",
        "Tutorials" => ["tutorials/tutorial1.md"],
        "api.md"
    ],
)

deploydocs(;
    repo="github.com/EHTJulia/VLBISkyRegularizers.jl",
    devbranch="main",
)
