function c = Solvecircle(s,R,T,I,X,Y,Yo)

pointx = length(X(1,:));
%pointy = length(Y(1,:));
%X进行变化X--Xo--接近Y
Xo = s*R*X+repmat(T,[1 pointx]);

%dsearchn求Z,即Y中对应X(变化后)的数据
%一个最近点search算法
%返回的是Y中的点下标
k = dsearchn(Y',Yo,Xo');
Z = Y(:,k);

%计算当前ek差值
en = computeE(s,R,T,X,Z);
%计算H矩阵
xc = mean(X,2); %xc,zc为坐标中点
zc = mean(Z,2);
%H = zeros(3,3);
% 计算Xi,Zi
Xi = X - repmat(xc,[1 pointx]);
Zi = Z - repmat(zc,[1 pointx]);

%更新变换矩阵
%计算Rk+1
Rn = computeR(Xi,Zi);
%计算s-k+1 
sn = computeS(I,Rn,Xi,Zi);
%计算Tk+1
Tn = computeT(zc,sn,Rn,xc);
%对于k+1数据的e，fn
fn = computeE(sn,Rn,Tn,X,Z);
c = cell({Rn;Tn;sn;en;fn});
end
 
%计算Rk+1
%使用SVD分解方法求旋转矩阵
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

%计算sk+1
function sn = computeS(I,Rn,Xi,Zi)
sn = sum(dot(Rn*Xi,Zi))/sum(dot(Xi,Xi));
if sn <=  I(1)
    sn = I(1);
elseif sn >= I(2)
    sn = I(2);    
end
end


%计算Tk+1
function Tn = computeT(zc,sn,Rn,xc)
Tn = zc - sn*Rn*xc;
end


%计算Ek+1
%误差的算法就是欧式距离
function e = computeE(s,R,T,X,Z) 
pointx = length(X(1,:));
c = s.*(R*X)+repmat(T,[1 pointx])-Z;
e = sum(dot(c,c));
end