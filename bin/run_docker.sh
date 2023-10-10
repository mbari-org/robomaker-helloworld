#!/usr/bin/env bash
# Run the docker images
# Run with ./run_docker.sh
set -x
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$(cd "$(dirname "${SCRIPT_DIR}/../.." )" && pwd )"

# Get the short version of the hash of the commit
git_hash=$(git log -1 --format=%h)
GIT_VERSION="${git_hash}"

# Build the robot app and simulation images
GIT_VERSION=$GIT_VERSION docker-compose -f $BASE_DIR/compose.yml up --remove-orphans