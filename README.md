# Julia Sysimage Builder (GitHub Actions)

Builds a [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl) sysimage in GitHub Actions.

## cpu_target and AES-NI

Uses `"generic,+aes;sandybridge,+aes,-xsaveopt,clone_all;haswell,+aes,-rdrnd,base(1)"`.

`PackageCompiler.default_app_cpu_target()` does NOT include `+aes` on any target slice. [Random123.jl](https://github.com/JuliaRandom/Random123.jl) (pulled in via Turing --> AdvancedPS --> Random123) directly emits AES-NI intrinsics via `llvmcall` in [`src/x86/aesni_common.jl`](https://github.com/JuliaRandom/Random123.jl/blob/master/src/x86/aesni_common.jl). LLVM compiles code for each target slice independently, so without `+aes`, it aborts with:

```
LLVM ERROR: Cannot select: intrinsic %llvm.x86.aesni.aesenclast
```

This happens on both Intel (GHA runners) and AMD (AWS Fargate).

LLVM's [X86.td](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/X86/X86.td) excludes `FeatureAES` from `generic`, `sandybridge`, and `haswell` targets because not all physical SKUs shipped with AES-NI. The first target with AES-NI by default is `skylake`. The fix is adding `+aes` to **every** slice in the cpu_target string.

## Swap space

The sysimage compilation for ~350 dependencies is memory-intensive. Standard GHA runners (7GB RAM) need additional swap space — see the workflow for the swap setup step.
