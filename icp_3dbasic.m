function [params, R,t] = icp_3dbasic(data,model)
%input：model & data均为number of points*n-dimension

% ICP_3DLM   A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Apr 01

model_centre = mean(model);
%awf_translate_pts函数将输入点云模型减去平均值
model = awf_translate_pts(model, -model_centre);

data_centre = mean(data);
data = awf_translate_pts(data, -data_centre);

%matlab语法：不用声明可以直接建立结构体
%把data内的数据在model中查找
%lmdata.kdObj = KDTreeSearcher(model);
%这里的结构体只储存两组数据点
lmdata.dataX = data;
lmdata.dataY = model;

figure(1)
hold off
set(scatter(model, 'b.'), 'markersize', .001);
set(gcf, 'renderer', 'opengl')
hold on
axis off
lmdata.h = scatter(data, 'r+');
set(lmdata.h, 'markersize', 2);
axis equal
axis vis3d

%当前文件夹的全局变量  run_icp3d_iter
global run_icp3d_iter
run_icp3d_iter = 0;

if nargout < 2
  disp('No return values, returning....');
  return
end

% Set up levmarq and tallyho(??)
%非线性优化库函数：least square nonlinear非线性最小二乘
options = optimset('lsqnonlin');
options.TypicalX = [1 1 1 1 1 1 1];%初始值x0???
options.TolFun = 0.0001;%函数容差TolFun
options.TolX = 0.00001;%当前点的中止容差TolX
options.DiffMinChange = .001;%有限差分中的最小变化量
options.LargeScale = 'on';%LargeScale指进行大范围搜索
params = [0 0 0 1 0 0 0]; % quat, tx, ty, tz待求参量的起始点？

%@(X)中X为待优化的变量 
%icp_3derror(X, lmdata)为最小化目标的差值
%@(X) icp_3derror(X, lmdata)整个为输入的fun
%缺省的[]为upper bounds和lower bounds
params = lsqnonlin(@(X) icp_3derror(X, lmdata), params, [], [], options);
[R,t] = icp_deparam(params);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Error function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dists = icp_3derror(params, lm)
% 这里的lm数据结构做了更改
% 需要把dataY转换到dataX
% 1. Extract R, t from params
[R,t] = icp_deparam(params);

t = t(:)'; % colvec

% 2. Evaluate
% 原程序：这里转换的data，去接近 model
% 改为：转换model去接近data,变换后为D
D = lm.dataY;
D = D * R' + t(ones(1, size(D, 1)), :);
%用D生成kd查找树模型kdObj
kdObj = KDTreeSearcher(D);
%dist中记录了每组对应点(dataX和kdObj)之间的距离
[~, dists] = knnsearch(kdObj, lm.dataX);

stdDists = std(dists);%计算dist的标准差
dists = awf_m_estimator('ls', dists, stdDists);
%dists更新为所有点对距离的平方，大小为点数*1

global run_icp3d_iter
fprintf('Iter %3d ', run_icp3d_iter);
run_icp3d_iter = run_icp3d_iter + 1;

fprintf('%5.2f ', params);
%打印的error为最大值
fprintf('err %.2f\n', norm(dists));

set(lm.h, ...
  'xdata', D(:, 1), ...
  'ydata', D(:, 2), ...
  'zdata', D(:, 3));
drawnow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [R,t] = icp_deparam(p)

p1 = p(1);
p2 = p(2);
p3 = p(3);
p4 = p(4);
p5 = p(5);
p6 = p(6);
p7 = p(7);

%自定义函数，将四元数(需要归一化)转换为3*3的旋转矩阵
R = quat2rot([p1 p2 p3 p4]) / sum([p1 p2 p3 p4].^2);
t = [p5 p6 p7]';

