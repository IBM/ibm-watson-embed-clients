# This image is only for building, so we run as root
## Python client #####################################################################
#
# This phase builds the python wheel
##
FROM python:3.9-slim as python-client

ARG LIB_NAME
ARG PYTHON_RELEASE_VERSION

WORKDIR /app
# Install build dependencies
COPY ${LIB_NAME}/python/requirements.txt /app/requirements.txt
RUN true && \
    pip install pip --upgrade && \
    pip install twine && \
    pip install -r /app/requirements.txt

# Copy all files needed for proto compilation
COPY ${LIB_NAME}/protos /app/protos
COPY ${LIB_NAME}/python/generated /app/generated
# Copy files for client wheel packaging
COPY ${LIB_NAME}/python/setup_client.py /app/setup_client.py

# Compile the protos
RUN python3 -m grpc_tools.protoc \
    -I protos --python_out=generated \
    --grpc_python_out=generated protos/*.proto
# Create the wheel
RUN python3 setup_client.py bdist_wheel clean --all

## Node client #####################################################
#
# This phase builds the NPM package
##
FROM node:16-slim as node-client

WORKDIR /app

ARG NODE_RELEASE_VERSION
ARG LIB_NAME

# Copy all files needed for proto compilation
COPY ${LIB_NAME}/protos /app/protos

# Install grpc tools
RUN npm install -g grpc-tools
# Compile the protos
RUN  mkdir node_dir && \
    grpc_tools_node_protoc -I \
    protos --js_out=import_style=commonjs,binary:node_dir \
    --grpc_out=grpc_js:node_dir protos/*.proto

COPY ${LIB_NAME}/node/package.json.template /app/node_dir/package.json
# Replace LIB_NAME in the package.json based on the library, also replace _ with - in LIB_NAME
RUN sed -i "s/{LIB_NAME}/$(echo ${LIB_NAME} | sed s/_/-/g)/g" /app/node_dir/package.json
RUN sed -i "s/{VERSION}/${NODE_RELEASE_VERSION}/g" /app/node_dir/package.json