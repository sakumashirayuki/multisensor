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

%移动前，并计算误差
figure(1);
scatter3(x1,y1,z1,'b','.');hold on;
scatter3(x2,y2,z2,'r','.');
xlabel('x(mm)');ylabel('y(mm)');zlabel('z(mm)');
axis([-5 5 -5 5]);
title('before moving');

HA_value = [x1';y1';z1'];
LA_value = [x2';y2';z2'];
HA_tri = createns(HA_value','NSMethod','kdtree');
k = knnsearch(HA_tri,LA_value');
% k = knnsearch(LA_value',HA_value');
find_HA = HA_value(:,k);

%计算误差
c=find_HA-LA_value;
e=mean(dot(c,c));
fprintf("error before moving");
e = sqrt(e)

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

figure(2);
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
method ='reg3D';
switch method
    case 'reg3D'
        %use reg_3D
        %直接得到最终的点云图Yn
        %matlab的毛病，这里要强制类型转换
        [s,e,it,Yn] = reg3D(HA_data,LA_data,int64(500));
    case 'icp_3dbasic'
        %use icp_3dbasic
        %LA变换为HA
        [~, R,T]=icp_3dbasic(HA_value', LA_value');
    otherwise
        fprintf('error');
end

%% data fusion
% 在LA(Yn)的范围内取HA(HA_value)的点
Minmum = min(Yn,[],2);
minx = Minmum(1);
miny = Minmum(2);
Maxmum = max(Yn,[],2);
maxx = Maxmum(1);
maxy = Maxmum(2);
[~,ind_X] = find(HA_value(1,:)>=minx & HA_value(1,:)<=maxx);
xScope = HA_value(:,ind_X);
[~,ind_Y] = find(xScope(2,:)>=miny & xScope(2,:)<=maxy);
HA_crop = xScope(:,ind_Y);

figure;
scatter3(HA_crop(1,:)',HA_crop(2,:)',HA_crop(3,:)','b','.');hold on;
scatter3(Yn(1,:)',Yn(2,:)',Yn(3,:)','r','.');
xlabel('x(mm)');ylabel('y(mm)');zlabel('z(mm)');
axis([minx*1.1 maxx*1.1 miny*1.1 maxy*1.1]);
title('fusion area');

%% surface reconstruction
% 创建ptCloud类
ptCloudHA = pointCloud(HA_crop');
ptCloudLA = pointCloud(Yn');
ptCloud = pcmerge(ptCloudLA,ptCloudHA,0.25);%第三个参数需要研究
figure;
pcshow(ptCloud);
point_out = ptCloud.Location;

% 以下用于curve fitting toolbox使用
% cloud_x = point_out(:,1);
% cloud_y = point_out(:,2);
% cloud_z = point_out(:,3);

% 以下语句用于使用curve fitting toolbox产生的sfit变量
% 绘制拟合曲面
% plot(surfacefitted)
% 取拟合曲面上一点，如(0,0)
% surfacefitted(0,0)