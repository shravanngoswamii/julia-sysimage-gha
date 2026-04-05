using PackageCompiler

create_sysimage(
    [
        :JuliaBUGS, :Turing, :AbstractMCMC, :AdvancedHMC, :ForwardDiff,
        :StableRNGs, :Distributions, :CSV, :DataFrames, :HTTP, :JSON,
        :OnlineStats, :OnlineStatsBase, :TensorBoardLogger, :YAML,
    ];
    sysimage_path=joinpath(@__DIR__, "sysimage.so"),
    precompile_execution_file=joinpath(@__DIR__, "warmup.jl"),
    # LLVM excludes AES-NI from generic/sandybridge/haswell targets (not all SKUs have it).
    # Code is compiled for every target slice, so +aes must be on ALL slices or LLVM aborts
    # with "Cannot select: intrinsic %llvm.x86.aesni.*" on the slices that lack it.
    cpu_target="generic,+aes;sandybridge,+aes,-xsaveopt,clone_all;haswell,+aes,-rdrnd,base(1)",
)
