## Base ########################################################################
#
# This phase sets up dependencies for the other phases
##
ARG PYTHON_VERSION=3.9
FROM python:${PYTHON_VERSION}-slim as base

ARG LIB_NAME
# This image is only for building, so we run as root
WORKDIR /src
# Install build dependencies
COPY ${LIB_NAME}/python/requirements.txt /src/requirements.txt
RUN true && \
    pip install pip --upgrade && \
    pip install twine && \
    pip install -r /src/requirements.txt && \
    true

## Build #####################################################################
#
# This phase builds the release
##
FROM base as build
ARG PYTHON_RELEASE_VERSION
ARG LIB_NAME
COPY ${LIB_NAME}/protos /src/protos
COPY ${LIB_NAME}/python/generated /src/generated
# Copy files for client wheel packaging
COPY ${LIB_NAME}/python/setup_client.py /src/setup_client.py
COPY ${LIB_NAME}/python/requirements.txt /src/requirements.txt

RUN python3 -m grpc_tools.protoc \
    -I protos --python_out=generated \
    --grpc_python_out=generated protos/*.proto
RUN python3 setup_client.py bdist_wheel clean --all