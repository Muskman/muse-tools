%% Function to generate point cloud from kinect depth array
% input:
%       depth_mat; depth matrix from kinect depth camera
%       calib_params; depth camera calibration table
function ptCloud = ptCloudFromDepthMat(depth_mat,calib_params)
    % depth is depth image in double format
    depth_mat = double(depth_mat);

    % calibration matrix
    K = reshape(calib_params.K,3,3);

    Sd = size(depth_mat);
    [X,Y] = meshgrid(1:Sd(2),1:Sd(1));
    X = X - K(3,1) + 0.5;
    Y = Y - K(3,2) + 0.5;
    XDf = depth_mat/K(1,1);
    YDf = depth_mat/K(2,2);
    X = X .* XDf;
    Y = Y .* YDf;
    XY = cat(3,X,Y);
    cloud = cat(3,XY,depth_mat);
    cloud = reshape(cloud,[],3) / 1000.0;

    % use matlab point cloud library
    ptCloud = pointCloud(cloud);
end