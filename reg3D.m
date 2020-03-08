function [s,R,T,e,it]=reg3D(data1,data2,varargin)
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
%收敛误差

%输入参数处理，data1和data2
p=inputParser;
p.addRequired('data1',@(x)validateattributes(x,{'cell'},{'nonempty'}));
p.addRequired('data2',@(x)validateattributes(x,{'cell'},{'nonempty'}));
%迭代次数和收敛误差为可选输入
p.addOptional('iter',10,@(x)validateattributes(x,{'int8'},{'nonzero'}));
p.addOptional('error',0.001,@(x)validateattributes(x,{'double'},{'nonzero'}));
p.parse(data1,data2,varargin{:});

X = p.Results.data1{2};
Y = p.Results.data2{2};

initD = init(data2,data1);
R0 = initD{1};
T0 = initD{2};
s0 = initD{3};
I = initD{4};

tic;
%迭代求解部分
c0 = Solvecircle(s0,R0,T0,I,X,Y);
Rn = c0{1};
Tn = c0{2};
sn = c0{3};
etemp = c0{5};%当前误差
flag = 2;%迭代次数
while (etemp>p.Results.error)
    c = Solvecircle(sn,Rn,Tn,I,X,Y);
    Rn = c{1};
    Tn = c{2};
    sn = c{3};
    en = c{5};%变换后的误差
    % q = 1 - en/etemp;
    etemp = en;
    if flag>=p.Results.iter
        break;%大于迭代次数则退出
    end
    flag = flag + 1; 
end 
s = sn;
R = Rn;
T = Tn;
e = en;
it = flag - 1;
toc 
end

