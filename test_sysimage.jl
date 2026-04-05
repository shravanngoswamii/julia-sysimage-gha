t = @elapsed using CSV, DataFrames, Distributions, ForwardDiff, JSON, SpecialFunctions, StableRNGs

@assert JSON.parse(JSON.json(Dict("a" => 1)))["a"] == 1
@assert nrow(CSV.read(IOBuffer("x\n1\n2"), DataFrame)) == 2
@assert abs(gamma(5.0) - 24.0) < 1e-10
@assert norm(ForwardDiff.gradient(x -> sum(x .^ 2), [1.0, 2.0, 3.0]) - [2.0, 4.0, 6.0]) < 1e-10
@assert length(rand(StableRNG(1), Normal(0, 1), 5)) == 5

println("All tests passed. Packages loaded in $(round(t, digits=2))s")
