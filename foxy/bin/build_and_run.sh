#!/usr/bin/env bash
# Build and run the docker images
# Run with ./build_and_run.sh
set -x
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$(cd "$(dirname "${SCRIPT_DIR}/../.." )" && pwd )"

# Get the short version of the hash of the commit
git_hash=$(git log -1 --format=%h)
GIT_VERSION="${git_hash}"

# Build the base image
cd $BASE_DIR/containers/base && docker build -t helloworld_foxy_g11_base:${GIT_VERSION} .

# Build the robot app and simulation images
cd $BASE_DIR && GIT_VERSION=${GIT_VERSION} docker-compose -f compose.yml up --build
