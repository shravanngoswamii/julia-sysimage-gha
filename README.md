# Julia Sysimage Builder (GitHub Actions)

Builds a [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl) sysimage with pre-compiled Julia packages in GitHub Actions.

## What it does

- Compiles Julia packages (Turing.jl, JuliaBUGS, AdvancedHMC, ForwardDiff, etc.) into a native sysimage
- Eliminates package precompilation at runtime (~5-10 min → seconds)
- Tests the sysimage by running both JuliaBUGS and Turing models
- Uploads the sysimage as a downloadable GitHub Actions artifact

## Usage

Push to `main` or open a PR — the workflow builds and tests the sysimage automatically.

To download the built sysimage from the Actions artifacts, then run Julia with:

```bash
julia --sysimage=sysimage.so --project -e 'using Turing; ...'
```

## cpu_target

The sysimage uses `"generic,+aes;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)"` as the cpu_target. The `+aes` on the generic baseline is required because Julia 1.12 uses AES-NI intrinsics internally — without it, LLVM aborts with `Cannot select: intrinsic %llvm.x86.aesni.aesenclast`.