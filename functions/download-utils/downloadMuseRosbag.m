%% Function for downloading rosbag data from MuSe Dataset repository
% usage:
% downloadMuseRosbag(destination_folder, robot_run, chunk)
% input: 
% destination_folder; string destination folder location 
% robot_run; string one of ['hb-s1-01','hb-s1-02','hb-s2-01','hb-s2-02','hb-s3-01','all']
% chunk; string one of ['chunks','full']
function [] = downloadMuseRosbag(destination_folder, robot_run, chunk)

    curr_folder = pwd;
    server = 'http://103.246.106.250/data/full-data/rosbag-format/';

    % check if destination is valid
    try
        cd(destination_folder)
        create_dir('muse/full-data/rosbag-format')
        cd muse/full-data/rosbag-format
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
    if strcmp(chunk,'chunks')
        chunk_str = 'chunks';
        num_chunks = [13;10;22;17;14];
    elseif strcmp(chunk,'full-bags')
        chunk_str = 'full-bags';
        num_chunks = [1;1;1;1;1];
    else
        fprintf('Invalid option selected, use either chunks/full in third argument\r')
        return
    end

    all_runs = ['hb-s1-01';'hb-s1-02';'hb-s2-01';'hb-s2-02';'hb-s3-01'];
    name_keys = [
        'hb-s1-01-2018-12-05-00-51-09';
        'hb-s1-02-2018-12-05-21-28-42';
        'hb-s2-01-2018-12-05-01-02-33';
        'hb-s2-02-2018-12-05-21-39-34';
        'hb-s3-01-2018-12-05-22-08-55'];

    % download selected datasets
    switch download_all
        case 1
            for i = 1:size(all_runs,1)
                robot_run = all_runs(i,:);
                create_dir(strcat(chunk_str,'/',robot_run)); cd(strcat(chunk_str,'/',robot_run));
                temp_srv = strcat(server,chunk_str,'/',robot_run,'/');
                download_subdata(temp_srv, name_keys(i,:), num_chunks(i))
                cd ../..
            end
        case 0
            robot_run = all_runs(sub_dataset_index,:);
create_dir(strcat(chunk_str,'/',robot_run)); cd(strcat(chunk_str,'/',robot_run));
            temp_srv = strcat(server,chunk_str,'/',robot_run,'/');
            download_subdata(temp_srv, name_keys(sub_dataset_index,:), num_chunks(sub_dataset_index))
            cd ../..
    end
    % return to main folder
    cd(curr_folder)
end

function [] = download_subdata(srv, data_str, num_chunks)
    if num_chunks>1
        for j = 0:num_chunks
            file_name = strcat(data_str,'_chunk',num2str(j,'%03.f'),'.bag');
            down_url = strcat(srv,file_name);
            fprintf(['Downloading ', data_str(1:8), ' chunk ',num2str(j),'\r'])
            fprintf('...\r')
            websave(file_name,down_url);
%             fprintf('%s\r',strcat('Downloading in ',pwd))
%             fprintf(strcat('File Name = ',file_name,'\r'));
%             fprintf(strcat('Download url = ',down_url,'\r'));
            fprintf('done\r')
        end
    else
        file_name = strcat(data_str,'.bag');
        down_url = strcat(srv,file_name);
        fprintf(['Downloading rosbag-format ',data_str(1:8), ' full bagfile \r'])
        fprintf('...\r')
        websave(file_name,down_url);
%         fprintf('%s\r',['Downloading in ',' ',pwd])
%         fprintf('%s\r',['File Name = ',file_name]);
%         fprintf('%s\r',['Download url = ',down_url]);
        fprintf('done\r')
    end
end

function [] = create_dir(folder_name)
    if ~exist(folder_name, 'dir')
        mkdir(folder_name); 
    end
end

