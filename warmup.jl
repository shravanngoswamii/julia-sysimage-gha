using JuliaBUGS, AbstractMCMC, AdvancedHMC, ForwardDiff, StableRNGs
using Distributions, CSV, DataFrames, HTTP, JSON
using OnlineStats, OnlineStatsBase, TensorBoardLogger, YAML
using Turing

# JuliaBUGS model
model_def = JuliaBUGS.@bugs("""
model {
    for (i in 1:N) {
        y[i] ~ dnorm(mu, tau)
    }
    mu ~ dnorm(0, 0.001)
    tau ~ dgamma(0.01, 0.01)
}
""", true, false)

m = compile(model_def, (N=5, y=[1.0, 2.0, 3.0, 4.0, 5.0]), (mu=0.0, tau=1.0))
sample(StableRNG(42), m, AdvancedHMC.NUTS(0.65), 10; progress=false)

# Turing model
Turing.@model function demo_model(y)
    mu ~ Normal(0, 10)
    sigma ~ truncated(Normal(0, 5); lower=0)
    for i in eachindex(y)
        y[i] ~ Normal(mu, sigma)
    end
end

sample(StableRNG(42), demo_model([1.0, 2.0, 3.0]), Turing.NUTS(), 10; progress=false)

ForwardDiff.gradient(x -> sum(x .^ 2), [1.0, 2.0, 3.0])
CSV.write(IOBuffer(), DataFrame(x=1:3, y=rand(StableRNG(1), 3)))
JSON.json(Dict("a" => 1))
YAML.load("key: value")
fit!(Mean(), [1.0, 2.0, 3.0])
