function c = Solvecircle(I,X,Y)
% �����Y���Ǳ任���
% ���룺nά*����
% �滻���������ķ���
% �������ֵ���任���Yn
% ���ֵ{Rn;Tn;sn;fn;Yn}
% ԭ��delaunayn��Ӧdsearchn
% ����createns��Ӧknnsearch
% ȥ������������

pointx = length(X(1,:));
pointy = length(Y(1,:));

%Y���б仯Y--Yo--�ӽ�X

%dsearchn��X,��X�ж�ӦYo(�仯��)������

%��һ��Ѱ�������ķ���
X_tri = createns(X','NSMethod','kdtree');

%һ�������search�㷨
%���ص���X�еĵ��±�
%������createns����
% k = dsearchn(Yo',Y_tri,X');
k = knnsearch(X_tri,Y');
% k = knnsearch(Y',X');
Z = X(:,k);

%����H����
zc = mean(Z,2);
yc = mean(Y,2); %yc,zcΪ�����е�
%H = zeros(3,3);
% ����Xi,Zi
Zi = Z - repmat(zc,[1 pointy]);
Yi = Y - repmat(yc,[1 pointy]);

%���±任����
%����Rk+1
Rn = computeR(Yi,Zi);
%����s-k+1 
sn = computeS(I,Rn,Yi,Zi);
%����Tk+1
% Tn = computeT(xc,sn,Rn,zc);
Tn = computeT(zc,Rn,yc);
%����k+1���ݵ�e��fn
fn = computeE(Rn,Tn,Y,Z);

Yn = Rn*Y+repmat(Tn,[1 pointy]);
c = cell({Rn;Tn;sn;fn;Yn});
end
 
%����Rk+1
%ʹ��SVD�ֽⷽ������ת����
function Rn=computeR(Xi,Zi)
H = Xi*(Zi');
[U S V] = svd(H);
if round(det(V*U')) == 1
    Rn = V*U';
elseif round(det(V*U')) == -1
    x = [1 0 0;0 1 0;0 0 -1];
    Rn = V*x*U';
end
end

%����sk+1
function sn = computeS(I,Rn,Xi,Zi)
sn = sum(dot(Rn*Xi,Zi))/sum(dot(Xi,Xi));
if sn <=  I(1)
    sn = I(1);
elseif sn >= I(2)
    sn = I(2);    
end
end


%����Tk+1
function Tn = computeT(zc,Rn,xc)
Tn = zc - Rn*xc;
end
