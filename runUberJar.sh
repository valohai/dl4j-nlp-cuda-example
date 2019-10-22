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

BACKEND=${BACKEND:-gpu}
OSNAME=$(detectOSPlatform)
if [[ "${OSNAME}" = "macosx" ]]; then
   echo "GPUs are not accessible on MacOSX by Nvidia drivers we will use CPU as the backend"
   BACKEND=cpu
fi

TARGET_JAR_FILE="dl4j-nlp-${DL4J_VERSION}-${BACKEND}-${OSNAME}-bin.jar"
if [[ -s "target/${TARGET_JAR_FILE}" ]]; then
	TARGET_JAR_FILE="target/${TARGET_JAR_FILE}"
fi

java -version

time java -Djava.library.path=""                 \
     -jar ${TARGET_JAR_FILE}                     \
     -Xmx8g                                      \
     -Dorg.bytedeco.javacpp.maxbytes=10G         \
     -Dorg.bytedeco.javacpp.maxphysicalbytes=10G \
     $*