# Basic RoboMaker Hello World 

Basic repo to understand how to run a sample app and simulation in ROS and Gazebo.

Similar to the reference below with better organization, docker
compose orchestration, docker build/push scripts, and MBARI specific
login information.

This has been tested on Ubuntu.  It may work on Mac and Windows, but has not been tested.

References:


https://docs.aws.amazon.com/robomaker/latest/dg/run-hello-world-ros.html
https://docs.aws.amazon.com/robomaker/latest/dg/run-hello-world-ros-2.html

# Requirements

 - [Docker](https://docs.docker.com/get-docker/)
 - [Docker Compose](https://docs.docker.com/compose/install/)
 - AWS account with ECR, S3, and RoboMaker permission

# Run locally

```
git clone https://github.com/mbari-org/robomaker-helloworld.git
cd robomaker-helloworld
docker login
./bin/build_and_run.sh
```

NOTE - if you see the error **ERROR: failed to solve: helloworld_foxy_g11_base:1fe1cac: pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed**
this likely means that you have not logged into docker

Should see something like this:

```bash
Recreating robomaker-helloworld_app_1 ... done
Recreating robomaker-helloworld_sim_1 ... done
Attaching to robomaker-helloworld_app_1, robomaker-helloworld_sim_1
app_1  | GAZEBO_MODEL_PATH=/usr/share/gazebo-9/models:
app_1  | LC_ALL=C.UTF-8
app_1  | LD_LIBRARY_PATH=/opt/ros/melodic/lib:/usr/lib/aarch64-linux-gnu/gazebo-9/plugins
app_1  | LANG=C.UTF-8
```

This launches two docker containers: one for the robot application, and the other for simulation.

## Visualize the simulation using Gazebo with

```bash
./bin/viz_sim.sh
```

# Run in AWS RoboMaker

## Setup your credentials using awscli

Login with your MBARI credentials at [https://mbari.awsapps.com/start#/](https://mbari.awsapps.com/start#/)
and download your credentials. Then run the following command to configure your 
credentials locally in the `902204-compas` profile.:
 

```bash
aws configure --profile 902204-compas
```

To use that profile, set the AWS_PROFILE environment variable

```shell
export AWS_PROFILE=902204-compas
```


## Push to AWS ECR

The docker images need to be pushed to AWS ECR, which is akin to the Docker Hub
but hosted in AWS.  This is done using the following script.

Be patient - this takes a while.

```bash
./bin/build_and_push_aws.sh
```

should see something like the following upon completion 
```
++ git log -1 --format=%h
+ git_hash=1fe1cac
+ GIT_VERSION=1fe1cac
+ cd /Users/dcline/Dropbox/code/robomaker-helloworld/containers/base
+ docker build -t helloworld_foxy_g11_base:1fe1cac .
docker push 731784785618.dkr.ecr.us-west-2.amazonaws.com/mbari/helloworld_foxy_g11_sim:1fe1cac
The push refers to repository [731784785618.dkr.ecr.us-west-2.amazonaws.com/mbari/helloworld_foxy_g11_sim]
8
docker push 731784785618.dkr.ecr.us-west-2.amazonaws.com/mbari/helloworld_foxy_g11_app:1fe1cac
The push refers to repository [731784785618.dkr.ecr.us-west-2.amazonaws.com/mbari/helloworld_foxy_g11_app]
...
 

### Run the simulation in a AWS RoboMaker Job

```shell
./bin/run_robomaker_simulation.sh
```

This will create a RoboMaker job and run the simulation in the cloud.  You can monitor the job in the AWS console.

You should see the simulation job details printed in JSON with details about the job, e.g.
Pending, Running, etc.

Here, we see tha the job is pending. Job defaults can be overriden in the bin/simulation_job_tempate.json file.

```json
{
    "arn": "arn:aws:robomaker:us-west-2:731784785618:simulation-job/sim-vzl06993swmc",
    "status": "Pending",
    "lastUpdatedAt": 1697318042.0,
    "failureBehavior": "Fail",
    "clientRequestToken": "29c4a2e4-cc57-4cb0-b715-481f978fd0ff",
    "loggingConfig": {
        "recordAllRosTopics": false
    },
    "maxJobDurationInSeconds": 300,
    "simulationTimeMillis": 0,
    "iamRole": "arn:aws:iam::731784785618:role/robomaker-jobs",
    "simulationApplications": [
        {
            "application": "arn:aws:robomaker:us-west-2:731784785618:simulation-application/hector_quadrotor_simulation/1697314270351",
            "applicationVersion": "$LATEST",
            "launchConfig": {
                "streamUI": true,
                "command": [
                    "roslaunch",
                    "hector_quadrotor_demo",
                    "double_void.launch"
                ]
            },
            "uploadConfigurations": [],
            "useDefaultUploadConfigurations": false,
            "tools": [
                {
                    "streamUI": true,
                    "name": "gzclient",
                    "command": "/simulation-entrypoint.sh && gzclient",
                    "streamOutputToCloudWatch": true,
                    "exitBehavior": "RESTART"
                }
            ],
            "useDefaultTools": false
        }
    ],
    "tags": {},
    "compute": {
        "simulationUnitLimit": 1,
        "computeType": "CPU",
        "gpuUnitLimit": 0
    }
}
```