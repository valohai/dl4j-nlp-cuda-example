#!/bin/bash

set -e
set -u
set -o pipefail

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