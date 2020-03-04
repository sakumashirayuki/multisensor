function inverse = complement(A)
%COMPLEMENT compute the inverse of the input matrix
SIZE = size(A);
if SIZE(1) ~= SIZE(2)
    error('the matrix must be square.');
end

if det(A) == 0
    error('the matrix should be nonsingular.');
end

determinant = det(A);
inverse = zeros(SIZE(1), SIZE(2));

for i = 1:SIZE(1)
    for j = 1:SIZE(2)
        C = A;
        C(i, 1:SIZE(2)) = 0;
        C(1:SIZE(1), j) = 0;
        C(i, j) = 1;
        inverse(i, j) = det(C);
    end
end

inverse = (inverse / determinant)';