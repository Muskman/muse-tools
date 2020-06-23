%% Function for downloading calibration data for MuSe Dataset repository
% usage:
% downloadMuseCalibFiles(destination_folder)
% input: 
% destination_folder; string destination folder location 
function [] = downloadMuseCalibFiles(destination_folder)

    curr_folder = pwd;
    server = 'http://103.246.106.250/data/';

    % check if destination is valid
    try
        cd(destination_folder)
        create_dir('muse/calibration/extrinsic-calibration/human-readable-format/')
        create_dir('muse/calibration/extrinsic-calibration/matlab-format/')
        create_dir('muse/calibration/intrinsic-calibration/human-readable-format/')
        create_dir('muse/calibration/intrinsic-calibration/matlab-format/')
    catch
        fprintf('Destination directory does not exist\r')
        return
    end
    
    % download selected datasets
    fprintf('Downloading calibration files..\r')
    cd('muse/calibration/extrinsic-calibration/human-readable-format/');
    websave('extrinsics.yaml',strcat(server,'/calibration/extrinsic-calibration/human-readable-format/extrinsics.yaml'));
    cd ../matlab-format
    websave('extrinsic_calibration_params.mat',strcat(server,'/calibration/extrinsic-calibration/matlab-format/extrinsic_calibration_params.mat'));
    cd ../../intrinsic-calibration/human-readable-format
    websave('camera-intrinsics.zip',strcat(server,'/calibration/intrinsic-calibration/human-readable-format/camera-intrinsics.zip'));
    cd ../matlab-format
    websave('camera_intrinsic_params.mat',strcat(server,'/calibration/intrinsic-calibration/matlab-format/camera_intrinsic_params.mat'));
    fprintf('done\r')
    
    % return to main folder
    cd(curr_folder)
end

function [] = create_dir(folder_name)
    if ~exist(folder_name, 'dir')
        mkdir(folder_name); 
    end
end