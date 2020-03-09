function [params, R,t] = icp_3dbasic(data,model)
%input��model & data��Ϊnumber of points*n-dimension

% ICP_3DLM   A function
%               ...

% Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
% Date: 10 Apr 01

model_centre = mean(model);
%awf_translate_pts�������������ģ�ͼ�ȥƽ��ֵ
model = awf_translate_pts(model, -model_centre);

data_centre = mean(data);
data = awf_translate_pts(data, -data_centre);

%matlab�﷨��������������ֱ�ӽ����ṹ��
%��data�ڵ�������model�в���
%lmdata.kdObj = KDTreeSearcher(model);
%����Ľṹ��ֻ�����������ݵ�
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

%��ǰ�ļ��е�ȫ�ֱ���  run_icp3d_iter
global run_icp3d_iter
run_icp3d_iter = 0;

if nargout < 2
  disp('No return values, returning....');
  return
end

% Set up levmarq and tallyho(??)
%�������Ż��⺯����least square nonlinear��������С����
options = optimset('lsqnonlin');
options.TypicalX = [1 1 1 1 1 1 1];%��ʼֵx0???
options.TolFun = 0.0001;%�����ݲ�TolFun
options.TolX = 0.00001;%��ǰ�����ֹ�ݲ�TolX
options.DiffMinChange = .001;%���޲���е���С�仯��
options.LargeScale = 'on';%LargeScaleָ���д�Χ����
params = [0 0 0 1 0 0 0]; % quat, tx, ty, tz�����������ʼ�㣿

%@(X)��XΪ���Ż��ı��� 
%icp_3derror(X, lmdata)Ϊ��С��Ŀ��Ĳ�ֵ
%@(X) icp_3derror(X, lmdata)����Ϊ�����fun
%ȱʡ��[]Ϊupper bounds��lower bounds
params = lsqnonlin(@(X) icp_3derror(X, lmdata), params, [], [], options);
[R,t] = icp_deparam(params);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Error function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dists = icp_3derror(params, lm)
% �����lm���ݽṹ���˸���
% ��Ҫ��dataYת����dataX
% 1. Extract R, t from params
[R,t] = icp_deparam(params);

t = t(:)'; % colvec

% 2. Evaluate
% ԭ��������ת����data��ȥ�ӽ� model
% ��Ϊ��ת��modelȥ�ӽ�data,�任��ΪD
D = lm.dataY;
D = D * R' + t(ones(1, size(D, 1)), :);
%��D����kd������ģ��kdObj
kdObj = KDTreeSearcher(D);
%dist�м�¼��ÿ���Ӧ��(dataX��kdObj)֮��ľ���
[~, dists] = knnsearch(kdObj, lm.dataX);

stdDists = std(dists);%����dist�ı�׼��
dists = awf_m_estimator('ls', dists, stdDists);
%dists����Ϊ���е�Ծ����ƽ������СΪ����*1

global run_icp3d_iter
fprintf('Iter %3d ', run_icp3d_iter);
run_icp3d_iter = run_icp3d_iter + 1;

fprintf('%5.2f ', params);
%��ӡ��errorΪ���ֵ
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

%�Զ��庯��������Ԫ��(��Ҫ��һ��)ת��Ϊ3*3����ת����
R = quat2rot([p1 p2 p3 p4]) / sum([p1 p2 p3 p4].^2);
t = [p5 p6 p7]';

