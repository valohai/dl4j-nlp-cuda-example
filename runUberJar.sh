#!/bin/bash

set -e
set -u
set -o pipefail

DL4J_VERSION="1.0.0-beta5"
detectOSPlatform() {
	OSNAME=$(uname)

	if [[ "${OSNAME}" = "Darwin" ]]; then
	 	OSNAME=macosx
	elif [[ "${OSNAME}" = "Linux" ]]; then
		OSNAME=linux
	fi

	echo ${OSNAME}
}

./download-model-and-review-database.sh

BACKEND=${BACKEND:-gpu}
OSNAME=$(detectOSPlatform)
if [[ "${OSNAME}" = "macosx" ]]; then
   echo "";
   echo "GPUs are not accessible on MacOSX by the app hence we will use CPU as the backend."
   BACKEND=cpu
fi

if [[ "${BACKEND}" = "gpu" ]]; then
   VH_OUTPUTS_DIR=${VH_OUTPUTS_DIR:-"."}
   ./know-your-gpus.sh &> "${VH_OUTPUTS_DIR}/run-time-know-your-gpus.logs"
fi

getJarFile() {
    FOLDER=${1:-"."}
    echo $(ls "${FOLDER}"/dl4j-nlp-${DL4J_VERSION}-*-${OSNAME}-bin.jar | awk '{print $1}' || true)
}

TARGET_JAR_FILE=$(getJarFile)
if [[ -z "${TARGET_JAR_FILE}" ]]; then
    TARGET_JAR_FILE=$(getJarFile "target")
    if [[ ! -s "${TARGET_JAR_FILE}" ]]; then
       echo "Could not find the target executable jar file"
       exit -1
    fi
fi

java -version

time java -Djava.library.path=""  \
     -jar "${TARGET_JAR_FILE}"    \
     $*