%% Function: loadMuSe
% loads MuSe dataset into matlab workspace for easy use
% optionally extracts images and assigns their path to the corresponding
% variables
% Usage: data = loadMuSe(muse_root,seq,sample_str,sync_str,extract_images)
% Input:
%   muse_root; string, path to downloaded muse dataset
%   seq; string, argument for choosing robot sequence
%   sample_str; string, for loading full-data or sample-data
%   sync_str; string, for loading raw or time synchronized data
%   extract_images; boolean, option to extract images
% Output: 
%   data; struct, corresponding muse dataset structure array
function data = loadMuSe(muse_root,seq,sample_str,sync_str,extract_images)
    % check sample_str argument
    if strcmp(sample_str,'sample-data')
        all_chunks = [0;0;0;0;0];
    elseif strcmp(sample_str,'full-data')
        all_chunks = [13;10;22;17;14];
    else
        fprintf('Invalid input selected for third argument choose one of sample-data or full-data\r')
        data = [];
        return
    end

    mat_loc = fullfile(muse_root,sample_str,'matlab-format');
    
    % check second input
    val_input = strcmp({'hb-s1-01' 'hb-s1-02' 'hb-s2-01' 'hb-s2-02' 'hb-s3-01'},seq);
    if ~any(val_input)
        fprintf('Invalid option selected for second argument robot_run. Choose one of the following:\r')
        fprintf('hb-s1-01 or hb-s1-02 or hb-s2-01 or hb-s2-02 or hb-s3-01\r')
        data = [];
        return
    else
        num_chunks = all_chunks(val_input);
    end
    
    % check sync_type input argument
    if strcmp(sync_str,'raw-data')
        sync_loc = fullfile(mat_loc,'raw-data',seq);
    elseif strcmp(sync_str,'time-synchronized-data')
        sync_loc = fullfile(mat_loc,'time-synchronized-data',seq);
    else
        fprintf('Invalid input selected for fourth argument choose one of raw-data/time-synchronized-data\r')
        data = [];
        return
    end

    % load first chunk
    chunk_folder = strcat(seq,'_chunk',num2str(0,'%03.f'));
    ws_file = fullfile(sync_loc,chunk_folder,'data.mat');
    load(ws_file);
    
    % extract camera-data
    zip_file = fullfile(sync_loc,chunk_folder,'camera-data.zip');
    if extract_images == 1
        unzip(zip_file,zip_file(1:end-4));
        delete(zip_file)
    end
    
    % add extracted image path to data field
    data_var = ['data_chunk',num2str(0,'%03.f')];
    eval(['field_names = fieldnames(',data_var,');']);
    for j = 1:numel(field_names)
        eval(['var_modality =', data_var,'.',field_names{j},'.modality{1};'])
        if strcmp(var_modality,'image')
            img_folder_name = strrep(field_names{j}(1:end-6),'_','-');
            image_loc = fullfile(zip_file(1:end-4),img_folder_name,'images/');
            cmd_str1 = [data_var,'.',field_names{j},'.image_loc = strcat(repmat(image_loc,size(',data_var,'.',field_names{j},',1),1),num2str(',data_var,'.',field_names{j},'.timestamp),''.png'');'];
            eval(cmd_str1);
        end
    end

    kinect_depthmat_loc = strcat(zip_file(1:end-4),'/kinect-depth/mat-arrays/');
    % data_var.kinect_depth_image.depth_mat_loc = strcat(repmat(kinect_depthmat_loc,size(data_var.kinect_depth_image,1),1),num2str(data_var.kinect_depth_image.timestamp),'.png');
    cmd_str2 = [data_var,'.kinect_depth_image.depth_mat_loc = strcat(repmat(kinect_depthmat_loc,size(',data_var,'.kinect_depth_image,1),1),num2str(',data_var,'.kinect_depth_image.timestamp),''.mat'');'];
    eval(cmd_str2)
    
    % assign and initialize data variable for whole run
    % data = data_chunk000;
    eval(strcat('data = data_chunk',num2str(0,'%03.f'),';'));
    field_names = fieldnames(data);
    
    % extract camera data and add location to data
    

    for i = 1:num_chunks
        % load chunk matfile
        chunk_folder = strcat(seq,'_chunk',num2str(i,'%03.f'));
        ws_file = fullfile(sync_loc,chunk_folder,'data.mat');
        load(ws_file);
        
        % extract camera-data
        zip_file = fullfile(sync_loc,chunk_folder,'camera-data.zip');
        if extract_images==1    
            unzip(zip_file,zip_file(1:end-4));
            delete(zip_file)
        end
        
        % add extracted image path to data field
        data_var = ['data_chunk',num2str(i,'%03.f')];
        eval(['field_names = fieldnames(',data_var,');']);
        for j = 1:numel(field_names)
            eval(['var_modality =', data_var,'.',field_names{j},'.modality{1};'])
            if strcmp(var_modality,'image')
                img_folder_name = strrep(field_names{j}(1:end-6),'_','-');
                image_loc = fullfile(zip_file(1:end-4),img_folder_name,'images/');
                cmd_str1 = [data_var,'.',field_names{j},'.image_loc = strcat(repmat(image_loc,size(',data_var,'.',field_names{j},',1),1),num2str(',data_var,'.',field_names{j},'.timestamp),''.png'');'];
                eval(cmd_str1);
            end
        end

        kinect_depthmat_loc = strcat(zip_file(1:end-4),'/kinect-depth/mat-arrays/');
        cmd_str2 = [data_var,'.kinect_depth_image.depth_mat_loc = strcat(repmat(kinect_depthmat_loc,size(',data_var,'.kinect_depth_image,1),1),num2str(',data_var,'.kinect_depth_image.timestamp),''.mat'');'];
        eval(cmd_str2)
        
        % add to data
        for j = 1:numel(field_names)
            eval(['data.',field_names{j},' = [data.',field_names{j},'; data_chunk',num2str(i,'%03.f'),'.',field_names{j},'];'])
        end        
    end
        
end




