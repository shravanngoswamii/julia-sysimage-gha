# Julia Sysimage Builder (GitHub Actions)

Builds a [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl) sysimage in GitHub Actions.

## cpu_target note

Uses `"generic,+aes;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)"`.

`PackageCompiler.default_app_cpu_target()` uses `generic` as the baseline which excludes AES-NI. Some packages or Julia internals use AES-NI intrinsics — without `+aes`, LLVM aborts during sysimage compilation with:

```
LLVM ERROR: Cannot select: intrinsic %llvm.x86.aesni.aesenclast
```

Adding `+aes` to the generic slice fixes this. AES-NI has been standard on x86_64 CPUs since ~2012.
