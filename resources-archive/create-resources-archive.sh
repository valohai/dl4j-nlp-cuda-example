#!/bin/bash

set -e
set -u
set -o pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TARGET_ARCHIVE="${CURRENT_DIR}/dl4j-nlp-src-main-resources.tgz"

echo ""
echo "~~~ Deleting ${TARGET_ARCHIVE}"
rm -f ${TARGET_ARCHIVE}

echo ""
echo "~~~ Creating new archive ${TARGET_ARCHIVE}"
(
	cd .. && \
	   tar -zvcf                         \
	        ${TARGET_ARCHIVE}            \
	        --exclude='dropwizard.yml'   \
	        --exclude='log4j.properties' \
	        --exclude='logback.xml'      \
	        src/main/resources/*
)

echo ""
ls -lash ${TARGET_ARCHIVE}