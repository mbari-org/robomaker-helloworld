# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
ARG GIT_VERSION
FROM helloworld_foxy_g11_base:$GIT_VERSION

WORKDIR /home/robomaker/workspace/aws-robomaker-sample-application-helloworld-ros2


# Build the Simulation application
RUN cd simulation_ws && \
 sudo bash -c 'source /opt/ros/foxy/setup.bash && \
 vcs import < .rosinstall && \
 rosdep install --rosdistro foxy --from-paths src --ignore-src -r -y && \
 colcon build'

USER robomaker

COPY sim-entrypoint.sh /home/robomaker/sim-entrypoint.sh
CMD ros2 launch hello_world_simulation empty_world.launch.py
ENTRYPOINT [ "/home/robomaker/sim-entrypoint.sh" ]
