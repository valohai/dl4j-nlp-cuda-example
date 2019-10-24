#!/bin/bash

set -e
set -u
set -o pipefail

detectOSPlatform() {
	OSNAME=$(uname)

	if [[ "${OSNAME}" = "Darwin" ]]; then
	 	OSNAME=macosx
	elif [[ "${OSNAME}" = "Linux" ]]; then
		OSNAME=linux
	fi

	echo ${OSNAME}
}

./download-src-main-resources.sh

OSNAME=${1:-$(detectOSPlatform)}

runMvnPackage() {
    BACKEND=${1:-"cpu-backend"}
    time mvn package -P"${BACKEND}"                    \
                 -Djavacpp.platform="${OSNAME}-x86_64" \
                 -Dplatform="${OSNAME}"
}

echo ""; echo "Building uber jar for target platform: ${OSNAME} with CPU backend (default)"
runMvnPackage "cpu-backend"

if [[ "${OSNAME}" = "macosx" ]]; then
    echo ""; echo "Skipping building of uber jar for target platform: ${OSNAME} with GPU backend..."
    echo "Skymind has dropped support for CUDA for the MacOSX, " \
         "see https://gitter.im/deeplearning4j/deeplearning4j?at=5d92a15c9d4cf173604945c6."
else
    VH_OUTPUTS_DIR=${VH_OUTPUTS_DIR:-"."}
    ./know-your-gpus.sh &> "${VH_OUTPUTS_DIR}/build-time-know-your-gpus.logs"

    echo ""; echo "Building uber jar for target platform: ${OSNAME} with GPU backend"
    runMvnPackage "gpu-backend"
fi