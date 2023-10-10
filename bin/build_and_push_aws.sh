#!/usr/bin/env bash
# Build and push docker image with needed dependencies for running to the ECR
# The role for this ec2 user must support ecr:InitiateLayerUpload
# This will build and upload the image <account>.dkr.ecr.us-west-2.amazonaws.com/helloworld_ros_melodic_gazebo9_app:<github hash>
# Run with ./build_and_push_aws.sh helloworld_ros_melodic_gazebo9_app
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$(cd "$(dirname "${SCRIPT_DIR}/../.." )" && pwd )"
set -x
pushd $BASE_DIR

# The name of our algorithms
algorithm_names=(helloworld_ros_melodic_gazebo9_app helloworld_ros_melodic_gazebo9_sim)

account=$(aws sts get-caller-identity --query Account --output text)

# Get the region defined in the current configuration (default to us-west-2 if none defined)
region=$(aws configure get region)
region=${region:-us-west-2}

# Get the short version of the hash of the commit
git_hash=$(git log -1 --format=%h)

# Build all the docker images
GIT_VERSION=${git_hash} ./bin/build_docker.sh

# iterate through the algorithms
for algorithm_name in "${algorithm_names[@]}"
do
    fullname="${account}.dkr.ecr.${region}.amazonaws.com/${algorithm_name}"

    # If the repository doesn't exist in ECR, create it.
    aws ecr describe-repositories --repository-names "${algorithm_name}" > /dev/null 2>&1

    if [ $? -ne 0 ]
    then
        aws ecr create-repository --repository-name "${fullname}" > /dev/null
    fi

    # Get the login command from ECR and execute it directly
    aws ecr get-login-password | docker login --username AWS --password-stdin "$(aws sts get-caller-identity --query Account --output text).dkr.ecr.${region}.amazonaws.com"

    # Push the docker image to ECR with the full name, git hash, and latest tag
    docker tag ${algorithm_name} ${fullname}:$git_hash
    docker push ${fullname}:$git_hash
    docker push ${fullname}:latest
done