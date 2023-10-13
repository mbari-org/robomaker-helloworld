# Basic RoboMaker Hello World 

Basic repo to understand how to run a sample app and simulation in ROS and Gazebo.
Essentially the same as the reference below with better organization and docker
compose orchestration.

References:

https://docs.aws.amazon.com/robomaker/latest/dg/run-hello-world-ros.html
https://docs.aws.amazon.com/robomaker/latest/dg/run-hello-world-ros-2.html

# Requirements

 - [Docker](https://docs.docker.com/get-docker/)
 - [Docker Compose](https://docs.docker.com/compose/install/)
 - AWS account with ECR, S3, and RoboMaker permission

# Notes

 - Melodic/Gazebo 9 failed with core dump so switching to Foxy and Gazebo 11 10-11-23
 - Foxy/Gazebo 11 working with some minor changes in the run-hello-world-ros-2 example

# Run locally

```
git clone https://github.com/mbari-org/robomaker-helloworld.git
cd robomaker-helloworld/foxy
./bin/build_and_run.sh
```

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
./bin/run_viz.sh
```

# Run in AWS RoboMaker

## Setup your credentials using awscli

For the exercise, I used a local account setup as if this would be a new user/student.

```bash
aws configure --profile 902204-compas
```

## Push to AWS ECR

Be patient - this takes a while.

```bash
./bin/build_and_push_aws.sh
```

should see something like the following upon completion 
```

```
