function dist = dist_l2_sparse(v1, v2)
    n = length(v1);
    sum = 0;
    for i = 1:n
       sum = sum + (v1(i) - v2(i))*(v1(i) - v2(i)); 
    end
    dist = sqrt(sum);
end