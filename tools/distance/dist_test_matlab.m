function result = dist_test_matlab(pAll, ids)
p = pAll(ids);
n = length(p);
result = zeros(2,n);
for i = 1:n-1
    for j = i+1: n
            result(i,j) = pdist2(p{i}, p{j});
    end
end

for i = 1:n-1
    for j = i+1: n
       result(j,i) = pdist2(p{i}, p{j});
    end
end

end