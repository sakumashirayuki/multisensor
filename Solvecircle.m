function c = Solvecircle(I,X,Y)
% 输入参数有修改
% 输入的Y已是变换后的
% 是让Y变换为X
% 替换了找最近点的方法
% 增加输出值：变换后的Yn
% 输出值{Rn;Tn;sn;fn;Yn}
% 原本delaunayn对应dsearchn
% 现在createns对应knnsearch

pointx = length(X(1,:));
pointy = length(Y(1,:));

%Y进行变化Y--Yo--接近X
%Yo = s*R*Y+repmat(T,[1 pointy]);

%dsearchn求Z,即Yo(变化后)中对应X的数据
%先对变换后的Y进行三角剖分
% Y_tri = delaunayn(Yo');

%另一种寻找最近点的方法
Y_tri = createns(Y','NSMethod','kdtree');

%一个最近点search算法
%返回的是Yo中的点下标
% k = dsearchn(Yo',Y_tri,X');
k = knnsearch(Y_tri,X');
Z = Y(:,k);

%计算H矩阵
zc = mean(Z,2);
xc = mean(X,2); %xc,zc为坐标中点
%H = zeros(3,3);
% 计算Xi,Zi
Zi = Z - repmat(zc,[1 pointx]);
Xi = X - repmat(xc,[1 pointx]);

%更新变换矩阵
%计算Rk+1
Rn = computeR(Zi,Xi);
%计算s-k+1 
sn = computeS(I,Rn,Zi,Xi);
%计算Tk+1
Tn = computeT(xc,sn,Rn,zc);
%对于k+1数据的e，fn
fn = computeE(sn,Rn,Tn,Z,X);

Yn = sn*Rn*Y+repmat(Tn,[1 pointy]);
c = cell({Rn;Tn;sn;fn;Yn});
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
%原误差的算法：所有点欧式距离之和
%现误差算法：RMS
function e = computeE(s,R,T,X,Z) 
pointx = length(X(1,:));
c = s.*(R*X)+repmat(T,[1 pointx])-Z;
%e = sum(dot(c,c));
e=mean(dot(c,c));
e = sqrt(e);
end