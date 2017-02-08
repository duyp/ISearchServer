function ranked_ids = ranking_spm(pyramid_all, q_ids, q_values, indexes)
    [ids, pyramids] = pyramid_search(pyramid_all, indexes);
    n = length(ids);
    max_dist = 1;
    dist = zeros(1, n);
    for i = 1: n
        %fprintf('Index: %d\n\n', ids(i));
        s = size(pyramids{i});
        if s(1) == 0 || s(2) == 0
            dist(i) = max_dist;
            continue;
        end
        
        idSet = pyramids{i}(1,:);
        valueSet = pyramids{i}(2,:);

        dist(i) = dist_nhi_c(q_ids, q_values, ...
                                     idSet, valueSet);
    end
    
    A = [dist; ids];
    A = rot90(A);
    A = sortrows(A);
    A = flipdim(A,1);
    ranked_ids = rot90(A(:, 2));
    
    fprintf('end !');
    
    
end