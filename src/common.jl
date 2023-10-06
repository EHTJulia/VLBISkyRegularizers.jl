function sum_floop(x::IntensityMap; ex=ThreadedEx())
    value = 0.0
    @floop ex for i in 1:length(x)
        @reduce value += x[i]
    end
    return value
end

