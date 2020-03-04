function [s,R,T,e,it]=reg3D(file1,file2)
%s ���ݵ�λ��������ֵ
%R ��ת����
%T ƽ�ƾ���
%e ��
%it ��������
%file1��file2Ϊ���������ļ����������Բ�һ��

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

%����delaunay�����ʷ�
Yo = delaunayn(Y');

tic;
%������ⲿ��
c0 = Solvecircle(s0,R0,T0,I,X,Y,Yo);%??????????????
Rn = c0{1};
Tn = c0{2};
sn = c0{3};
etemp = c0{5};%��������
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

