#!/bin/bash

#
# Copyright 2019 Mani Sarkar
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e
set -u
set -o pipefail

createResourceArtifact() {
	echo ""
	echo "~~~ Deleting ${TARGET_ARTIFACT}"
	rm -f ${TARGET_ARTIFACT}

	echo ""
	echo "~~~ Creating new artifact ${TARGET_ARTIFACT}"
	(
		cd .. && \
		   tar -zvcf                         \
		        ${TARGET_ARTIFACT}            \
		        --exclude='dropwizard.yml'   \
		        --exclude='log4j.properties' \
		        --exclude='logback.xml'      \
		        src/main/resources/*
	)

	echo ""
	ls -lash ${TARGET_ARTIFACT}	
}

abortIfGitHubTokenIsAbsent() {
	if [[ -z ${MY_GITHUB_TOKEN} ]]; then
	  echo "MY_GITHUB_TOKEN cannot be found in the current environment, please populate to proceed either in the startup bash script of your OS or in the environment variable settings of your CI/CD interface."
	  exit -1
	fi	
}

askTargetRepoIfAbsent() {
	if [[ -z ${TARGET_REPO:-""} ]]; then
	  read -p "Target repo name (must exist on GitHub, for e.g. neomatrix369/awesome-ai-ml-dl): " TARGET_REPO
	fi
}

setup() {
	abortIfGitHubTokenIsAbsent

	askTargetRepoIfAbsent

	mkdir -p ${CURRENT_DIR}/artifacts
}


deleteResourceFromGitHub() {
	echo ""
	echo "~~~~ Fetching Release ID for ${TAG_NAME}"

	setup

	curl \
	    -H "Authorization: token ${MY_GITHUB_TOKEN}" \
	    -H "Accept: application/vnd.github.v3+json" \
	    -X GET "https://api.github.com/repos/${TARGET_REPO}/releases/tags/${TAG_NAME}" |
	    tee ${CURL_OUTPUT}
	RELEASE_ID=$(cat ${CURL_OUTPUT} | grep id | head -n 1 | tr -d " " | tr "," ":" | cut -d ":" -f 2)

	echo ""
	echo "~~~~ Deleting release with ID ${RELEASE_ID} linked to ${TAG_NAME}"
	curl \
	    -H "Authorization: token ${MY_GITHUB_TOKEN}" \
	    -H "Accept: application/vnd.github.v3+json" \
	    -X DELETE "https://api.github.com/repos/${TARGET_REPO}/releases/${RELEASE_ID}"

	echo ""
	echo "~~~~ Deleting reference refs/tags/${TAG_NAME}"
	curl \
	    -H "Authorization: token ${MY_GITHUB_TOKEN}" \
	    -H "Accept: application/vnd.github.v3+json" \
	    -X DELETE  "https://api.github.com/repos/${TARGET_REPO}/git/refs/tags/${TAG_NAME}"
}

uploadArtifact() {
    local releaseId=$1
    local artifactName=$2
    local releaseArtifact="${artifactName}"
    echo "~~~~ Uploading asset to ReleaseId ${releaseId}, name=${artifactName}"

    curl \
        -H "Authorization: token ${MY_GITHUB_TOKEN}" \
        -H "Content-Type: application/zip" \
        -H "Accept: application/vnd.github.v3+json" \
        --data-binary @${releaseArtifact} \
         "https://uploads.github.com/repos/${TARGET_REPO}/releases/${releaseId}/assets?name=${artifactName}"
}

uploadResourceToGitHub() {
	echo "Current TAG_NAME=${TAG_NAME}"
	echo ""
	echo "~~~~ Uploading dataset artifact"

	setup

  	deleteResourceFromGitHub

	POST_DATA=$(printf '{
	"tag_name": "%s",
	"target_commitish": "master",
	"name": "%s",
	"body": "Release %s",
	"draft": false,
	"prerelease": false
	}' ${TAG_NAME} ${TAG_NAME} ${TAG_NAME})
	echo "~~~~ Creating release ${RELEASE_VERSION}: $POST_DATA"

	curl \
	  -H "Authorization: token ${MY_GITHUB_TOKEN}" \
	  -H "Content-Type: application/json" \
	  -H "Accept: application/vnd.github.v3+json" \
	  -X POST -d "${POST_DATA}" "https://api.github.com/repos/${TARGET_REPO}/releases"

	echo "~~~~ Getting Github ReleaseId"
	curl \
	  -H "Authorization: token ${MY_GITHUB_TOKEN}" \
	  -H "Accept: application/vnd.github.v3+json" \
	  -X GET "https://api.github.com/repos/${TARGET_REPO}/releases/tags/${TAG_NAME}" |
	  tee ${CURL_OUTPUT}
	RELEASE_ID=$(cat ${CURL_OUTPUT} | grep id | head -n 1 | tr -d " " | tr "," ":" | cut -d ":" -f 2)

	TARGET_ARTIFACT_FILE="${1:-dl4j-nlp-src-main-resources.tgz}"

	if [[ -z "${TARGET_ARTIFACT_FILE:-}" ]]; then
		echo ""
		echo "Please specify the artifact to upload as parameter"
		echo "Usage:"
		echo "   $0 [artifact]"
		echo ""
		exit -1
	fi

	uploadArtifact ${RELEASE_ID} "${TARGET_ARTIFACT_FILE}"

	echo "~~~~ Finished uploading to GitHub"
	echo ""
	echo "~~~~ Checkout curl output at ${CURL_OUTPUT}"
	echo ""
	echo "Use curl -O -L [github release url] to download this artifacts."
	echo "    for e.g."
	echo "        curl -J -O -L https://github.com/${TARGET_REPO}/releases/download/${TAG_NAME}/${TARGET_ARTIFACT_FILE}"
}

showUsageText() {
    cat << HEREDOC

       Usage: $0 --targetRepo [GitHub repo name]
                                 --createResource
                                 --uploadResourceToGitHub
                                 --deleteResourceFromGitHub
                                 --help

       --targetRepo                  GitHub repo name (mandatory with upload and delete commands, for e.g. neomatrix369/awesome-ai-ml-dl)
       --createResource              (command action) create the resource artifact
       --uploadResourceToGitHub      (command action) upload the created resource artifact to GitHub Releases
       --deleteResourceFromGitHub    (command action) delete the resource artifact from GitHub Releases
       --help                        shows the script usage help text

HEREDOC

	exit 1
}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURL_OUTPUT="${CURRENT_DIR}/artifacts/github-release.listing"
TARGET_ARTIFACT="${CURRENT_DIR}/dl4j-nlp-src-main-resources.tgz"
RELEASE_VERSION="0.1"
TAG_NAME="dl4j-nlp-src-main-resources-v${RELEASE_VERSION}"
TARGET_REPO="${TARGET_REPO:-"neomatrix369/awesome-ai-ml-dl""

if [[ "$#" -eq 0 ]]; then
	echo "No parameter has been passed. Please see usage below:"
	showUsageText
fi

while [[ "$#" -gt 0 ]]; do case $1 in
  --help)                      showUsageText;
                               exit 0;;
  --targetRepo)                TARGET_REPO="${2:-}";
                               shift;;
  --createResource)            createResourceArtifact;
                               exit 0;;
  --uploadResourceToGitHub)    uploadResourceToGitHub;
                               exit 0;;
  --deleteResourceFromGitHub)  deleteResourceFromGitHub;
                               exit 0;;                               
                               
  *) echo "Unknown parameter passed: $1";
     showUsageText;
esac; shift; done

if [[ "$#" -eq 0 ]]; then
	echo "No command action passed in as parameter. Please see usage below:"
	showUsageText
fi