function [s,e,it,Yn]=reg3D(data1,data2,varargin)
%变换data1去接近data2
%改为变换data2去接近data1
%data1的点少于data2
%s 数据单位量纲缩放值
%R 旋转矩阵
%T 平移矩阵
%e 误差
%it 迭代次数
%新输入：2*1d cell,cell{1}为点个数，cell{2}储存点的坐标，大小为n维*点数
%迭代次数：默认10次
%收敛误差:默认0.001
%显示最终位置的点云

%输入参数处理，data1和data2
p=inputParser;
p.addRequired('data1',@(x)validateattributes(x,{'cell'},{'nonempty'}));
p.addRequired('data2',@(x)validateattributes(x,{'cell'},{'nonempty'}));
%迭代次数和收敛误差为可选输入
p.addOptional('iter',10,@(x)validateattributes(x,{'int64'},{'nonzero'}));
p.addOptional('error',0.001,@(x)validateattributes(x,{'double'},{'nonzero'}));
p.parse(data1,data2,varargin{:});

%存储误差
e_record = zeros(1,p.Results.iter);
pointx = p.Results.data1{1};
pointy = p.Results.data2{1};
X = p.Results.data1{2};
Y = p.Results.data2{2};

%产生初始值
initD = init(data2,data1);
R0 = initD{1};
T0 = initD{2};
s0 = initD{3};
I = initD{4};
Y0 = initD{5};%取出PCA初配准后的Y

tic;
%迭代求解部分
c0 = Solvecircle(I,X,Y0);
Rn = c0{1};
Tn = c0{2};
sn = c0{3};
etemp = c0{4};%当前误差
Yn=c0{5};%当前的Y
e_record(1)=etemp;
flag = 2;%迭代次数
%设定温度：
tBegin = 100;%需要设定一个很大的温度,温度越大越容易转移
tEnd = 1e-30;%结束温度很小
temperature = tBegin;
rate = 0.95;%降温速率
while (etemp>p.Results.error)
    Y_temp = Yn;%记录上一次变换结束的点云Yn
    %按照SVD产生的常规解
    c = Solvecircle(I,X,Yn);
    Rn = c{1};
    Tn = c{2};
    sn = c{3};
    en = c{4};%变换后的误差
    Yn = c{5};%更新点云
    etemp = en;%更新当前误差
    if flag>=p.Results.iter
        e_record(flag)=en;%保存误差
        fprintf("completed all iterations/n");
        break;%大于迭代次数则退出
    end
    %生成扰动解
    [R_disturb,T_disturb,Y_disturb,e_disturb]...
    =createDisturb(Rn,Tn,X,Y_temp,pointy);
    %metropolis法则判断是否接受新解
    Temp = ({Rn;Tn;Yn;en});
    Disturb = ({R_disturb;T_disturb;Y_disturb;e_disturb});
    %得到经过判断的解
    [Rn,Tn,en,Yn,temperature]=Metropolis(Temp,Disturb,temperature,rate);
    %判断是否中止迭代
    if temperature < tEnd%如果小于中止温度
        e_record(flag)=en;%保存误差
        fprintf("the temperature is lower than Tend/n");
        break;
    end
    e_record(flag)=en;%保存误差
    flag = flag+1;
end
%绘制误差变化图像
plot_error(e_record);
fprintf("the last iter:");
temperature
it = flag - 1
s = sn;
R = Rn;
T = Tn;
e = en
toc 
%显示最终变换位置的点云Yn图像
figure;
scatter3(X(1,:)',X(2,:)',X(3,:)','b','.');hold on;
scatter3(Yn(1,:)',Yn(2,:)',Yn(3,:)','r','.');
xlabel('x(mm)');ylabel('y(mm)');zlabel('z(mm)');
axis([-5 5 -5 5]);
title('multisensor data after registering');
end

