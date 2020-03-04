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
%[colH,rowH]=size(x1);
HA_noise = normrnd(0,0.005,size(x1));
z1 = z1 + HA_noise;
LA_noise = normrnd(0,0.015,size(x2));
z2 = z2 + LA_noise;

%% move LA data
[colL,rowL]=size(x2);
alpha = -0.1;
belta = 0.3;
gamma = 0.2;
%ŷ������ת
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


