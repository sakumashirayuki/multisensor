function PFH(data1,data2)
% input variables are cells {2*1}
% the first one is number of points
% the second one is a matrix with n-dimension * number of points
P = data1{2};
Q = data2{2};
% moban1=Q(1,:)>-0.1;
% moban2=Q(1,:)<-0.06;
% moban3=Q(2,:)>0.1;
% moban4=Q(2,:)<0.15;
% ROI=moban1&moban2&moban3&moban4;
% Q=Q(:,ROI);
% data2{1}=size(Q,2);
k=8;
%通过8邻域PCA建立法向量
pn = lsqnormest(P, k);
qn = lsqnormest(Q, k);
figure;
plot3(P(1,:),P(2,:),P(3,:),'r.');
hold on
plot3(Q(1,:),Q(2,:),Q(3,:),'b.');
view(2)
%计算特征度
pt=zeros(1,data1{1});
qt=zeros(1,data2{1});
[n1,d1] = knnsearch(transpose(P), transpose(P), 'k', 400);
n1=transpose(n1);
d1=transpose(d1);
for i=1:data1{1}
    pt(1,i)=1/k*sum(abs(transpose(pn(:,n1(2:k+1,i)))*pn(:,i)));
end
[n2,d2] = knnsearch(transpose(Q), transpose(Q), 'k', 400);
n2=transpose(n2);
d2=transpose(d2);
for i=1:data2{1}
    qt(1,i)=1/k*sum(abs(transpose(qn(:,n2(2:k+1,i)))*qn(:,i)));
end
%选取特征点
ptt=find(pt<mean(pt));
qtt=find(qt<mean(qt));
p0=P(:,ptt);
q0=Q(:,qtt);
figure;
plot3(p0(1,:),p0(2,:),p0(3,:),'r.');
hold on
plot3(q0(1,:),q0(2,:),q0(3,:),'b.');
view(2)
fep=[];feq=[];
for i=ptt
    [~,I]=min(pt(1,n1(1:k+1,i)));
    if I==1
        fep=[fep,i];
    end
end
for i=qtt
    [~,I]=min(qt(1,n2(1:k+1,i)));
    if I==1
        feq=[feq,i];
    end
end
feq0=feq;
p0=P(:,fep);
q0=Q(:,feq);
figure;
plot3(p0(1,:),p0(2,:),p0(3,:),'r.');
title('目标点云关键点提取')
view(2)
figure;
plot3(q0(1,:),q0(2,:),q0(3,:),'b.');
title('模板点云关键点提取')
view(2)
%fep为P中特征点在点云P中的索引，p0为特征点坐标矩阵
save PFH1.mat%保存工作区所有变量
end