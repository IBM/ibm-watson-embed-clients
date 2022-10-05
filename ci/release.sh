#!/usr/bin/env bash

set -e
# Run from the project root
cd $(dirname ${BASH_SOURCE[0]})/..


echo "Releasing ${VERSION}"

# Dispatch to the various types of releases

#this dir holds all wheel files to push later
mkdir dist

# TODO iterate through all dirs, pick only watson_* ones automatically?
WATSON_LIBS=("watson_nlp")
for lib in "${WATSON_LIBS[@]}"
do
    echo "handling $lib"

    docker build -t "${lib}":"$VERSION" . \
    --target=python-client \
    --build-arg PYTHON_RELEASE_VERSION="$VERSION" \
    --build-arg LIB_NAME="${lib}"

    # copy the generated wheel file
    docker create --name="${lib}"-tmp "${lib}":"$VERSION" && docker cp "${lib}"-tmp:/src/dist/. dist/ && docker rm "${lib}"-tmp

    # node
    docker build -t "${lib}":"$VERSION" . \
    --target=node-client \
    --build-arg NODE_RELEASE_VERSION="$VERSION" \
    --build-arg LIB_NAME="${lib}"
done