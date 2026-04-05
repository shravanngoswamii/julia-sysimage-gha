using PackageCompiler

create_sysimage(
    [
        :JuliaBUGS, :Turing, :AbstractMCMC, :AdvancedHMC, :ForwardDiff,
        :StableRNGs, :Distributions, :CSV, :DataFrames, :HTTP, :JSON,
        :OnlineStats, :OnlineStatsBase, :TensorBoardLogger, :YAML,
    ];
    sysimage_path=joinpath(@__DIR__, "sysimage.so"),
    precompile_execution_file=joinpath(@__DIR__, "warmup.jl"),
    cpu_target=PackageCompiler.default_app_cpu_target(),
)
