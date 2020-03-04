function inverse = usv(A)
%USV compute the inverse of the input matrix
SIZE = size(A);
if SIZE(1) ~= SIZE(2);
    error('the matrix must be square.');
end

if det(A) == 0
    error('the matrix should be nonsingular.');
end

[U, S, V] = svd(A, 0);

for i = 1:size(S, 1)
    S(i, i) = 1 / S(i, i);
end

inverse = V * S * U';
