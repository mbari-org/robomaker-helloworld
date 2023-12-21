#!/usr/bin/env bash
# Create a simulation application in RoboMaker
# References:
# https://docs.aws.amazon.com/cli/latest/reference/robomaker/create-simulation-application.html
# https://docs.aws.amazon.com/cli/latest/reference/robomaker/create-simulation-job.html

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$(cd "$(dirname "${SCRIPT_DIR}/../.." )" && pwd )"

# The name of our simulation application
app_name=robomaker-helloworld_sim

# Get the short version of the hash of the commit
GIT_VERSION=$(git log -1 --format=%h)
GIT_VERSION=8b6cd40

# Get the AWS account
account=$(aws sts get-caller-identity --query Account --output text)

# Get the region defined in the current configuration (default to us-west-2 if none defined)
region=$(aws configure get region)
region=${region:-us-west-2}

ecruri=$account.dkr.ecr.$region.amazonaws.com

# Create a directory to store the output and some helpers to organize the output
output_dir=$SCRIPT_DIR/sim
mkdir -p $output_dir
sim_app_json=$output_dir/sim_app.json
sim_job_json=$output_dir/sim_job.json
sim_job_out_json=$output_dir/sim_job_out.json

# Create the simulation application and capture the output to json
# Skip over this is the json file already exists
echo "Creating simulation application "
aws robomaker create-simulation-application  \
--name ${app_name} \
--simulation-software-suite name=SimulationRuntime \
--robot-software-suite name=General \
--environment uri=$ecruri/${app_name}:${GIT_VERSION} \
--output json > $sim_app_json

# Get the arn of the simulation application from the output
sim_arn=$(cat $sim_app_json | grep arn | cut -d'"' -f4)

echo "Simulation application: $sim_arn"

# Replace the arn in the template with the one we just created
sed "s|SIMULATION_APPLICATION_ARN|$sim_arn|g" $SCRIPT_DIR/simulation_job_template.json > $sim_job_json

# Create a simulation job
aws robomaker create-simulation-job --cli-input-json file://$sim_job_json --output json > $sim_job_out_json

cat $sim_job_out_json
echo "Done creating simulation job. Check the AWS RoboMaker console for status at https://console.aws.amazon.com/robomaker/home?region=$region#simulationJobs"