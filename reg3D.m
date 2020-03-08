function [s,R,T,e,it]=reg3D(data1,data2,varargin)
%�任data1ȥ�ӽ�data2
%��Ϊ�任data2ȥ�ӽ�data1
%data1�ĵ�����data2
%s ���ݵ�λ��������ֵ
%R ��ת����
%T ƽ�ƾ���
%e ���
%it ��������
%�����룺2*1d cell,cell{1}Ϊ�������cell{2}���������꣬��СΪnά*����
%����������Ĭ��10��
%�������

%�����������data1��data2
p=inputParser;
p.addRequired('data1',@(x)validateattributes(x,{'cell'},{'nonempty'}));
p.addRequired('data2',@(x)validateattributes(x,{'cell'},{'nonempty'}));
%�����������������Ϊ��ѡ����
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
%������ⲿ��
c0 = Solvecircle(s0,R0,T0,I,X,Y);
Rn = c0{1};
Tn = c0{2};
sn = c0{3};
etemp = c0{5};%��ǰ���
flag = 2;%��������
while (etemp>p.Results.error)
    c = Solvecircle(sn,Rn,Tn,I,X,Y);
    Rn = c{1};
    Tn = c{2};
    sn = c{3};
    en = c{5};%�任������
    % q = 1 - en/etemp;
    etemp = en;
    if flag>=p.Results.iter
        break;%���ڵ����������˳�
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

