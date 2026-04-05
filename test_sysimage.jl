t = @elapsed begin
    using JuliaBUGS, AbstractMCMC, AdvancedHMC, ForwardDiff, StableRNGs
    using Distributions, CSV, DataFrames, HTTP, JSON
    using OnlineStats, OnlineStatsBase, TensorBoardLogger, YAML
    using Turing
end
println("Packages loaded in $(round(t, digits=2))s")

# JuliaBUGS
model_def = JuliaBUGS.@bugs("""
model {
    for (i in 1:N) { y[i] ~ dnorm(mu, tau) }
    mu ~ dnorm(0, 0.001)
    tau ~ dgamma(0.01, 0.01)
}
""", true, false)
m = compile(model_def, (N=3, y=[1.0, 2.0, 3.0]), (mu=0.0, tau=1.0))
sample(StableRNG(42), m, AdvancedHMC.NUTS(0.65), 10; progress=false)
println("[pass] JuliaBUGS + AdvancedHMC")

# Turing
Turing.@model function test_model(y)
    mu ~ Normal(0, 10)
    for i in eachindex(y)
        y[i] ~ Normal(mu, 1)
    end
end
sample(StableRNG(42), test_model([1.0, 2.0, 3.0]), Turing.NUTS(), 10; progress=false)
println("[pass] Turing")

println("All tests passed.")
