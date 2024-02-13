module VLBISkyRegularizers

# import modules
using DocStringExtensions
using VLBISkyModels
using ComradeBase
using EHTImages
using EHTUtils
using FLoops
using Wavelets
using Enzyme
using Zygote
using ChainRulesCore
import .EnzymeRules: reverse, augmented_primal
using .EnzymeRules



include("regularizers/abstract.jl")
include("regularizers/l1norm.jl")
include("regularizers/tv.jl")
include("regularizers/tsv.jl")
include("regularizers/klmem.jl")
include("common.jl")
include("regularizers/waveletl1norm.jl")

end
