```
  o__ __o        o__ __o    __o              
 <|     v\      <|     v\   __|>             
 / \     <\     / \     <\    |              
 \o/       \o   \o/     o/   <o>       __o__ 
  |         |>   |__  _<|/    |       />  \  
 / \       //    |           < >      \o     
 \o/      /     <o>           |        v\    
  |      o       |            o         <\   
 / \  __/>      / \         __|>_  _\o__</   
```

# Install DeePMD-kit in 1s

Just copy and paste in 1s, and let it run.

```sh
curl -fsSL https://dp1s.deepmodeling.com | bash
```

## Options

The installation script has several options that can be manipulated through environment variables.

- `DP1S_HOME`: The location of the binary folder. (default: `$HOME/.dp1s`)
- `DP1S_NO_PATH_UPDATE`: If set the `$PATH` will not be updated to add DeePMD-kit to it.
- `DP1S_DEEPMD_RC`: If set, add the `conda-forge/label/deepmd-kit_rc` channel to install DeePMD-kit release candidates.
- `DEEPMD_VERSION`: The version of DeePMD-kit getting installed, can be used to up- or down-grade.
- `DP1S_CONDA_MIRRORS`: Comma-separated conda channel mirror candidates to benchmark. Built-in values include `ustc`, `tuna`, `bfsu`, `nju`, and `conda-forge`.
- `DP1S_PIXI_MIRRORS`: Comma-separated pixi repository URL candidates to benchmark. Built-in values include `github` (`https://github.com/prefix-dev/pixi`) and `ghfast` (`https://ghfast.top/https://github.com/prefix-dev/pixi`). This is independent from conda mirrors.
- `DP1S_CONDA_CHANNEL`: Force a conda channel or mirror URL and skip conda mirror benchmarking.
- `DP1S_PIXI_REPOURL`: Force the pixi GitHub repository URL or mirror and skip pixi repository benchmarking.
- `DP1S_MIRROR_CACHE_TTL`: Seconds to reuse the cached mirror choice. (default: `86400`)