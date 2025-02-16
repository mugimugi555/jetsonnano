# Qengineering/Jetson-Nano-Ubuntu-20-image: Jetson Nano with Ubuntu 20.04 image 
# https://github.com/Qengineering/Jetson-Nano-Ubuntu-20-image

# not work :-)

# for Ubuntu CLI mode
# https://tek2tech.com/ubuntu-2004-desktop-environment/
#
# sudo systemctl set-default multi-user
# shutdown -r now
# export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libGLdispatch.so.0:$LD_PRELOAD
# rm ~/.cache/gstreamer-1.0/ -fr

sudo echo ;

#
cd ;
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui ;

cd stable-diffusion-webui/ ;

#
sudo apt install -y python3-pip ;

export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1
source ~/.bashrc

# install pytorch
sudo apt install -y python3-pip libjpeg-dev libopenblas-dev libopenmpi-dev libomp-dev
sudo -H pip3 install future
sudo pip3 install -U --user wheel mock pillow
sudo -H pip3 install testresources
sudo -H pip3 install setuptools==58.3.0
sudo -H pip3 install Cython
sudo -H pip3 install gdown
gdown https://drive.google.com/uc?id=1e9FDGt2zGS5C5Pms7wzHYRb0HuupngK1
sudo -H pip3 install torch-1.13.0a0+git7c98e70-cp38-cp38-linux_aarch64.whl
rm torch-1.13.0a0+git7c98e70-cp38-cp38-linux_aarch64.whl

# install torchvision
sudo apt install -y libjpeg-dev zlib1g-dev libpython3-dev
sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev
sudo pip3 install -U pillow
sudo -H pip3 install gdown
gdown https://drive.google.com/uc?id=19UbYsKHhKnyeJ12VPUwcSvoxJaX7jQZ2
sudo -H pip3 install torchvision-0.14.0a0+5ce4506-cp38-cp38-linux_aarch64.whl

# install library
pip install -U numpy==1.22.1
pip install -U scipy==1.9.1
pip install -U pillow==9.0.1

sudo -H pip install jetson-stats

# lunch stable diffusion web
# COMMANDLINE_ARGS=" --ckpt-dir models --use-cpu all --skip-torch-cuda-test --precision full --no-half " REQS_FILE="requirements.txt" python3 launch.py#
COMMANDLINE_ARGS="--listen --lowvram --ckpt-dir ./models --skip-version-check --skip-torch-cuda-test --precision full --no-half " REQS_FILE="requirements.txt" python3 launch.py
