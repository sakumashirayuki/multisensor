function inverse = gu(A)
%GU compute the inverse of the input matrix
SIZE = size(A);
%check size of input argument
if SIZE(1) ~= SIZE(2)
    error('the matrix must be square.');
end
%check singular or nonsingular
if det(A) == 0
    error('the matrix should be nonsingular.');
end

r = zeros(SIZE(1), 1);
c = zeros(SIZE(1), 1);

for k = 1:SIZE(1)
    max = -1;
 %find the absolute maximun of the right-bottom of A(k, k)   
    for i = k:SIZE(1)
        for j = k:SIZE(2)
            if abs(A(i, j)) > max
                max = abs(A(i, j));
                r(k) = i;
                c(k) = j;
            end
        end
    end
    
    if max == 0;
        break;
    end
 %exchange row if necessary   
    if r(k) ~= k
        A = swap(A, k, r(k), 'r');
    end
%exchange column if necessary   
    if c(k) ~= k
        A = swap(A, k, c(k), 'c');
    end
    
    A(k, k) = 1.0 / A(k, k);
 %compute A(k, j) = A(k, j) * A(k, k)£¬j = 0, 1, ..., n-1£»j != k   
    for i = 1:SIZE(1)
        if i~= k
            A(k, i) = A(k, i) * A(k, k);
        end
    end
%compute A(i, j) = A(i, j) - A(i, k) * A(k, j)£¬i, j = 0, 1, ..., n-1£»i, j != k        
    for i = 1:SIZE(1)
        for j = 1:SIZE(2)
            if i~= k & j~= k
                A(i, j) = A(i, j) - A(i, k) * A(k, j);
            end
        end
    end
%compute A(i, k) = -A(i, k) * A(k, k)£¬i = 0, 1, ..., n-1£»i != k    
    for j = 1:SIZE(2)
        if j~= k
            A(j, k) = -A(j, k) * A(k, k);
        end
    end
end
%re-exchange row or column
 for k = SIZE(1):-1:1
    if c(k) ~= k
        A = swap(A, k, c(k), 'r');
    end
    
    if r(k) ~= k
        A = swap(A, k, r(k), 'c');
    end
end
inverse = A;


function matrix = swap(A, a, b, char)
%SWAP exchange the row or column of matrix A
S = size(A);
temp = zeros(S(1), 1);
% exchange row
if char == 'r'
    temp = A(a, 1:S(1))';
    A(a, 1:S(1)) = A(b, 1:S(1));
    A(b, 1:S(1)) = temp';
%exchange column
else
    temp = A(1:S(1), a);
    A(1:S(1), a) = A(1:S(1), b);
    A(1:S(1), b) = temp;
end
matrix = A;


                