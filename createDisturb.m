function [R_disturb,T_disturb,Y_disturb,e_disturb]...
    =createDisturb(Rn,Tn,X,Y_temp,pointy)
%�����Ŷ���
%���һ�����ת����
%����Ϊ���󣬱�׼�����ߴ�
angle_disturb = normrnd(0,0.1,1,3);
R_disturb = Rn*angle2dcm(angle_disturb(1),angle_disturb(2),angle_disturb(3));
%��ƽ�ƾ�������Ŷ�
T_disturb = Tn+normrnd(0,0.02,[1 3])';
%������Ŷ��任����任��ĵ���Yn
Y_disturb = R_disturb*Y_temp+repmat(T_disturb,[1 pointy]);
%��Y_disturb��X�еĶ�Ӧ��Z
X_tri = createns(X','NSMethod','kdtree');
k = knnsearch(X_tri,Y_disturb');
% k = knnsearch(Y_disturb',X');
Z = X(:,k);
%�������
e_disturb = computeE(R_disturb,T_disturb,Y_disturb,Z);
end