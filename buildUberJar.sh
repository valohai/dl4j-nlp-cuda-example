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

VH_REPOSITORY_DIR=${VH_REPOSITORY_DIR:-"."}

### Check if we are running in the Valohai environment, an empty VH_INPUTS_DIR means we are running outside that environment
if [[ -z "${VH_INPUTS_DIR:-}" ]]; then
   ### Outside Valohai environment
   echo "";
   if [[ ! -e "src/main/resources/NewsData" ]] && [[ ! -s "dl4j-nlp-src-main-resources.tgz" ]]; then
       echo "Downloading build-time resources for src/main/resources into the current folder..."
       curl -J -O -L https://github.com/neomatrix369/awesome-ai-ml-dl/releases/download/dl4j-nlp-src-main-resources-v0.1/dl4j-nlp-src-main-resources.tgz
   else
      echo "Build-time resources already exists in the src/main/resources folder"
   fi
else
    ### In the Valohai environment
    echo "Copying build-time resources archive into ${VH_REPOSITORY_DIR}" >&2
    cp "${VH_INPUTS_DIR}/src-main-resources/dl4j-nlp-src-main-resources.tgz" "${VH_REPOSITORY_DIR}"
fi

if [[ ! -e "${VH_REPOSITORY_DIR}/src/main/resources/NewsData" ]] && [[ -s "${VH_REPOSITORY_DIR}/dl4j-nlp-src-main-resources.tgz" ]]; then
    echo "";echo "Unpacking build-time resources into the src/main/resources folder" >&2
    tar xzvf "${VH_REPOSITORY_DIR}/dl4j-nlp-src-main-resources.tgz" -C "${VH_REPOSITORY_DIR}"
fi
ls "${VH_REPOSITORY_DIR}/src/main/resources" >&2

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