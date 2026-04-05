using PackageCompiler

create_sysimage(
    [:CSV, :DataFrames, :Distributions, :ForwardDiff, :JSON, :SpecialFunctions, :StableRNGs];
    sysimage_path=joinpath(@__DIR__, "sysimage.so"),
    precompile_execution_file=joinpath(@__DIR__, "warmup.jl"),
    # LLVM's "generic" x86-64 target cannot select AES-NI intrinsics even with +aes,
    # causing "Cannot select: intrinsic %llvm.x86.aesni.*" during compilation.
    # Using sandybridge (2011+, includes AES-NI natively) as minimum baseline instead.
    cpu_target="sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)",
)
