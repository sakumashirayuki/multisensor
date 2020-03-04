function inverse = rtransform(A)
%RTRANSFORM compute the inverse of the input matrix
SIZE = size(A);
if SIZE(1) ~= SIZE(2)
    error('the matrix must be square.');
end

if det(A) == 0
    error('the matrix should be nonsingular.');
end

B = diag(ones(SIZE(1), 1));
C = rref([A B]);
inverse = C(1:SIZE(1), SIZE(2)+1:2*SIZE(2));
