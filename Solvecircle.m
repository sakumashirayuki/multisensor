function c = Solvecircle(s,R,T,I,X,Y)
% ����������޸�
% ����Y�任ΪX

pointx = length(X(1,:));
pointy = length(Y(1,:));

%Y���б仯Y--Yo--�ӽ�X
%Xo = s*R*X+repmat(T,[1 pointx]);
Yo = s*R*Y+repmat(T,[1 pointy]);

%dsearchn��Z,��Yo(�仯��)�ж�ӦX������
%�ȶԱ任���Y���������ʷ�
Y_tri = delaunayn(Yo');
%һ�������search�㷨
%���ص���Yo�еĵ��±�
k = dsearchn(Yo',Y_tri,X');
Z = Yo(:,k);

%���㵱ǰek��ֵ
%���ĸ������Ǳ任ǰ�����ݵ�(Z)�������������Ŀ�����ݵ�(X)
en = computeE(s,R,T,Z,X);
%����H����
zc = mean(Z,2);
xc = mean(X,2); %xc,zcΪ�����е�
%H = zeros(3,3);
% ����Xi,Zi
Zi = Z - repmat(zc,[1 pointx]);
Xi = X - repmat(xc,[1 pointx]);

%���±任����
%����Rk+1
Rn = computeR(Zi,Xi);
%����s-k+1 
sn = computeS(I,Rn,Zi,Xi);
%����Tk+1
Tn = computeT(xc,sn,Rn,zc);
%����k+1���ݵ�e��fn
fn = computeE(sn,Rn,Tn,Z,X);
c = cell({Rn;Tn;sn;en;fn});
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
function Tn = computeT(zc,sn,Rn,xc)
Tn = zc - sn*Rn*xc;
end


%����Ek+1
%ԭ�����㷨�����е�ŷʽ����֮��
%������㷨��RMS
function e = computeE(s,R,T,X,Z) 
pointx = length(X(1,:));
c = s.*(R*X)+repmat(T,[1 pointx])-Z;
%e = sum(dot(c,c));
e=mean(dot(c,c));
e = sqrt(e);
end