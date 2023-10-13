#!/bin/bash
# Enable access to X server to launch Gazebo from docker container
xhost +

# Connect to the sim app container and aunch Gazebo from within the container
docker exec -it  robomaker-helloworld_app_1 /home/robomaker/robot-entrypoint.sh rosrun gazebo_ros gzclient
