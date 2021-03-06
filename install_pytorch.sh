#!/usr/bin/bash

# wget https://raw.githubusercontent.com/mugimugi555/jetsonnano/main/install_pytorch.sh && bash install_pytorch.sh ;

#-----------------------------------------------------------------------------------------------------------------------
# NOTE : https://qengineering.eu/install-pytorch-on-jetson-nano.html
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
# install library
#-----------------------------------------------------------------------------------------------------------------------
sudo apt install -y python3-pip libjpeg-dev libopenblas-dev libopenmpi-dev libomp-dev ;
sudo -H pip3 install future ;
sudo pip3 install -U --user wheel mock pillow ;
sudo -H pip3 install testresources ;

#-----------------------------------------------------------------------------------------------------------------------
# above 58.3.0 you get version issues
#-----------------------------------------------------------------------------------------------------------------------
sudo -H pip3 install setuptools==58.3.0 ;
sudo -H pip3 install Cython ;

#-----------------------------------------------------------------------------------------------------------------------
# download the wheel
#-----------------------------------------------------------------------------------------------------------------------
sudo -H pip3 install gdown ;
gdown https://drive.google.com/uc?id=1TqC6_2cwqiYacjoLhLgrZoap6-sVL2sd ;

#-----------------------------------------------------------------------------------------------------------------------
# install PyTorch
#-----------------------------------------------------------------------------------------------------------------------
sudo -H pip3 install torch-1.10.0a0+git36449ea-cp36-cp36m-linux_aarch64.whl ;

#-----------------------------------------------------------------------------------------------------------------------
# finish
#-----------------------------------------------------------------------------------------------------------------------
python3 -c 'import torch as tr; print(tr.__version__)' ;
