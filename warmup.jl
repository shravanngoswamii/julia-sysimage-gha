using CSV, DataFrames, Distributions, ForwardDiff, JSON, SpecialFunctions, StableRNGs

CSV.write(IOBuffer(), DataFrame(x=1:3, y=rand(StableRNG(1), 3)))
JSON.json(Dict("a" => 1))
ForwardDiff.gradient(x -> sum(x .^ 2), [1.0, 2.0, 3.0])
gamma(5.0)
erf(1.0)
rand(StableRNG(42), Normal(0, 1), 10)
