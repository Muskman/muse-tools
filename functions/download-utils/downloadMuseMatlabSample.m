%% Function for downloading matlab format sample data from MuSe Dataset repository
% usage:
% downloadMuseMatlabSample(destination_folder, robot_run, sync_type)
% input: 
% destination_folder; string destination folder location 
% robot_run; string one of ['hb-s1-01','hb-s1-02','hb-s2-01','hb-s2-02','hb-s3-01','all']
% sync_type; string one of ['raw','time_sync']
function [] = downloadMuseMatlabSample(destination_folder, robot_run, sync_type)

    curr_folder = pwd;
    server = 'http://103.246.106.250/data/sample-data/matlab-format/';

    % check if destination is valid
    try
        cd(destination_folder)
        create_dir('muse/sample-data/matlab-format')
        cd muse/sample-data/matlab-format
    catch
        fprintf('Destination directory does not exist\r')
        return
    end

    % check second input
    val_input = strcmp({'hb-s1-01' 'hb-s1-02' 'hb-s2-01' 'hb-s2-02' 'hb-s3-01' 'all'},robot_run);
    if ~any(val_input)
        fprintf('Invalid option selected for second argument robot_run. Choose one of the following:\r')
        fprintf('hb-s1-01 or hb-s1-02 or hb-s2-01 or hb-s2-02 or hb-s3-01 or all\r')
        return
    else
        if val_input(6)
            download_all = 1;
        else 
            download_all = 0;
            sub_dataset_index = find(val_input);
        end
    end

    % check other input
    if (strcmp(sync_type,'raw-data') || strcmp(sync_type,'time-synchronized-data'))
        sync_str = sync_type;
    else
        fprintf('Invalid option selected, use either raw-data or time-synchronized-data in third argument\r')
        return
    end

    all_runs = ['hb-s1-01';'hb-s1-02';'hb-s2-01';'hb-s2-02';'hb-s3-01'];
    num_chunks = [0;0;0;0;0];
    
    % download selected datasets
    switch download_all
        case 1
            for i = 1:size(all_runs,1)
                robot_run = all_runs(i,:);
                create_dir(strcat(sync_str,'/',robot_run)); cd(strcat(sync_str,'/',robot_run));
                temp_srv = strcat(server,sync_str,'/',robot_run,'/');
                download_subdata(temp_srv, all_runs(i,:), num_chunks(i))
                cd ../..
            end
        case 0
            robot_run = all_runs(sub_dataset_index,:);
            create_dir(strcat(sync_str,'/',robot_run)); cd(strcat(sync_str,'/',robot_run));
            temp_srv = strcat(server,sync_str,'/',robot_run,'/');
            download_subdata(temp_srv, all_runs(sub_dataset_index,:), num_chunks(sub_dataset_index))
            cd ../..
    end
    % return to main folder
    cd(curr_folder)
end

function [] = download_subdata(srv, data_str, num_chunks)
    for j = 0:num_chunks
        folder_name = strcat(data_str,'_chunk',num2str(j,'%03.f'),'/');
        cam_file_name = 'camera-data.zip';
        down_mat_url = strcat(srv,folder_name,'/data.mat');
        down_cam_url = strcat(srv,folder_name,cam_file_name);
        create_dir(folder_name); cd(folder_name);
        fprintf(['Downloading matlab-format ',data_str(1:8), ' chunk ',num2str(j,'%03.f'),'\r']);
        fprintf('...\r')
        websave('data.mat',down_mat_url);
        websave(cam_file_name,down_cam_url);
%         fprintf('%s\r',strcat('Downloading in ',pwd,'\r'))
%         fprintf(strcat('Cam file Name = ',cam_file_name,'\r'));
%         fprintf(strcat('Download mat url = ',down_mat_url,'\r'));
%         fprintf(strcat('Download cam url = ',down_cam_url,'\r'));
        fprintf('done\r')
        cd ..
    end
end

function [] = create_dir(folder_name)
    if ~exist(folder_name, 'dir')
        mkdir(folder_name); 
    end
end