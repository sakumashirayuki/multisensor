function inverse = mp(A)
%MP compute the inverse of the input matrix
SIZE = size(A);
if SIZE(1) ~= SIZE(2)
    error('the matrix must be square.');
end

if det(A) == 0
    error('the matrix should be nonsingular.');
end

inverse = pinv(A);