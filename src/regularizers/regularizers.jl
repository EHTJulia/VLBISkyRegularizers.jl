export Regularizers

"""
    Regularizers

# Mandatory fields
- `regularizers::NTuple{N, AbstractRegularizer}`: Tuple of AbstractRegularizer objects
- `grid`: grid on which the image is defined
"""
struct Regularizers{rr<:NTuple{N, AbstractRegularizer} where N, g} <: ContinuousMatrixDistribution
    regularizers::rr
    grid::g
end

# Base Functions



