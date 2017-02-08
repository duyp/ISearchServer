function pyramid_compress_all(pyramidDir, beginImage, endImage)
    tic;
    files = dir(fullfile(pyramidDir, '*2.mat'));
    if endImage > length(files)
        endImage = length(files)
    end
    for i = beginImage:endImage
        i
        load(strcat(pyramidDir, files(i).name));
        [ids, values] = compress_sparse_vector(pyramid);
        
        [dirN base] = fileparts(files(i).name);
        baseFName = fullfile(dirN, base);
        save(strcat(pyramidDir, baseFName, '_compressed.mat'), 'ids', 'values');
    end
    toc;
end