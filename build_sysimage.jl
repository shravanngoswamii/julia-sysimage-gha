using PackageCompiler

create_sysimage(
    [:CSV, :DataFrames, :Distributions, :ForwardDiff, :JSON, :SpecialFunctions, :StableRNGs];
    sysimage_path=joinpath(@__DIR__, "sysimage.so"),
    precompile_execution_file=joinpath(@__DIR__, "warmup.jl"),
    # "generic" excludes AES-NI, but Julia 1.12 uses AES intrinsics internally.
    # Adding +aes to generic fixes "Cannot select: intrinsic %llvm.x86.aesni.aesenclast".
    cpu_target="generic,+aes;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)",
)
