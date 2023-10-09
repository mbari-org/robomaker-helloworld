# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
FROM helloworld_ros_melodic_gazebo9_app:latest

# Build the Robot application
RUN cd /home/robomaker/workspace/aws-robomaker-sample-application-helloworld-ros1/robot_ws && \
 /bin/bash -c "source /opt/ros/melodic/setup.bash && vcs import < .rosinstall && rosdep install --rosdistro melodic --from-paths src --ignore-src -r -y && colcon build"

COPY robot-entrypoint.sh /home/robomaker/robot-entrypoint.sh

RUN sh -c 'sudo chmod +x /home/robomaker/robot-entrypoint.sh'
RUN sh -c 'sudo chown robomaker:robomaker /home/robomaker/robot-entrypoint.sh'

CMD roslaunch hello_world_robot rotate.launch
ENTRYPOINT [ "/home/robomaker/robot-entrypoint.sh" ]

