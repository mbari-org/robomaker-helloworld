#!/usr/bin/env bash
# Run the docker images
# Run with ./run_docker.sh
set -x
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$(cd "$(dirname "${SCRIPT_DIR}/../.." )" && pwd )"

# Build the base image
cd $BASE_DIR/containers/base
docker build -t mbari/base -t helloworld_ros_melodic_gazebo9_base:latest .

# Build the robot app and simulation images
docker-compose -f $BASE_DIR/compose.yml up --remove-orphans