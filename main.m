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

%% move LA data
[col,row]=size(x2);
R = [-0.1 0 0;0 0.3 0;0 0 0.2];
T = [1 1 -0.5];
M = [R;T];
One = ones(col,1);
move = [x2 y2 z2 One]*M;
mx2 = move(:,1);
my2 = move(:,2);
mz2 = move(:,3);
figure(1);
scatter3(x1,y1,z1,'b','.');hold on;
scatter3(mx2,my2,mz2,'r','.');
xlabel('x(mm)');ylabel('y(mm)');zlabel('z(mm)');
axis([-5 5 -5 5 -2 2]);
title('multisensor data');
