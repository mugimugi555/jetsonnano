#!/bin/bash

#

#-----------------------------------------------------------------------------------------------------------------------
# add repository
#-----------------------------------------------------------------------------------------------------------------------
sudo apt-add-repository universe   ;
sudo apt-add-repository multiverse ;
sudo apt-add-repository restricted ;
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' ;
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 ;

#-----------------------------------------------------------------------------------------------------------------------
# install ros
#-----------------------------------------------------------------------------------------------------------------------
sudo apt update ;
sudo apt install ros-melodic-desktop-full ;
echo "source /opt/ros/melodic/setup.bash" >> ~/.profile ;
source ~/.profile ;
#sudo apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential ;

#-----------------------------------------------------------------------------------------------------------------------
# install python-ros
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install python-rosdep ;
sudo rosdep init ;
rosdep update ;

#-----------------------------------------------------------------------------------------------------------------------
# create project
#-----------------------------------------------------------------------------------------------------------------------
mkdir -p ~/workspace/catkin_ws/src ;
cd ~/workspace/catkin_ws ;
catkin_make ;
echo "source ~/workspace/catkin_ws/devel/setup.bash">> ~/.profile ;
source ~/.profile ;

#-----------------------------------------------------------------------------------------------------------------------
# lunch app
#-----------------------------------------------------------------------------------------------------------------------
roscore &
rviz    &
gazebo  &

#-----------------------------------------------------------------------------------------------------------------------
# kill
#-----------------------------------------------------------------------------------------------------------------------
# pkill roscore ;
# pkill rviz    ;
# pkill gazebo  ;
