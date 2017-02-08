function pyramid = pyramid_compute(words, coords, imgWidth, imgHight, params)
    if(~exist('params','var'))
        params.maxImageSize = 1024;
        params.gridSpacing = 8;
        params.patchSize = 16;
        params.dictionarySize = 1000000;
        params.numTextonImages = 50;
        params.pyramidLevels = 2;
    end
    if(~isfield(params,'maxImageSize'))
        params.maxImageSize = 1024;
    end
    if(~isfield(params,'gridSpacing'))
        params.gridSpacing = 8;
    end
    if(~isfield(params,'patchSize'))
        params.patchSize = 16;
    end
    if(~isfield(params,'dictionarySize'))
        params.dictionarySize = 1000000;
    end
    if(~isfield(params,'numTextonImages'))
        params.numTextonImages = 50;
    end
    if(~isfield(params,'pyramidLevels'))
        params.pyramidLevels = 2;
    end
    if(~exist('canSkip','var'))
        canSkip = 1;
    end

    binsHigh = 2^(params.pyramidLevels-1);
    
    %% compute histogram at the finest level - verified
    pyramid_cell = cell(params.pyramidLevels,1);
    pyramid_cell{1} = zeros(binsHigh, binsHigh, params.dictionarySize);
    
    x = coords(1, :);
    y = coords(2, :);

    for i=1:binsHigh
        for j=1:binsHigh

            % find the coordinates of the current bin
            x_lo = floor(imgWidth/binsHigh * (i-1));
            x_hi = floor(imgWidth/binsHigh * i);
            y_lo = floor(imgHight/binsHigh * (j-1));
            y_hi = floor(imgHight/binsHigh * j);
            
            A = (x > x_lo) & (x <= x_hi) & ...
                (y > y_lo) & (y <= y_hi);
            
            texton_patch = words(A);

            % make histogram of features in bin
            pyramid_cell{1}(i,j,:) = hist(texton_patch, 1:params.dictionarySize)./(length(words));
        end
    end
    
    %% compute histograms at the coarser levels - verified
    num_bins = binsHigh/2;
    for l = 2:params.pyramidLevels
        pyramid_cell{l} = zeros(num_bins, num_bins, params.dictionarySize);
        for i=1:num_bins
            for j=1:num_bins
                pyramid_cell{l}(i,j,:) = ...
                pyramid_cell{l-1}(2*i-1,2*j-1,:) + pyramid_cell{l-1}(2*i,2*j-1,:) + ...
                pyramid_cell{l-1}(2*i-1,2*j,:) + pyramid_cell{l-1}(2*i,2*j,:);
            end
        end
        num_bins = num_bins/2;
    end
    
    %% stack all the histograms with appropriate weights
    pyramid = [];
    for l = 1:params.pyramidLevels-1
        pyramid = [pyramid pyramid_cell{l}(:)' .* 2^(-l)];
    end

    pyramid = [pyramid pyramid_cell{params.pyramidLevels}(:)' .* 2^(1-params.pyramidLevels)];
    fprintf('end!\n');
end