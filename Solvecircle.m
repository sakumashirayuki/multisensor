function c = Solvecircle(I,X,Y)
% 输入的Y已是变换后的
% 输入：n维*点数
% 替换了找最近点的方法
% 增加输出值：变换后的Yn
% 输出值{Rn;Tn;sn;fn;Yn}
% 原本delaunayn对应dsearchn
% 现在createns对应knnsearch
% 去掉了缩放因子

pointx = length(X(1,:));
pointy = length(Y(1,:));

%Y进行变化Y--Yo--接近X

%dsearchn求X,即X中对应Yo(变化后)的数据

%另一种寻找最近点的方法
X_tri = createns(X','NSMethod','kdtree');

%一个最近点search算法
%返回的是X中的点下标
%不进行createns处理
% k = dsearchn(Yo',Y_tri,X');
k = knnsearch(X_tri,Y');
% k = knnsearch(Y',X');
Z = X(:,k);

%计算H矩阵
zc = mean(Z,2);
yc = mean(Y,2); %yc,zc为坐标中点
%H = zeros(3,3);
% 计算Xi,Zi
Zi = Z - repmat(zc,[1 pointy]);
Yi = Y - repmat(yc,[1 pointy]);

%更新变换矩阵
%计算Rk+1
Rn = computeR(Yi,Zi);
%计算s-k+1 
sn = computeS(I,Rn,Yi,Zi);
%计算Tk+1
% Tn = computeT(xc,sn,Rn,zc);
Tn = computeT(zc,Rn,yc);
%对于k+1数据的e，fn
fn = computeE(Rn,Tn,Y,Z);

Yn = Rn*Y+repmat(Tn,[1 pointy]);
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
function Tn = computeT(zc,Rn,xc)
Tn = zc - Rn*xc;
end
