# Basic RoboMaker Hello World 

Basic repo to understand how to run a sample app and simulation in ROS Melodic and Gazebo 9.
Essentially the same as the reference below with better organization and compose orchestration.

References:

https://docs.aws.amazon.com/robomaker/latest/dg/run-hello-world-ros.html

# Requirements

 - [Docker](https://docs.docker.com/get-docker/)
 - [Docker Compose](https://docs.docker.com/compose/install/)

# Build and run locally

Build
  
```bash
./bin/build_docker.sh
```

Run

```bash
./bin/run_docker.sh
```

Should see something like this:

```bash
ecreating robomaker-helloworld_app_1 ... done
Recreating robomaker-helloworld_sim_1 ... done
Attaching to robomaker-helloworld_app_1, robomaker-helloworld_sim_1
app_1  | GAZEBO_MODEL_PATH=/usr/share/gazebo-9/models:
app_1  | LC_ALL=C.UTF-8
app_1  | LD_LIBRARY_PATH=/opt/ros/melodic/lib:/usr/lib/aarch64-linux-gnu/gazebo-9/plugins
app_1  | LANG=C.UTF-8
...