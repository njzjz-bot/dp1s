#!/bin/bash
set -eu

cat <<"EOF"
  o__ __o        o__ __o    __o
 <|     v\      <|     v\   __|>
 / \     <\     / \     <\    |
 \o/       \o   \o/     o/   <o>       __o__
  |         |>   |__  _<|/    |       />  \
 / \       //    |           < >      \o
 \o/      /     <o>           |        v\
  |      o       |            o         <\
 / \  __/>      / \         __|>_  _\o__</

    Install DeePMD-kit in one second.
EOF

progress=0
total_progress=5
logging() {
  echo -e "\033[32mDP1s [${progress}/${total_progress}] $1\033[0m"
}
logging "This script will automatically download and install DeePMD-kit (${DEEPMD_VERSION:-"lastest version"}) for you."

DP1S_HOME=${DP1S_HOME:-~/.dp1s}
export PIXI_HOME=$DP1S_HOME
DP1S_BIN_PATH=$DP1S_HOME/bin

# 1. check the location of the machine
((progress++)) || :

if [[ -v DP1S_COUNTRY ]]; then
  country=${DP1S_COUNTRY}
else
  country=$(curl -fsSL --connect-timeout 5 --max-time 10 https://ipinfo.io/country || :)
fi

deepmd_rc_channel="conda-forge/label/deepmd-kit_rc"

case "${country}" in
  CN)
    logging "Location: ${country}"
    conda_channel="https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/"
    export PIXI_REPOURL=https://ghfast.top/https://github.com/prefix-dev/pixi
    ;;
  "")
    logging "Location detection failed; falling back to conda-forge"
    conda_channel="conda-forge"
    ;;
  *)
    logging "Location: ${country}"
    conda_channel="conda-forge"
    ;;
esac

channel_args=(--channel="$conda_channel")
if [[ -v DP1S_DEEPMD_RC ]]; then
  logging "Enable DeePMD-kit release candidate channel"
  channel_args+=(--channel="$deepmd_rc_channel")
fi
channel_args+=(--channel=njzjz)

# 2. install pixi
((progress++))
logging "Install pixi"
if [[ -v DP1S_NO_PATH_UPDATE ]]; then
  export PIXI_NO_PATH_UPDATE=1
fi

curl -fsSL https://pixi.sh/install.sh | sh

# 3. install deepmd-kit
((progress++))
logging "Install DeePMD-kit"
$DP1S_BIN_PATH/pixi global install \
  --environment dp1s \
  --expose dp \
  --expose lmp \
  --expose mpirun \
  --expose horovodrun \
  deepmd-kit==${DEEPMD_VERSION:-"*"} \
  lammps \
  horovod \
  openmpi \
  --with mpi4py \
  --with jax \
  --with flax \
  --with orbax-checkpoint \
  --with njzjz::libdevice-hack-for-tensorflow \
  "${channel_args[@]}"

# 4. check the installation
((progress++))
logging "Check the installation"
$DP1S_BIN_PATH/dp --version
lmp_styles=$(echo info styles pair | $DP1S_BIN_PATH/lmp -log none)
if ! echo "$lmp_styles" | grep -q "\bdeepmd\b"; then
  echo "$lmp_styles"
  echo "deepmd pair style was not found in LAMMPS pair styles" >&2
  exit 1
fi
$DP1S_BIN_PATH/mpirun --version

# 5. Remove pixi
((progress++))
logging "Remove pixi to prevent conflict"
rm -f $DP1S_BIN_PATH/pixi

if [[ -v DP1S_NO_PATH_UPDATE ]]; then
  logging "DeePMD-kit have been installed to ${DP1S_BIN_PATH}. To activate the environment, add the following script before your script:"
  logging "export PATH=${DP1S_BIN_PATH}:\$PATH"
else
  logging "DeePMD-kit have been installed to ${DP1S_BIN_PATH}. Restart the shell to use dp, lmp, and mpirun."
fi