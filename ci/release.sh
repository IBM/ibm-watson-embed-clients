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
    #this dir holds all wheel files to push later
    mkdir dist
    docker build -t watson_nlp-python:"$VERSION" . \
        --target=python-client \
        --build-arg PYTHON_RELEASE_VERSION="$VERSION" \
        --build-arg LIB_NAME=watson_nlp
    # copy the generated wheel file
    docker create --name=watson_nlp-pytmp watson_nlp-python:"$VERSION" && docker cp watson_nlp-pytmp:/app/dist/. dist/ && docker rm watson_nlp-pytmp

    echo "Publishing to PyPi"
    if [ "$PYPI_TOKEN" != "" ]
    then
        echo "PYPI token exists"
        un_arg="--username __token__"
        pw_arg="--password $PYPI_TOKEN"
    fi
    pip install twine
    twine upload --repository testpypi $un_arg $pw_arg dist/*
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