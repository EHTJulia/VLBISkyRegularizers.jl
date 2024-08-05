using VLBISkyRegularizers
using Documenter
using DocumenterVitepress

DocMeta.setdocmeta!(VLBISkyRegularizers, :DocTestSetup, :(using VLBISkyRegularizers); recursive=true)

makedocs(;
    modules=[VLBISkyRegularizers],
    authors="Andy Nilipour, Kazunori Akiyama",
    repo="https://github.com/EHTJulia/VLBISkyRegularizers.jl/blob/{commit}{path}#{line}",
    sitename="VLBISkyRegularizers.jl",
    format=MarkdownVitepress(;
        repo="https://EHTJulia.github.io/VLBISkyRegularizers.jl",
        devurl = "dev",
        devbranch = "main",
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/EHTJulia/VLBISkyRegularizers.jl",
    devbranch="main",
)
