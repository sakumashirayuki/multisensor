function [s,R,T,e,it]=reg3D(file1,file2)
%s 数据单位量纲缩放值
%R 旋转矩阵
%T 平移矩阵
%e 误差？
%it 迭代次数
%file1和file2为点云输入文件，点数可以不一样

data1 = ascread(file1);%40097points
data2 = ascread(file2);%40256points

X = data1{2};
Y = data2{2};

initD = init(data1,data2);
R0 = initD{1};
T0 = initD{2};
s0 = initD{3};
I = initD{4};
o = 0.001;

%进行delaunay三角剖分
Yo = delaunayn(Y');

tic;
%迭代求解部分
c0 = Solvecircle(s0,R0,T0,I,X,Y,Yo);%??????????????
Rn = c0{1};
Tn = c0{2};
sn = c0{3};
etemp = c0{5};%迭代次数
q=1;
flag = 2;
while (q>o)
    c = Solvecircle(sn,Rn,Tn,I,X,Y,Yo);
    Rn = c{1};
    Tn = c{2};
    sn = c{3};
    en = c{5};
    q = 1 - en/etemp;
    etemp = en;
    flag = flag + 1; 
end 
s = sn;
R = Rn;
T = Tn;
e = en;
it = flag - 1;
toc 
end

