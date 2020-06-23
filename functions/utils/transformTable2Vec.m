%% function to represent table as a 6d transform
% input:
% T: nx6 table containg fields x, y, z, roll, pitch and yaw
% output:
% t: 6xn tranform vector
function t = transformTable2Vec(T)
    t = [T.x';T.y';T.z';deg2rad(T.pitch)';deg2rad(T.roll)';deg2rad(T.yaw)'];
end