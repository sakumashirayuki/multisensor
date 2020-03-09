% 用于仿真
clear;
close all;
%% set up coordinates
%HA dataset
Width1 = 5;
internal1 = 0.4;
x1 = (-1*Width1):internal1:Width1;
y1 = (-1*Width1):internal1:Width1;
[x1,y1] = meshgrid(x1,y1);

%LA dataset
Width2 = 3;
internal2 = 0.15;
x2 = (-1*Width2):internal2:Width2;
y2 = (-1*Width2):internal2:Width2;
[x2,y2] = meshgrid(x2,y2);

%% generate free form surface
% z value:z = sin(0.8x) + cos(0.5y)
z1 = sin(0.8*x1)+cos(0.5*y1);
z2 = sin(0.8*x2)+cos(0.5*y2);
x1 = x1(:);
y1 = y1(:);
z1 = z1(:);
x2 = x2(:);
y2 = y2(:);
z2 = z2(:);

%% add gaussian noise,with HA having 5um, LA having 15um
[colH,rowH]=size(x1);
HA_noise = normrnd(0,0.005,size(x1));
z1 = z1 + HA_noise;
LA_noise = normrnd(0,0.015,size(x2));
z2 = z2 + LA_noise;

%% move LA data
[colL,rowL]=size(x2);
alpha = -0.1;
belta = 0.3;
gamma = 0.2;
%欧拉角旋转
R = [1 0 0;0 cos(alpha) -1*sin(alpha);0 sin(alpha) cos(alpha)]...
    *[cos(belta) 0 sin(belta);0 1 0;-1*sin(belta) 0 cos(belta)]...
    *[cos(gamma) -1*sin(gamma) 0;sin(gamma) cos(gamma) 0;0 0 1];
T = [1 1 -0.5];
M = [R;T];
One = ones(colL,1);
move = [x2 y2 z2 One]*M;
mx2 = move(:,1);
my2 = move(:,2);
mz2 = move(:,3);

figure(1);
scatter3(x1,y1,z1,'b','.');hold on;
scatter3(mx2,my2,mz2,'r','.');
xlabel('x(mm)');ylabel('y(mm)');zlabel('z(mm)');
axis([-5 5 -5 5]);
title('multisensor data');

%% create cell variation
% the size of HA_value and LA_value is n-dimension * number of points
HA_value = [x1';y1';z1'];
LA_value = [mx2';my2';mz2'];
HA_data = ({colH;HA_value});
LA_data = ({colL;LA_value});

%%  calculate R and t
method = 'icp_3dbasic';
switch method
    case 'reg3D'
        %use reg_3D
        %得到的R，T可以直接用于LA变换到HA
        %matlab的毛病，这里要强制类型转换
        [s,R,T,e,it] = reg3D(HA_data,LA_data,int8(100))
    case 'icp_3dbasic'
        %use icp_3dbasic
        %LA变换为HA
        [~, R,T]=icp_3dbasic(HA_value', LA_value');
    otherwise
        print('error');
end

%% using solved R and T to register
register_LA = pointRegister(LA_value,R,T,method);

figure(2);
scatter3(x1,y1,z1,'b','.');hold on;
scatter3(register_LA(1,:)',register_LA(2,:)',register_LA(3,:)','.');
xlabel('x(mm)');ylabel('y(mm)');zlabel('z(mm)');
axis([-5 5 -5 5]);
title('multisensor data after registering');