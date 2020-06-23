%% Script for loading the MuSe dataset
clear
clc
% specify path to dataset location
muse_root = 'destination-folder\muse\';
% select to load sample-data/full-data
sample_str = 'sample-data';
% select sequence
seq = 'hb-s1-01';
% select synchronization raw-data/time-synchronized-data
sync_str = 'time-synchronized-data';
% choose to extract images if not already extracted
extract_images = 0;

% load data for the run and extract camera-images from zip files
data_new = loadMuSe(muse_root,seq,sample_str,sync_str,extract_images);

%% load camera intrinsics 
load(fullfile(muse_root,'calibration/intrinsic-calibration/matlab-format/camera_intrinsic_params.mat'))

%% load extrinsic transformation
load(fullfile(muse_root,'calibration/extrinsic-calibration/matlab-format/extrinsic_calibration_params.mat'))
% Display some of the data
% Extrinsics
fprintf('Extrinsics:\r')
fprintf('T: base_link to laser\r')
disp(extrinsic_calibration_params.laser)

fprintf('T: base_link to kinect\r')
disp(extrinsic_calibration_params.kinect_link)

fprintf('T: base_link to zed left camera\r')
disp(extrinsic_calibration_params.zed_left_link)

fprintf('T: base_link to omnidirectional left camera\r')
disp(extrinsic_calibration_params.omni_left_link)

fprintf('T: base_link to imu\r')
disp(extrinsic_calibration_params.imu_link)


%% display first n images
n = 10;

% kinect-depth
fprintf('%s\r','Displaying kinect depth images')
for i=1:n   %size(data_new.kinect_depth_image,1)
    img = imread(data_new.kinect_depth_image.image_loc(i,:));
    imshow(img)
    title('Displaying kinect depth images');pause(0.05)
end

% kinect-rgb
fprintf('%s\r','Displaying kinect rgb images')
for i=1:n   %size(data_new.kinect_rgb_image,1)
    img = imread(data_new.kinect_rgb_image.image_loc(i,:));
    imshow(img)
    title('Displaying kinect rgb images');pause(0.05)
end

% ocam
fprintf('%s\r','Displaying ocam images')
for i=1:n   %size(data_new.ocam_image,1)
    img = imread(data_new.ocam_image.image_loc(i,:));
    imshow(img)
    title('Displaying ocam images');pause(0.05)
end

% omni-left
fprintf('%s\r','Displaying omni left images')
for i=1:n   %size(data_new.omni_left_image,1)
    img = imread(data_new.omni_left_image.image_loc(i,:));
    imshow(img)
    title('Displaying omni left images');pause(0.05)
end

% omni-right
fprintf('%s\r','Displaying omni right images')
for i=1:n   %size(data_new.omni_right_image,1)
    img = imread(data_new.omni_right_image.image_loc(i,:));
    imshow(img)
    title('Displaying omni right images');pause(0.05)
end

% zed-left
fprintf('%s\r','Displaying zed left images')
for i=1:n   %size(data_new.zed_left_image,1)
    img = imread(data_new.zed_left_image.image_loc(i,:));
    imshow(img)
    title('Displaying zed left images');pause(0.05)
end

% zed-right
fprintf('%s\r','Displaying zed right images')
for i=1:n   %size(data_new.zed_right_image,1)
    img = imread(data_new.zed_right_image.image_loc(i,:));
    imshow(img)
    title('Displaying zed right images');pause(0.05)
end
close

%% Robot trajectory
% base_link ground-truth 
transBaseToVicon = minus_transform3D(transformTable2Vec(extrinsic_calibration_params.kobuki_vicon_link));
gt = [data_new.vicon.transform_translation_x data_new.vicon.transform_translation_y data_new.vicon.transform_translation_z quat2eul([data_new.vicon.transform_rotation_w data_new.vicon.transform_rotation_x data_new.vicon.transform_rotation_y data_new.vicon.transform_rotation_z],'XYZ')]';
gt_base_link = zeros(size(gt));
for i = 1:size(gt,2)
    gt_base_link(:,i) = plus_transform3D(gt(:,i),transBaseToVicon);
end
% odometry
odom_quat = [data_new.robot_odometry.pose_pose_orientation_w data_new.robot_odometry.pose_pose_orientation_x data_new.robot_odometry.pose_pose_orientation_y data_new.robot_odometry.pose_pose_orientation_z];
odom_eul = quat2eul(odom_quat,'XYZ');    
odom = [data_new.robot_odometry.pose_pose_position_x data_new.robot_odometry.pose_pose_position_y data_new.robot_odometry.pose_pose_position_z odom_eul]';
% transform odometry to world frame
odom_world = plus_transform3D(gt(:,1),plus_transform3D(transBaseToVicon,odom));
% plot
figure
plot(odom_world(1,:),odom_world(2,:));hold on
plot(gt_base_link(1,:),gt_base_link(2,:))
legend('robot odometry','robot ground truth')
title('Robot odometry vs ground truth')


%% kinect point cloud
% load first kinect depth image
load(data_new.kinect_depth_image.depth_mat_loc(1,:))
depth_image(depth_image>4500)= 0;
figure
imagesc(depth_image); axis off; % truesize;
title('Depth in color map');
colormap parula;
c = colorbar; c.Label.String = 'Distance in mm';

cloud = ptCloudFromDepthMat(depth_image,camera_intrinsic_params.kinect_depth_camera_info);
% display cloud
figure
title('Kinect depth point cloud')
pcshow(cloud);
camup([0 -1 0])
camorbit(180,0,'data',[0 1 0])
for i = 1:36
   camorbit(10,0,'data',[0 1 0])
   drawnow; pause(0.05)
end





