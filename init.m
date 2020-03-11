function result = init(data1,data2)
%X和Y的尺寸为维度*点数
%result包括R;T;s;I，这里再包括经过初始变换后的结果
%register_X: n-dimension*number of points
pointx = data1{1};
X = data1{2};
pointy = data2{1};
Y = data2{2};

%用PCA粗配准的方法确定初始值
%xc为数据集1平均值，yc为数据集2平均值
xc = mean(X,2);
yc = mean(Y,2);

%x1为数据集1去掉平均值后的结果，y1同理
x1 = X - repmat(xc,[1 pointx]);
Mx =x1 * x1';

y1 = Y - repmat(yc,[1 pointy]);
My = y1 * y1';

%返回特征值D(一个对角矩阵)，特征向量V(每一列为向量)
[Vx,Dx] = eig(Mx,'nobalance');
[Vy,Dy] = eig(My,'nobalance');

%s是为了统一两个数据集量纲
sq = sum(sqrt(Dy/Dx));
s = sum(sq)/3;
%I
I = [min(sq),max(sq)];

%p1 p2为数据x的坐标轴(3个值)
%q1 q2 q3为数据y的坐标轴
p1 = Vx(:,1);
p2 = Vx(:,2);
q1 = Vy(:,1);
q2 = Vy(:,2);
q3 = Vy(:,3);
% f = 0.8;  %f是什么？
f=0.1;
%调整向量方向(为什么以f为标准，为何反向)
if dot(p1,q1) < f
    p1 = -p1;
end
if dot(p2,q2)<f
   p2 = -p2;
end
%数据集的第三个坐标方向由前两个坐标向量叉乘得来
p3 = cross(p1,p2);
%坐标轴之间的转换关系为旋转矩阵
R = [q1,q2,q3]*inv([p1,p2,p3]);

%平移矩阵T = (yc - xc);
% xc2 = mean(s*R*X,2);
% T = (yc - xc2);

%去掉了缩放因子
xc2 = mean(R*X,2);
T = (yc - xc2);

%显示初始位姿：
[~,rowL]=size(X);%rowL为点数
Onerow = ones(1,rowL);
%register_X = s*R*X+repmat(T,[1 pointx]);
register_X = R*X+repmat(T,[1 pointx]);
figure;
scatter3(Y(1,:)',Y(2,:)',Y(3,:)','b','.');hold on;
scatter3(register_X(1,:)',register_X(2,:)',register_X(3,:)','.');
xlabel('x(mm)');ylabel('y(mm)');zlabel('z(mm)');
axis([-5 5 -5 5]);
title('the pca initial position');

result = cell({R;T;s;I;register_X});