%����Ek+1
%ԭ�����㷨�����е�ŷʽ����֮��
%������㷨��RMS
%�����Ϊ��
function e = computeE(R,T,X,Z) 
pointx = length(X(1,:));
c = R*X+repmat(T,[1 pointx])-Z;
%e = sum(dot(c,c));
e=mean(dot(c,c));
e = sqrt(e);
end