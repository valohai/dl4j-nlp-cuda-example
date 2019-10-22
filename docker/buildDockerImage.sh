#!/bin/bash

set -e
set -u
set -o pipefail

IMAGE_NAME=${IMAGE_NAME:-dl4j-nlp-cuda}
IMAGE_VERSION=${IMAGE_VERSION:-$(cat ../version.txt)}
DOCKER_FULL_TAG_NAME="${DOCKER_USER_NAME}/${IMAGE_NAME}"

cp ../know-your-gpus.sh .

time docker build                                            \
                 --build-arg WORKDIR=/workspace              \
                 --build-arg MAVEN_TARGET_DIR=/opt           \
                 --build-arg MAVEN_VERSION=3.6.1             \
                 -t ${DOCKER_FULL_TAG_NAME}:${IMAGE_VERSION} \
                 .

rm -f know-your-gpus.sh