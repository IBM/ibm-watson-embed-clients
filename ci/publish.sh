#!/usr/bin/env bash

# Run from the base of the python directory
cd $(dirname ${BASH_SOURCE[0]})/..

# Clear out old publication files in case they're still around
rm -rf build dist *.egg-info/

# Publish to PyPi
if [ "${RELEASE_DRY_RUN}" != "true" ]
then
    echo "Publishing Release"
    un_arg=""
    pw_arg=""
    if [ "$PYPI_TOKEN" != "" ]
    then
        un_arg="--username __token__"
        pw_arg="--password $PYPI_TOKEN"
    fi
    twine upload $un_arg $pw_arg dist/*
else
    echo "Release DRY RUN"
fi

# Clean up
rm -rf build dist *.egg-info/
