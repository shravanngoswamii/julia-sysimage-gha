using PackageCompiler

create_sysimage(
    [
        :JuliaBUGS, :Turing, :AbstractMCMC, :AdvancedHMC, :ForwardDiff,
        :StableRNGs, :Distributions, :CSV, :DataFrames, :HTTP, :JSON,
        :OnlineStats, :OnlineStatsBase, :TensorBoardLogger, :YAML,
    ];
    sysimage_path=joinpath(@__DIR__, "sysimage.so"),
    precompile_execution_file=joinpath(@__DIR__, "warmup.jl"),
    # LLVM excludes AES-NI from generic/sandybridge/haswell targets by default.
    # Julia 1.12+ uses AES intrinsics internally, so +aes is required on ALL
    # target slices — LLVM compiles code for each slice independently.
    cpu_target="generic,+aes;sandybridge,+aes,-xsaveopt,clone_all;haswell,+aes,-rdrnd,base(1)",
)
