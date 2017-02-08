function bow = build_bow(words, num_words)
    n_images = size(words,2);
    bow = cell(1,n_images);
    
    matlabpool('open', 4);
    for k = 1:1000:n_images
        eI = k + 1000 - 1;
        if eI > n_images
            eI = n_images
        end
        parfor i = k:eI
            i
            h = hist(words{i}, 1:num_words)./length(words{i});
            [bow{i}(1,:), bow{i}(2,:)] = compress_sparse_vector(h); 
        end
    end
    matlabpool('close');
end