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
p.addOptional('iter',10,@(x)validateattributes(x,{'int64'},{'nonzero'}));
p.addOptional('error',0.001,@(x)validateattributes(x,{'double'},{'nonzero'}));
p.parse(data1,data2,varargin{:});

%�洢���
e_record = zeros(1,p.Results.iter);
pointx = p.Results.data1{1};
pointy = p.Results.data2{1};
X = p.Results.data1{2};
Y = p.Results.data2{2};

%������ʼֵ
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
%�趨�¶ȣ�
tBegin = 100;%��Ҫ�趨һ���ܴ���¶�,�¶�Խ��Խ����ת��
tEnd = 1e-30;%�����¶Ⱥ�С
temperature = tBegin;
rate = 0.95;%��������
while (etemp>p.Results.error)
    Y_temp = Yn;%��¼��һ�α任�����ĵ���Yn
    %����SVD�����ĳ����
    c = Solvecircle(I,X,Yn);
    Rn = c{1};
    Tn = c{2};
    sn = c{3};
    en = c{4};%�任������
    Yn = c{5};%���µ���
    etemp = en;%���µ�ǰ���
    if flag>=p.Results.iter
        e_record(flag)=en;%�������
        fprintf("completed all iterations/n");
        break;%���ڵ����������˳�
    end
    %�����Ŷ���
    [R_disturb,T_disturb,Y_disturb,e_disturb]...
    =createDisturb(Rn,Tn,X,Y_temp,pointy);
    %metropolis�����ж��Ƿ�����½�
    Temp = ({Rn;Tn;Yn;en});
    Disturb = ({R_disturb;T_disturb;Y_disturb;e_disturb});
    %�õ������жϵĽ�
    [Rn,Tn,en,Yn,temperature]=Metropolis(Temp,Disturb,temperature,rate);
    %�ж��Ƿ���ֹ����
    if temperature < tEnd%���С����ֹ�¶�
        e_record(flag)=en;%�������
        fprintf("the temperature is lower than Tend/n");
        break;
    end
    e_record(flag)=en;%�������
    flag = flag+1;
end
%�������仯ͼ��
plot_error(e_record);
fprintf("the last iter:");
temperature
it = flag - 1
s = sn;
R = Rn;
T = Tn;
e = en
toc 
%��ʾ���ձ任λ�õĵ���Ynͼ��
figure;
scatter3(X(1,:)',X(2,:)',X(3,:)','b','.');hold on;
scatter3(Yn(1,:)',Yn(2,:)',Yn(3,:)','r','.');
xlabel('x(mm)');ylabel('y(mm)');zlabel('z(mm)');
axis([-5 5 -5 5]);
title('multisensor data after registering');
end

