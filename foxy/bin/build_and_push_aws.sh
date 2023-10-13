#!/usr/bin/env bash
# Build and push docker image with needed dependencies for running to the ECR
# The role for this ec2 user must support ecr:InitiateLayerUpload
# This will build and upload the image <account>.dkr.ecr.us-west-2.amazonaws.com/helloworld_ros_melodic_gazebo9_app:<github hash>
# Run with ./build_and_push_aws.sh helloworld_ros_melodic_gazebo9_app
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$(cd "$(dirname "${SCRIPT_DIR}/../.." )" && pwd )"
set -x

# Get the short version of the hash of the commit
git_hash=$(git log -1 --format=%h)
GIT_VERSION="${git_hash}"

# Build the base image
cd $BASE_DIR/containers/base && docker build -t helloworld_foxy_g11_base:${GIT_VERSION} .

# Build the robot app and simulation images
cd $BASE_DIR

GIT_VERSION=${GIT_VERSION} docker-compose -f compose.yml build 

# The name of our algorithms build in docker-compose
algorithm_names=(helloworld_foxy_g11_app helloworld_foxy_g11_sim)

# Get the AWS account
account=$(aws sts get-caller-identity --query Account --output text)

# Get the region defined in the current configuration (default to us-west-2 if none defined)
region=$(aws configure get region)
region=${region:-us-west-2}

# Get the login command from ECR and execute it directly
aws ecr get-login-password | docker login --username AWS --password-stdin "$(aws sts get-caller-identity --query Account --output text).dkr.ecr.${region}.amazonaws.com"

# iterate through the algorithms
for algorithm_name in "${algorithm_names[@]}"
do
    fullname="${account}.dkr.ecr.${region}.amazonaws.com/mbari/${algorithm_name}"

    # If the repository doesn't exist in ECR, create it.
    aws ecr describe-repositories --repository-names "mbari/${algorithm_name}" > /dev/null 2>&1

    if [ $? -ne 0 ]
    then
        aws ecr create-repository --repository-name "mbari/${algorithm_name}" > /dev/null
    fi

    # Push the docker image to ECR with the full name
    docker tag ${algorithm_name} ${fullname}:${GIT_VERSION}
    docker push ${fullname}:${GIT_VERSION}
done
