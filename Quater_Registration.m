function [R,T] = Quater_Registration(Source, Target)
% function Quater_Registration is used to calculate the transformation from CYS 1 to CYS 2, 
% Source contains points in CYS1 which need to be transformed and Target contains points in final CYS2.
% Target = H * Source;
% Target = R * Source + T;

m = size(Source,1);
ASource = [];
BTarget = [];
for i=1:m-1
    ASource(i,:) = Source(i,:) - Source(i+1,:);
end
for i=1:m-1
    BTarget(i,:) = Target(i,:) - Target(i+1,:);
end

A=[];
B=[];
for k=1:i
    v=ASource(k,:)+BTarget(k,:);
    C = [ 0   -v(3) v(2);
      v(3) 0   -v(1);
     -v(2) v(1)  0   ];
    A = vertcat(A,C);
    B = vertcat(B,(ASource(k,:)-BTarget(k,:))');
end

X = inv(A'*A)*A'*B; 
K = X/norm(X);      % K is the rotation vector;
Theta = 2*atan(max(X)/max(K));      % in radian

kx=K(1);
ky=K(2);
kz=K(3);
t = Theta;      % in radian

ct= cos(t);
st= sin(t);
vt= 1-cos(t);

% input rotation matrix R
R = [kx^2*vt+ct     kx*ky*vt-kz*st kx*kz*vt+ky*st;
      kx*ky*vt+kz*st ky^2*vt+ct     ky*kz*vt-kx*st;
      kx*kz*vt-ky*st ky*kz*vt+kx*st kz^2*vt+ct];
T = mean((Target' - R * Source'),2);

% T_Q = vertcat(horzcat(R,T),[0 0 0 1]);

