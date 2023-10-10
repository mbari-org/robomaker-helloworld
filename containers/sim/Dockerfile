# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
FROM helloworld_ros_melodic_gazebo9_base:latest

# Build the Simulation application
RUN cd /home/robomaker/workspace/aws-robomaker-sample-application-helloworld-ros1/simulation_ws && \
    /bin/bash -c "source /opt/ros/melodic/setup.bash && vcs import < .rosinstall && rosdep install --rosdistro melodic --from-paths src --ignore-src -r -y && colcon build"

COPY sim-entrypoint.sh /home/robomaker/sim-entrypoint.sh

RUN sh -c 'sudo chmod +x /home/robomaker/sim-entrypoint.sh'
RUN sh -c 'sudo chown robomaker:robomaker /home/robomaker/sim-entrypoint.sh'

CMD roslaunch hello_world_simulation empty_world.launch
ENTRYPOINT [ "/home/robomaker/sim-entrypoint.sh" ]

