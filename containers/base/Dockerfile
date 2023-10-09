# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
FROM ros:melodic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get clean
RUN apt-get update && apt-get install -y \
    lsb  \
    unzip \
    wget \
    curl \
    sudo \
    python-vcstool \
    python-rosinstall \
    python3-colcon-common-extensions \
    ros-melodic-rviz \
    ros-melodic-rqt \
    ros-melodic-rqt-common-plugins \
    devilspie \
    xfce4-terminal \
    ros-melodic-gazebo-ros-pkgs \
    ros-melodic-gazebo-ros-control \
    ros-melodic-turtlebot3

ENV QT_X11_NO_MITSHM=1

ARG USERNAME=robomaker
RUN groupadd $USERNAME
RUN useradd -ms /bin/bash -g $USERNAME $USERNAME
RUN sh -c 'echo "$USERNAME ALL=(root) NOPASSWD:ALL" >> /etc/sudoers'
USER $USERNAME

RUN sh -c 'cd /home/$USERNAME'

# Download and build our Robot and Simulation application
RUN sh -c 'mkdir -p /home/robomaker/workspace'
RUN sh -c 'cd /home/robomaker/workspace && wget https://github.com/aws-robotics/aws-robomaker-sample-application-helloworld/archive/ros1.zip && unzip ros1.zip'
RUN sh -c 'cd /home/robomaker/workspace/aws-robomaker-sample-application-helloworld-ros1'

RUN sudo rosdep fix-permissions
RUN rosdep update
                        
