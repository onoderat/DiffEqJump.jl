###############################################################################
# Stochiometry for a given reaction is a vector of pairs mapping species id to 
# stochiometric coefficient.
###############################################################################

@inbounds @fastmath function evalrxrate(speciesvec::AbstractVector{T}, rateconst,
                                        stochmat::AbstractVector{Pair{T,T}})::typeof(rateconst) where T
    val = one(T)

    for specstoch in stochmat
        specpop = speciesvec[specstoch[1]]
        val    *= specpop
        for k = 2:specstoch[2]
            specpop -= one(specpop)
            val     *= specpop
        end
    end

    return rateconst * val
end

@inline @inbounds @fastmath function executerx!(speciesvec::AbstractVector{T},
                                                net_stoch::AbstractVector{Pair{T,T}}) where T
    for specstoch in net_stoch
        speciesvec[specstoch[1]] += specstoch[2]
    end
    nothing
end


@inbounds function scalerates!(unscaled_rates, stochmat::Vector{Vector{Pair{T,T}}}) where T
    for i in eachindex(unscaled_rates)
        coef = one(T)
        for specstoch in stochmat[i]            
            coef *= factorial(specstoch[2])
        end
        unscaled_rates[i] /= coef
    end
    nothing
end