%计算Ek+1
%原误差的算法：所有点欧式距离之和
%现误差算法：RMS
%结果恒为正
function e = computeE(R,T,X,Z) 
pointx = length(X(1,:));
c = R*X+repmat(T,[1 pointx])-Z;
%e = sum(dot(c,c));
e=mean(dot(c,c));
e = sqrt(e);
end