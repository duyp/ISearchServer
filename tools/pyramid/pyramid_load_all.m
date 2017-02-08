function pyramid_all = pyramid_load_all(pyramidDir, params, isCompessed)
    if (~exist('params', 'var'))
       params.pyramidLevels = 2;
       params.dictionarySize = 1000000;
    end
    
    if (~exist('isCompessed', 'var'))
        isCompessed = 1;
    end
    
    endname = sprintf('*_%d_%d', params.dictionarySize, params.pyramidLevels);
    
    if isCompessed == 1
        endname = strcat(endname, '_compressed');
    end
    
    endname = strcat(endname, '.mat');
    
    files = dir(fullfile(pyramidDir, endname));
    n = length(files);
    
    pyramid_all = cell(1, n);
    
    for i = 1:n
        i
        load(strcat(pyramidDir, files(i).name));
        if isCompessed == 1
            pyramid_all{i} = [ids; values];
        else
            pyramid_all{i} = pyramid;
        end
    end
end