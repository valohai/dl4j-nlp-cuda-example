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

OSNAME=${1:-$(detectOSPlatform)}

echo "Building uber jar for target platform: ${OSNAME} with CPU backend (default)"
time mvn package -Pcpu-backend                       \
                 -Djavacpp.platform=${OSNAME}-x86_64 \
                 -Dplatform=${OSNAME}


if [[ "${OSNAME}" = "macosx" ]]; then
    echo "Skymind has dropped support for CUDA for the MacOSX, hence can't" \
         " build it either, see https://gitter.im/deeplearning4j/deeplearning4j?at=5d92a15c9d4cf173604945c6." \
         "Try building on another platform."
else
    echo "Building uber jar for target platform: ${OSNAME} with GPU backend"
    time mvn package -Pgpu-backend                       \
                     -Djavacpp.platform=${OSNAME}-x86_64 \
                     -Dplatform=${OSNAME}
fi