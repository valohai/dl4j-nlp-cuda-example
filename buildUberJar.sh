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

downloadResources() {
    ./download-src-main-resources.sh
}

runMvnPackage() {
    BACKEND=${1:-"cpu-backend"}
    time mvn package -P"${BACKEND}"                    \
                 -Djavacpp.platform="${OSNAME}-x86_64" \
                 -Dplatform="${OSNAME}"
}

runBuildCpuBackendPackage() {
    echo ""; echo "Building uber jar for target platform: ${OSNAME} with CPU backend (default)"
    runMvnPackage "cpu-backend"
}

runBuildGpuBackendPackage() {
    if [[ "${OSNAME}" = "macosx" ]]; then
        echo ""; echo "Skipping building of uber jar for target platform: ${OSNAME} with GPU backend..."
        echo "Skymind has dropped support for CUDA for the MacOSX, " \
             "see https://gitter.im/deeplearning4j/deeplearning4j?at=5d92a15c9d4cf173604945c6."
    else
        echo ""; echo "Building uber jar for target platform: ${OSNAME} with GPU backend"
        runMvnPackage "gpu-backend"
    fi
}

postBuildProcessOnValohaiPlatform() {
    ### Check if we are running in the Valohai environment, an empty VH_INPUTS_DIR means we are running outside that environment
    if [[ ! -z "${VH_OUTPUTS_DIR:-}" ]]; then
        ### In Valohai environment
        echo "~~~ Copying the build-time-know-your-gpus.logs file into ${VH_OUTPUTS_DIR}"
        ./know-your-gpus.sh &> "${VH_OUTPUTS_DIR}/build-time-know-your-gpus.logs"

        echo "~~~ Copying the build jar file into ${VH_OUTPUTS_DIR}"
        cp target/*bin*.jar ${VH_OUTPUTS_DIR}

        ls -lash ${VH_OUTPUTS_DIR}
    fi
}

OSNAME=${1:-$(detectOSPlatform)}
downloadResources
runBuildCpuBackendPackage
runBuildGpuBackendPackage
postBuildProcessOnValohaiPlatform