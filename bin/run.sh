#!/usr/bin/env bash
# Run robot and simulator; requires running build_docker.sh first
docker run -it -e DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
	-u robomaker -e ROBOMAKER_GAZEBO_MASTER_URI=http://localhost:5555 \
	-e ROBOMAKER_ROS_MASTER_URI=http://localhost:11311 \
	helloworld_ros_melodic_gazebo9_app:latest
exit

docker run -it -e DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
	-u robomaker -e ROBOMAKER_GAZEBO_MASTER_URI=http://localhost:5555 \
	-e ROBOMAKER_ROS_MASTER_URI=http://localhost:11311 \
	helloworld_ros_melodic_gazebo9_sim:latest
