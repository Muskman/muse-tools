function [x] = minus_transform3D(a)
% transforming 3 dof pose (-)a
    theta = flip(a(4:6)');
    R = eul2rotm(theta); 
    x = [-R'*a(1:3); flip(rotm2eul(R')')];
end