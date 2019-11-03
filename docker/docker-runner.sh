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

findImage() {
	IMAGE_NAME=$1
	echo $(docker images ${IMAGE_NAME} -q | head -n1 || true)
}

runContainer() {
	setFullDockerTagName

	echo "Running container ${FULL_DOCKER_TAG_NAME}:${IMAGE_VERSION}"; echo ""

	docker run -it                                        \
           --volume $(pwd):/$(pwd)                        \
           --env JAVA_HOME=/graalvm                       \
           ${FULL_DOCKER_TAG_NAME}:${IMAGE_VERSION}       \
           /bin/bash
}

buildImage() {
	setFullDockerTagName

	echo "Building image ${FULL_DOCKER_TAG_NAME}:${IMAGE_VERSION}"; echo ""

	cp ../know-your-gpus.sh .

	time docker build                                            \
	                 --build-arg WORKDIR=/workspace              \
	                 --build-arg MAVEN_TARGET_DIR=/opt           \
	                 --build-arg MAVEN_VERSION=3.6.1             \
	                 -t ${FULL_DOCKER_TAG_NAME}:${IMAGE_VERSION} \
	                 .

	rm -f know-your-gpus.sh
}

pushImageToHub() {
	setFullDockerTagName

	echo "Pushing image ${FULL_DOCKER_TAG_NAME}:${IMAGE_VERSION} to Docker Hub"; echo ""

	IMAGE_FOUND="$(findImage ${DOCKER_USER_NAME}/${IMAGE_NAME})"
	if [[ -z "${IMAGE_FOUND}" ]]; then
	    echo "Docker image '${DOCKER_USER_NAME}/${IMAGE_NAME}' not found in the local repository"
	    IMAGE_FOUND="$(findImage ${IMAGE_NAME})"
	    if [[ -z "${IMAGE_FOUND}" ]]; then
	    	echo "Docker image '${IMAGE_NAME}' not found in the local repository"
	    	exit 1
	    else 
	    	echo "Docker image '${IMAGE_NAME}' found in the local repository"
	    fi
	else
	    echo "Docker image '${DOCKER_USER_NAME}/${IMAGE_NAME}' found in the local repository"
	fi

	docker tag ${IMAGE_FOUND} ${FULL_DOCKER_TAG_NAME}:${IMAGE_VERSION}
	docker login --username=${DOCKER_USER_NAME}
	docker push ${FULL_DOCKER_TAG_NAME}
}

showUsageText() {
    cat << HEREDOC

       Usage: $0 --dockerUserName [docker user name]
                                 --buildImage      
                                 --runContainer    
                                 --pushImageToHub 
                                 --help

       --dockerUserName      docker user name as on Docker Hub (mandatory with build, run and push commands)
       --buildImage          (command action) build the docker image
       --runContainer        (command action) build the run the docker image as a docker container
       --pushImageToHub      (command action) push the docker image built to Docker Hub
       --help                shows the script usage help text

HEREDOC

	exit 1
}

askDockerUserNameIfAbsent() {
	if [[ -z ${DOCKER_USER_NAME:-""} ]]; then
	  read -p "Enter Docker username (must exist on Docker Hub): " DOCKER_USER_NAME
	fi	
}

setFullDockerTagName() {
	askDockerUserNameIfAbsent

	FULL_DOCKER_TAG_NAME="${DOCKER_USER_NAME}/${IMAGE_NAME}"	
}

IMAGE_NAME=${IMAGE_NAME:-dl4j-nlp-cuda}
IMAGE_VERSION=${IMAGE_VERSION:-$(cat ../version.txt)}
FULL_DOCKER_TAG_NAME=""
DOCKER_USER_NAME="${DOCKER_USER_NAME:-}"

if [[ "$#" -eq 0 ]]; then
	echo "No parameter has been passed. Please see usage below:"
	showUsageText
fi

while [[ "$#" -gt 0 ]]; do case $1 in
  --help)                showUsageText;
                         exit 0;;
  --dockerUserName)      DOCKER_USER_NAME="${2:-}";
                         shift;;
  --buildImage)          buildImage;
                         exit 0;;
  --runContainer)        runContainer;
                         exit 0;;
  --pushImageToHub)      pushImageToHub;
                         exit 0;;
  *) echo "Unknown parameter passed: $1";
     showUsageText;
esac; shift; done

if [[ "$#" -eq 0 ]]; then
	echo "No command action passed in as parameter. Please see usage below:"
	showUsageText
fi