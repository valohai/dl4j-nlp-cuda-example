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

downloadModelAndDatabase() {
  ./download-model-and-review-database.sh  
}

checkBackendForMacOSX(){
  if [[ "${OSNAME}" = "macosx" ]]; then
     echo "";
     echo "GPUs are not accessible on MacOSX by the app hence we will use CPU as the backend."
     BACKEND=cpu
  fi  
}

forGPUBuildsRunKnowYourGPUsScript() {
  if [[ "${BACKEND}" = "gpu" ]]; then
    VH_OUTPUTS_DIR=${VH_OUTPUTS_DIR:-"."}
    ./know-your-gpus.sh &> "${VH_OUTPUTS_DIR}/run-time-know-your-gpus.logs"
  fi
}

getJarFile() {
    FOLDER=${1:-"."}
    echo $(ls "${FOLDER}"/dl4j-nlp-${DL4J_VERSION}-*-${OSNAME}-bin.jar | awk '{print $1}' || true)
}

copyJarForTrainingIfOnValohaiPlatform() {
  if [[ "${ACTION}" = "train" ]] && [[ ! -z "${VH_INPUTS_DIR:-}" ]]; then
    echo "~~~ Copying ${VH_INPUTS_DIR}/${BACKEND}-linux-uberjar/dl4j-nlp-1.0.0-beta5-${BACKEND}-linux-bin.jar into ${VH_REPOSITORY_DIR}"
    cp ${VH_INPUTS_DIR}/${BACKEND}-linux-uberjar/dl4j-nlp-1.0.0-beta5-${BACKEND}-linux-bin.jar ${VH_REPOSITORY_DIR}
  fi
}

checkIfJarExistsOrExit() {
  TARGET_JAR_FILE=$(getJarFile)
  if [[ -z "${TARGET_JAR_FILE}" ]]; then
      TARGET_JAR_FILE=$(getJarFile "target")
      if [[ ! -s "${TARGET_JAR_FILE}" ]]; then
         echo "Could not find the target executable jar file"
         exit -1
      fi
  fi
}

runJar() {
  java -version

  time java -Djava.library.path=""  \
       -jar "${TARGET_JAR_FILE}"    \
       $*
}

copyModelForTrainingIfOnValohaiPlatform() {
  if [[ "${ACTION}" = "train" ]] && [[ ! -z "${VH_OUTPUTS_DIR:-}" ]]; then
    echo "~~~ Copying all created models and checkpoints into ${VH_OUTPUTS_DIR}"
    for filename in *.pb ; do mv $filename "${filename%.*}-${BACKEND}.pb" ; done
    cp *.pb ${VH_OUTPUTS_DIR}
    cp ./checkpoint* ${VH_OUTPUTS_DIR}
  fi
}

DL4J_VERSION="1.0.0-beta5"
BACKEND=${BACKEND:-gpu}
OSNAME=$(detectOSPlatform)
TARGET_JAR_FILE=""

downloadModelAndDatabase
checkBackendForMacOSX
forGPUBuildsRunKnowYourGPUsScript
copyJarForTrainingIfOnValohaiPlatform
checkIfJarExistsOrExit
runJar $*
copyModelForTrainingIfOnValohaiPlatform