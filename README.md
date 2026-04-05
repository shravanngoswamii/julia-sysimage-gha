# Julia Sysimage Builder (GitHub Actions)

Builds a [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl) sysimage in GitHub Actions.

## cpu_target and AES-NI

Uses `"generic,+aes;sandybridge,+aes,-xsaveopt,clone_all;haswell,+aes,-rdrnd,base(1)"`.

`PackageCompiler.default_app_cpu_target()` does NOT include `+aes` on any target slice. Julia 1.12+ uses AES-NI intrinsics internally, and LLVM compiles code for each target slice independently. Without `+aes`, LLVM aborts with:

```
LLVM ERROR: Cannot select: intrinsic %llvm.x86.aesni.aesenclast
```

This happens on both Intel (GHA runners) and AMD (AWS Fargate) — it's not CPU-vendor-specific.

LLVM's [X86.td](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/X86/X86.td) excludes `FeatureAES` from `generic`, `sandybridge`, and `haswell` targets because not all physical SKUs of those architectures shipped with AES-NI. The first target that includes AES-NI by default is `skylake`. The fix is adding `+aes` to **every** slice in the cpu_target string.

## Swap space

The sysimage compilation for ~350 dependencies is memory-intensive. Standard GHA runners (7GB RAM) need additional swap space — see the workflow for the swap setup step.
