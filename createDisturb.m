function [R_disturb,T_disturb,Y_disturb,e_disturb]...
    =createDisturb(Rn,Tn,X,Y_temp,pointy)
%生成扰动解
%添加一个随机转动角
%输入为矩阵，标准差，矩阵尺寸
angle_disturb = normrnd(0,0.1,1,3);
R_disturb = Rn*angle2dcm(angle_disturb(1),angle_disturb(2),angle_disturb(3));
%对平移矩阵添加扰动
T_disturb = Tn+normrnd(0,0.02,[1 3])';
%求解用扰动变换矩阵变换后的点云Yn
Y_disturb = R_disturb*Y_temp+repmat(T_disturb,[1 pointy]);
%找Y_disturb在X中的对应点Z
X_tri = createns(X','NSMethod','kdtree');
k = knnsearch(X_tri,Y_disturb');
% k = knnsearch(Y_disturb',X');
Z = X(:,k);
%计算误差
e_disturb = computeE(R_disturb,T_disturb,Y_disturb,Z);
end