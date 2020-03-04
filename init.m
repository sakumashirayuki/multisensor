function result = init(data1,data2)
pointx = data1{1};
X = data1{2};
pointy = data2{1};
Y = data2{2};

%��PCA����׼�ķ���ȷ����ʼֵ
%xcΪ���ݼ�1ƽ��ֵ��ycΪ���ݼ�2ƽ��ֵ
xc = mean(X,2);
yc = mean(Y,2);

%x1Ϊ���ݼ�1ȥ��ƽ��ֵ��Ľ����y1ͬ��
x1 = X - repmat(xc,[1 pointx]);
Mx =x1 * x1';

y1 = Y - repmat(yc,[1 pointy]);
My = y1 * y1';

%��������ֵD(һ���ԽǾ���)����������V(ÿһ��Ϊ����)
[Vx,Dx] = eig(Mx,'nobalance');
[Vy,Dy] = eig(My,'nobalance');

%s��Ϊ��ͳһ�������ݼ�����
sq = sum(sqrt(Dy/Dx));
s = sum(sq)/3;
%I
I = [min(sq),max(sq)];

%p1 p2Ϊ����x��������(3��ֵ)
%q1 q2 q3Ϊ����y��������
p1 = Vx(:,1);
p2 = Vx(:,2);
q1 = Vy(:,1);
q2 = Vy(:,2);
q3 = Vy(:,3);
f = 0.8;  %f��ʲô��
%������������(Ϊʲô��fΪ��׼��Ϊ�η���)
if dot(p1,q1) < f
    p1 = -p1;
end
if dot(p2,q2)<f
   p2 = -p2;
end
%���ݼ��ĵ��������귽����ǰ��������������˵���
p3 = cross(p1,p2);
%������֮���ת����ϵΪ��ת����
R = [q1,q2,q3]*inv([p1,p2,p3]);

%ƽ�ƾ���T = (yc - xc);
xc2 = mean(s*R*X,2);
T = (yc - xc2);
result = cell({R;T;s;I});