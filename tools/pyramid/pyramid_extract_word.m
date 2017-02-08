function words_part = pyramid_extract_word(words, coords, imgWidth, imgHigh, params)
    if(~exist('params','var'))
       params.pyramidLevels = 3;
       params.dictionarySize = 1000000;
    end
    
    size = (1/3)*(4^(params.pyramidLevels)-1);
    
    words_part = cell(1, size);
    words_part{1} = words;
    
    x = coords(1, :);
    y = coords(2, :);

    for k = 2 : params.pyramidLevels
        binsHigh = 2^(k - 1);
        nId = (1/3)*(4^(k-1)-1);
        for i=1:binsHigh
            for j=1:binsHigh
                % find the coordinates of the current bin
                x_lo = floor(imgWidth/binsHigh * (i-1));
                x_hi = floor(imgWidth/binsHigh * i);
                y_lo = floor(imgHigh/binsHigh * (j-1));
                y_hi = floor(imgHigh/binsHigh * j);
                
                A = (x > x_lo) & (x <= x_hi) & ...
                    (y > y_lo) & (y <= y_hi);
                
                index = nId + (i-1)*binsHigh + j;
                words_part{index} = [words_part{index} words(A)];
            end
        end
    end
end