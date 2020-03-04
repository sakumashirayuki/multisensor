function c = Solvecircle(s,R,T,I,X,Y,Yo)

pointx = length(X(1,:));
%pointy = length(Y(1,:));
%X���б仯X--Xo--�ӽ�Y
Xo = s*R*X+repmat(T,[1 pointx]);

%dsearchn��Z,��Y�ж�ӦX(�仯��)������
%һ�������search�㷨
%���ص���Y�еĵ��±�
k = dsearchn(Y',Yo,Xo');
Z = Y(:,k);

%���㵱ǰek��ֵ
en = computeE(s,R,T,X,Z);
%����H����
xc = mean(X,2); %xc,zcΪ�����е�
zc = mean(Z,2);
%H = zeros(3,3);
% ����Xi,Zi
Xi = X - repmat(xc,[1 pointx]);
Zi = Z - repmat(zc,[1 pointx]);

%���±任����
%����Rk+1
Rn = computeR(Xi,Zi);
%����s-k+1 
sn = computeS(I,Rn,Xi,Zi);
%����Tk+1
Tn = computeT(zc,sn,Rn,xc);
%����k+1���ݵ�e��fn
fn = computeE(sn,Rn,Tn,X,Z);
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
%�����㷨����ŷʽ����
function e = computeE(s,R,T,X,Z) 
pointx = length(X(1,:));
c = s.*(R*X)+repmat(T,[1 pointx])-Z;
e = sum(dot(c,c));
end