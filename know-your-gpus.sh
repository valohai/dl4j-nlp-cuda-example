#!/bin/bash

set -e
set -u
set -o pipefail

SUDO_CMD=""
if [[ -f "/etc/sudoers" ]]; then
   SUDO_CMD=sudo
fi

echo ""; echo "~~~~~ Check using /dev" >&2
ls -la /dev | grep nvidia >&2 || true

echo ""; echo "~~~~~ Check using /opt" >&2
ls /opt/                  || true
ls /opt/nvidia_installers || true

echo ""; echo "~~~~~ Check using /usr/local/" >&2
ls /usr/local/            || true

echo ""; echo "~~~~~ Check using mesa-utils (might not inside a container)" >&2
# expected to have run ${SUDO_CMD} apt-get install mesa-utils
glxinfo >&2 || true
glxinfo | grep OpenGL >&2 || true
echo "~~~~~~~~~~~~~~~~~~~"

echo ""; echo "~~~~~ Check using lshw" >&2
${SUDO_CMD} lshw -C display >&2 || true
${SUDO_CMD} lshw -numeric -C display >&2 || true
${SUDO_CMD} lshw -c video | grep configuration || true
echo "~~~~~~~~~~~~~~~~~~~" >&2

echo ""; echo "~~~~~ Check using lspci" >&2
${SUDO_CMD} lspci  -v -s  "$(lspci | grep ' VGA ' | cut -d" " -f 1)" >&2 || true
${SUDO_CMD} lspci -vnn | grep VGA -A 12 >&2 || true
echo "~~~~~~~~~~~~~~~~~~~" >&2
${SUDO_CMD} lspci | grep -i nvidia >&2 || true
echo "~~~~~~~~~~~~~~~~~~~" >&2

echo ""; echo "~~~~~ Check using nvidia-smi (should be part of the container runtime)" >&2
which -v nvidia-smi || true
whereis nvidia-smi || true
nvidia-smi -q || true
echo "~~~~~~~~~~~~~~~~~~~" >&2

echo ""; echo "~~~~~ Check using clinfo" >&2
# expected to have run ${SUDO_CMD} apt-get install clinfo
clinfo >&2 || true
echo "~~~~~~~~~~~~~~~~~~~" >&2

echo ""; echo "~~~~~ Check using glxgears (might not work inside a container)" >&2
glxgears >&2 || true
echo "~~~~~~~~~~~~~~~~~~~" >&2

echo ""; echo "~~~~~ Check using glmark2 (might not inside a container)" >&2
# expected to have run ${SUDO_CMD} apt-get install glmark2
glmark2 >&2 || true
echo "~~~~~~~~~~~~~~~~~~~" >&2

echo ""; echo "~~~~~ Examining your environment variables" >&2
env | grep -i nvidia >&2 || true