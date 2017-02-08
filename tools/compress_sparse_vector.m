function [ids, values] = compress_sparse_vector(v)
    n = size(v,2);
    ids = [];
    values = [];
    for i = 1:n
        if v(i) ~= 0
            ids = [ids i];
            values = [values v(i)];
        end
    end
end