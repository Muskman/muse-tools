# muse-tools

A basic set of tools to work with the MuSe dataset. The package provides functionality to easily download and parse the dataset into the MATLAB environment. The MuSe repository consists of multi-modal data collected from stereo, monocular, RGB, depth, and omnidirectional imagery along with lidar scan, WiFi RSSI, range-only, IMU, wheel encoder, and Vicon ground truth measurements using the MuSe robot platform. 

More information about the MuSe dataset repository is available at:  
https://sites.google.com/view/muse-dataset-repository


## Usage

To download the MuSe dataset run the muSeDownload.m file after selecting the desired download location, dataset format, robot sequence and desired synchronization type in the corresponding parameters.

To parse the combined data from a robot sequnce in the MATLAB workspace and optionally to unzip the downloaded images available in the MATLAB data format run the demoMuSe.m script. The script also illustrates on how the access data from various sensors in the MATLAB environment. 
