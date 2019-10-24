#!/bin/bash

set -e
set -u
set -o pipefail


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
   echo "Copying word2vec pre-trained Google News corpus into the data folder" >&2
   cp "${VH_INPUTS_DIR}/google-word2vec/GoogleNews-vectors-negative300.bin.gz" "${VH_REPOSITORY_DIR}/data"
   echo "Copying IMDB Review dataset for sentiment analysis into the data/dl4j_w2vSentiment folder" >&2
   cp "${VH_INPUTS_DIR}/imdb-reviews/aclImdb_v1.tar.gz" "${VH_REPOSITORY_DIR}/data/dl4j_w2vSentiment"
fi