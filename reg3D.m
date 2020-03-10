function [s,e,it,Yn]=reg3D(data1,data2,varargin)
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
%�������:Ĭ��0.001
%��ʾ����λ�õĵ���

%�����������data1��data2
p=inputParser;
p.addRequired('data1',@(x)validateattributes(x,{'cell'},{'nonempty'}));
p.addRequired('data2',@(x)validateattributes(x,{'cell'},{'nonempty'}));
%�����������������Ϊ��ѡ����
p.addOptional('iter',10,@(x)validateattributes(x,{'int8'},{'nonzero'}));
p.addOptional('error',0.001,@(x)validateattributes(x,{'double'},{'nonzero'}));
p.parse(data1,data2,varargin{:});

%�洢���
e_record = zeros(1,p.Results.iter);

X = p.Results.data1{2};
Y = p.Results.data2{2};

initD = init(data2,data1);
R0 = initD{1};
T0 = initD{2};
s0 = initD{3};
I = initD{4};
Y0 = initD{5};%ȡ��PCA����׼���Y

tic;
%������ⲿ��
c0 = Solvecircle(I,X,Y0);
Rn = c0{1};
Tn = c0{2};
sn = c0{3};
etemp = c0{4};%��ǰ���
Yn=c0{5};%��ǰ��Y
e_record(1)=etemp;
flag = 2;%��������
while (etemp>p.Results.error)
    c = Solvecircle(I,X,Yn);
    Rn = c{1};
    Tn = c{2};
    sn = c{3};
    en = c{4};%�任������
    Yn = c{5};%���µ���
    e_record(flag)=en;
    etemp = en;
    if flag>=p.Results.iter
        break;%���ڵ����������˳�
    end
    flag = flag + 1; 
end
%�������仯ͼ��
plot_error(e_record);
fprintf("the last iter:");
s = sn;
R = Rn;
T = Tn;
e = en;
it = flag - 1;
toc 
%��ʾ���ձ任λ�õĵ���Ynͼ��
figure;
scatter3(X(1,:)',X(2,:)',X(3,:)','b','.');hold on;
scatter3(Yn(1,:)',Yn(2,:)',Yn(3,:)','r','.');
xlabel('x(mm)');ylabel('y(mm)');zlabel('z(mm)');
axis([-5 5 -5 5]);
title('multisensor data after registering');
end

