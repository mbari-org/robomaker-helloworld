#!/usr/bin/env bash
# Build the docker images. Needs to be run before ./run_docker.sh
# Run with ./build_docker.sh
set -x
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$(cd "$(dirname "${SCRIPT_DIR}/../.." )" && pwd )"

# Get the short version of the hash of the commit
git_hash=$(git log -1 --format=%h)
GIT_VERSION="${git_hash}"

# Build the base image
cd $BASE_DIR/containers/base && docker build -t helloworld_ros_melodic_gazebo9_base:${GIT_VERSION} .

# Build the robot app and simulation images
echo GIT_VERSION=${GIT_VERSION} docker-compose -f $BASE_DIR/compose.yml build