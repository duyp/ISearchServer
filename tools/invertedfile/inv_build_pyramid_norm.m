function [inv, words_part] = inv_build_pyramid_norm(words, coords, img_size, params)
    if(~exist('params','var'))
       params.pyramidLevels = 2;
       params.dictionarySize = 1000000;
    end
    
    size = (1/3)*(4^(params.pyramidLevels)-1);
    words_part = cell(1, size);
    
    % the first is whole image (bin = 2^0 = 1)
    words_part{1} = words;
    
    % allocate for all bin
    for i = 2:size
        words_part{i} = cell(1,length(words));
    end
    
    %loop on docs (images) and compute word for next bins ( 2 -> end)
    fprintf('Analysing word parts...');
    for k = 1:length(words)
        %fprintf('image[%d]\n',k);
        x = coords{k}(1, :);
        y = coords{k}(2, :);
        
        imgWidth = img_size(2, k);
        imgHight = img_size(1, k);
        
        % compute word for next bins ( 2 -> end)
        for k1 = 2 : params.pyramidLevels
            binsHigh = 2^(k1 - 1);
            nId = (1/3)*(4^(k1-1)-1);
            for i=1:binsHigh
                for j=1:binsHigh
                    % find the coordinates of the current bin
                    x_lo = floor(imgWidth/binsHigh * (i-1));
                    x_hi = floor(imgWidth/binsHigh * i);
                    y_lo = floor(imgHight/binsHigh * (j-1));
                    y_hi = floor(imgHight/binsHigh * j);

                    A = (x > x_lo) & (x <= x_hi) & ...
                        (y > y_lo) & (y <= y_hi);

                    index = nId + (i-1)*binsHigh + j;
                    words_part{index}{k} = [words_part{index}{k} words{k}(A)];
                end
            end
        end
        
    end   
    fprintf('Done!\nCreating inverted file index...\n');
    inv = inv_create_spm_norm_c(words_part);
end