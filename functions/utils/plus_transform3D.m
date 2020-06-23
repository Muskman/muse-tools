function [x] = plus_transform3D(a,b)
% transforming 3dof pose a(+)b
theta = flip(a(4:6)');
R = eul2rotm(theta);
x = [repmat(a(1:3),1,size(b,2)) + R*b(1:3,:); repmat(a(4:6),1,size(b,2))+b(4:6,:)];
end
