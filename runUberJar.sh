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

VH_REPOSITORY_DIR=${VH_REPOSITORY_DIR:-"."}
mkdir -p "${VH_REPOSITORY_DIR}/data/dl4j_w2vSentiment"

### Check if we are running in the Valohai environment, an empty VH_INPUTS_DIR means we are running outside that environment
if [[ -z "${VH_INPUTS_DIR:-}" ]]; then
   ### Outside Valohai environment
   echo "";
   if [[ ! -s "./data/GoogleNews-vectors-negative300.bin.gz" ]]; then
       echo "Downloading word2vec pre-trained Google News corpus, as it does not exist in the data folder..."
       curl -J -O -L https://s3.amazonaws.com/dl4j-distribution/GoogleNews-vectors-negative300.bin.gz
       mv GoogleNews-vectors-negative300.bin.gz data
   else
      echo "The word2vec pre-trained Google News corpus already exists in the data folder"
   fi

   if [[ ! -s "./data/dl4j_w2vSentiment/aclImdb_v1.tar.gz" ]]; then
       echo "Downloading IMDB Review dataset for sentiment analysis, as it does not exist in the data/dl4j_w2vSentiment folder..."
       curl -J -O -L http://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz
       mv aclImdb_v1.tar.gz data/dl4j_w2vSentiment
   else
      echo "The IMDB Review dataset already exists in the data/dl4j_w2vSentiment folder"
   fi
else
   ### In the Valohai environment
   echo "";
   echo "Downloading word2vec pre-trained Google News corpus into the data folder" >&2
   cp "${VH_INPUTS_DIR}/google-word2vec/GoogleNews-vectors-negative300.bin.gz" "${VH_REPOSITORY_DIR}/data"
   echo "Downloading IMDB Review dataset for sentiment analysis into the data/dl4j_w2vSentiment folder" >&2
   cp "${VH_INPUTS_DIR}/imdb-reviews/http://ai.stanford.edu/~amaas/data/sentiment/aclImdb_v1.tar.gz" "${VH_REPOSITORY_DIR}/data/dl4j_w2vSentiment"
fi

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

TARGET_JAR_FILE="dl4j-nlp-${DL4J_VERSION}-${BACKEND}-${OSNAME}-bin.jar"
if [[ -s "target/${TARGET_JAR_FILE}" ]]; then
	TARGET_JAR_FILE="target/${TARGET_JAR_FILE}"
fi

java -version

time java -Djava.library.path=""                 \
     -jar "${TARGET_JAR_FILE}"                   \
     -Xmx8g                                      \
     -Dorg.bytedeco.javacpp.maxbytes=10G         \
     -Dorg.bytedeco.javacpp.maxphysicalbytes=10G \
     "$*"