#!/usr/bin/env bash

set -e
# Run from the project root
cd $(dirname ${BASH_SOURCE[0]})/..

echo "Releasing ${VERSION}"

# TODO 
# We could think about fetching RELEASE_TYPE
# and watson_library from the git tag?
# For example, if we create a tag like 
# watson_nlp-py-1.2.0, that means push
# the 1.2.0 version of python client for nlp?

# Dispatch to the various types of releases
if [ "$RELEASE_TYPE" == "py" ]
then
    docker build -t watson_nlp-python:"$VERSION" . \
        --target=python-client \
        --build-arg PYTHON_RELEASE_VERSION="$VERSION" \
        --build-arg LIB_NAME=watson_nlp \
        --build-arg PYPI_TOKEN=${PYPI_TOKEN:-""} \
        --build-arg RELEASE_DRY_RUN=${RELEASE_DRY_RUN:-"false"} \
        --build-arg PYTHON_VERSION=${PYTHON_VERSION:-"3.7"}
elif [ "$RELEASE_TYPE" == "node" ]
then
    docker build -t watson_nlp-node:"$VERSION" . \
    --target=node-client \
    --build-arg NODE_RELEASE_VERSION="$VERSION" \
    --build-arg LIB_NAME=watson_nlp

    mkdir node_dir_watson_nlp
    # copy the generated package
    docker create --name=watson_nlp-nodetmp watson_nlp-node:"$VERSION" && docker cp watson_nlp-nodetmp:/app/node_dir/. node_dir_watson_nlp/ && docker rm watson_nlp-nodetmp
fi