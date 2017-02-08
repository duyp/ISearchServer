function result = dist_test(pAll, ids, dist)
p = pAll(ids);
n = length(p);
result = zeros(2,n);
for i = 1:n-1
    for j = i+1: n
        if strcmp(dist,'l1')
            result(i,j) = dist_l1_c(p{i}(1,:), p{i}(2,:), p{j}(1,:),p{j}(2,:));
        end
        
        if strcmp(dist,'l2')
            result(i,j) = dist_l2_c(p{i}(1,:), p{i}(2,:), p{j}(1,:),p{j}(2,:));
        end
        
        if strcmp(dist,'nhi')
            result(i,j) = dist_nhi_c(p{i}(1,:), p{i}(2,:), p{j}(1,:),p{j}(2,:));
        end
    end
end

for i = 1:n-1
    for j = i+1: n
        if strcmp(dist,'l1')
            result(j,i) = dist_l1_c(p{i}(1,:), p{i}(2,:), p{j}(1,:),p{j}(2,:));
        end
        
        if strcmp(dist,'l2')
            result(j,i) = dist_l2_c(p{i}(1,:), p{i}(2,:), p{j}(1,:),p{j}(2,:));
        end
        
        if strcmp(dist,'nhi')
            result(j,i) = dist_nhi_c(p{i}(1,:), p{i}(2,:), p{j}(1,:),p{j}(2,:));
        end
    end
end

end