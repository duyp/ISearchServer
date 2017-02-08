function [ids, pyramids] = pyramid_search(pyramid_all, indexes)
    n = length(indexes);
    pyramids = cell(1, n);
    ids = zeros(1,n);
    for i = 1:n
        ids(i) = indexes(i);
        pyramids{i} = pyramid_all{ids(i)};
    end
end