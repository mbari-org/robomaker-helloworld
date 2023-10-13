# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
ARG GIT_VERSION
FROM helloworld_foxy_g11_base:${GIT_VERSION}

RUN sudo apt update && \
    rosdep update && \
    rosdep fix-permissions

WORKDIR /home/robomaker/workspace/aws-robomaker-sample-application-helloworld-ros2

# Build the Robot application
RUN cd robot_ws && \
 sudo bash -c 'source /opt/ros/foxy/setup.bash && \
 vcs import < .rosinstall && \
 rosdep install --rosdistro foxy --from-paths src --ignore-src -r -y && \
 colcon build'

USER robomaker

COPY robot-entrypoint.sh /home/robomaker/robot-entrypoint.sh
RUN sh -c 'sudo chmod +x /home/robomaker/robot-entrypoint.sh'
RUN sh -c 'sudo chown robomaker:robomaker /home/robomaker/robot-entrypoint.sh'

CMD ros2 launch hello_world_robot rotate.launch.py
ENTRYPOINT [ "/home/robomaker/robot-entrypoint.sh" ]
              
