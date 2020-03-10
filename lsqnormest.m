
% PCA主元分析法求法向量
% 输入：
% p:3*n的数值矩阵
% k:k近邻参数
function n = lsqnormest(p, k)
m = size(p,2);
n = zeros(3,m);
neighbors = transpose(knnsearch(transpose(p), transpose(p), 'k', k+1));
for i = 1:m
    x = p(:,neighbors(2:end, i));
    p_bar = 1/k * sum(x,2);
    P = (x - repmat(p_bar,1,k)) * transpose(x - repmat(p_bar,1,k)); %协方差矩阵
    
    [V,D] = eig(P);
    
    [~, idx] = min(diag(D)); 
    
    n(:,i) = V(:,idx);   % 最小特征值对应的特征向量
    
    %规定方向指向
    flag = p(:,i) - p_bar;
    if dot(n(:,i),flag)<0
        n(:,i)=-n(:,i);
    end
end
