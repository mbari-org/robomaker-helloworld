# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
FROM ros:foxy

ENV DEBIAN_FRONTEND noninteractive
RUN rm /etc/apt/sources.list.d/ros2-snapshots.list
RUN apt update -y && apt install -y curl
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get clean
RUN apt-get update --allow-insecure-repositories && apt-get install -y --allow-unauthenticated \
    lsb  \
    unzip \
    wget \
    curl \
    sudo \
    python3-vcstool \
    python3-rosinstall \
    python3-colcon-common-extensions \
    ros-foxy-turtlebot3 \
    ros-foxy-rviz2 \
    ros-foxy-rqt \
    ros-foxy-rqt-common-plugins \
    devilspie \
    xfce4-terminal

RUN wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -; \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN apt-get update --allow-insecure-repositories && apt-get install -y --allow-unauthenticated gazebo11

ENV QT_X11_NO_MITSHM=1

ARG USERNAME=robomaker
RUN groupadd $USERNAME
RUN useradd -ms /bin/bash -g $USERNAME $USERNAME
RUN sh -c 'echo "$USERNAME ALL=(root) NOPASSWD:ALL" >> /etc/sudoers'
USER $USERNAME
WORKDIR /home/$USERNAME/workspace

# Download and build our Robot and Simulation application
RUN wget https://github.com/aws-robotics/aws-robomaker-sample-application-helloworld/archive/3527834.zip && \
	unzip 3527834.zip && \
	mv aws-robomaker-sample-application-helloworld-3527834771373beff0ed3630c13479567db4149e aws-robomaker-sample-application-helloworld-ros2

RUN sudo rosdep fix-permissions
RUN rosdep update

WORKDIR /home/robomaker/workspace/aws-robomaker-sample-application-helloworld-ros2              
