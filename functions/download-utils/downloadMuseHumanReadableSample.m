%% Function for downloading human readable format sample data from MuSe Dataset repository
% usage:
% downloadMuseHumanReadableSample(destination_folder, robot_run, sync_type)
% input: 
% destination_folder; string destination folder location 
% robot_run; string one of ['hb-s1-01','hb-s1-02','hb-s2-01','hb-s2-02','hb-s3-01','all']
% sync_type; string one of ['raw','time_sync']
function [] = downloadMuseHumanReadableSample(destination_folder, robot_run, sync_type)

    curr_folder = pwd;
    server = 'http://103.246.106.250/data/sample-data/human-readable-format/';

    % check if destination is valid
    try
        cd(destination_folder)
        create_dir('muse/sample-data/human-readable-format')
        cd muse/sample-data/human-readable-format
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
            create_dir(fullfile(sync_str,robot_run)); cd(fullfile(sync_str,robot_run));
            temp_srv = strcat(server,sync_str,'/',robot_run,'/');
            download_subdata(temp_srv, all_runs(sub_dataset_index,:), num_chunks(sub_dataset_index))
            cd ../..
    end
    % return to main folder
    cd(curr_folder)
end



function [] = download_subdata(srv, data_str, num_chunks)
    for j = 0:num_chunks
        file_name = strcat(data_str,'_chunk',num2str(j,'%03.f'),'.zip');
        down_url = strcat(srv,file_name);
        fprintf(strcat('Downloading human-readable-format ',data_str(1:8), ' chunk ',num2str(j),'\r'))
        fprintf('...\r')
        websave(file_name,down_url);
        fprintf('%s\r',strcat('Downloading in ',pwd))
        fprintf(strcat('File Name = ',file_name,'\r'));
        fprintf(strcat('Download url = ',down_url,'\r'));
        fprintf('done\r')
    end
end


function [] = create_dir(folder_name)
    if ~exist(folder_name, 'dir')
        mkdir(folder_name); 
    end
end