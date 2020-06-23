%% Script for downloading complete MuSe dataset

% choose parameters
destination_folder = 'specify-valid-location-from-device';
robot_run = 'hb-s1-01'; % robot_run = 'all';
chunk = 'chunks'; % chunk = 'full-bags'; % argument for rosbag data
sync_type = 'time-synchronized-data'; % sync_type = 'raw-data';

%% download calibration files
downloadMuseCalibFiles(destination_folder)

%% download rosbag chunks sample or full-data
% downloadMuseRosbagSample(destination_folder, robot_run)
% downloadMuseRosbag(destination_folder, robot_run, chunk)

%% download human radable format sample or full-data
% downloadMuseHumanReadableSample(destination_folder, robot_run, sync_type)
% downloadMuseHumanReadable(destination_folder, robot_run, sync_type)

%% download matlab format
downloadMuseMatlabSample(destination_folder, robot_run, sync_type)
% downloadMuseMatlab(destination_folder, robot_run, sync_type)






