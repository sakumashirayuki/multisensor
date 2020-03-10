
% PCA��Ԫ������������
% ���룺
% p:3*n����ֵ����
% k:k���ڲ���
function n = lsqnormest(p, k)
m = size(p,2);
n = zeros(3,m);
neighbors = transpose(knnsearch(transpose(p), transpose(p), 'k', k+1));
for i = 1:m
    x = p(:,neighbors(2:end, i));
    p_bar = 1/k * sum(x,2);
    P = (x - repmat(p_bar,1,k)) * transpose(x - repmat(p_bar,1,k)); %Э�������
    
    [V,D] = eig(P);
    
    [~, idx] = min(diag(D)); 
    
    n(:,i) = V(:,idx);   % ��С����ֵ��Ӧ����������
    
    %�涨����ָ��
    flag = p(:,i) - p_bar;
    if dot(n(:,i),flag)<0
        n(:,i)=-n(:,i);
    end
end
