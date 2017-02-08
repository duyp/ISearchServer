function result = clientQuery(base64_query_img,dict,inv_file,dict_structure,pyramid_params,datasetDir,datasetFiles,ntop, ntopimg)
    sum_time = 0;
    fprintf('Decoding input... (%.2fkB to ',length(base64_query_img)/1024);
    tic;
    file = saveBase64Temp(base64_query_img);
    dirF = dir(file);
    I = im2single(rgb2gray(imread(file)));
    %delete(file);
    time = toc * 1000; fprintf('%.2fkB) (%dms)\n',dirF.bytes/1024,int32(time));
    sum_time = sum_time + time;
    
    fprintf('Extracting feature...');
    tic;
    [h, w, ~] = size(I);
    [root_sift, coord] = compute_rootsift_image(I);
    
    %% compute words
    q_words = cell(1,1);
    q_words{1} = ccvBowGetWords(dict, root_sift, [], dict_structure);
    if isempty(q_words{1})
        result = cell(1,1);
        result{1} = '0'; % empty ranked list
        return; 
    end
    q_words_spm = pyramid_extract_word(q_words{1},coord,w,h,pyramid_params);
    time = toc * 1000; fprintf(' (%dms)\n',int32(time));
    sum_time = sum_time + time;
    
    %% searching candidates from inverted file index and ranking
    fprintf('Querying...');
    tic;
    [ids, ~] = spm_ranking_nhi(inv_file,q_words_spm);
    %[ids, ~] = ccvInvFileSearch(inv_file, q_words(1), params.if_weight, params.if_norm, params.if_dist, ntop); 
    time = toc * 1000; fprintf('done (%dms)\n',int32(time));
    sum_time = sum_time + time;
    
    %ranked_ids = indexes{1};
    verbose = 0;
    if verbose == 1
        close all;
        hold on; subplot(3,5,3); imshow(I);
        title('Result');
        for i=1:size(ids,2)
            % Show only 10 highest score images
            if verbose == 1 && i<=10
                subplot(3, 5, 5+i);
                imshow(imread(strcat(datasetDir, datasetFiles(ids(i)).name)));
                title(datasetFiles(ids(i)).name);
            end
        end  
        pause;
    end
    
    %% make result array and return to web service
    % Result format:
    %   first element is ranked list length
    %   next elemtents is ranked list content 
    %   next elements is thumnail images (subset of ranked list)
    
    fprintf('Loading and encoding result images ');
    tic;
    if isempty(ids)
        ntop = 0;
        ntopimg = 0;
    elseif length(ids) < ntop
        ntop = length(ids);
        if ntop < ntopimg
            ntopimg = ntop;
        end
    end
    result = cell(1,1 + ntop + ntopimg);
    result{1} = num2str(ntop);
    for i = 1:ntop
        result{i+1} = num2str(ids(i));
    end
    
    thumbDir = 'jpgThumbnails\';
    nIn = 0; nOut = 0;
    for i = 1:ntopimg
        f = strcat(datasetDir,thumbDir,datasetFiles(ids(i)).name);
        df = dir(f);
        nIn = nIn + df.bytes;
        result{i+1+ntop} = base64file(f);
        nOut = nOut + length(result{i+1+ntop});
    end
   
    time = toc * 1000;
    fprintf('(%.2fkB to %.2fkB) (%dms)\n',nIn/1024,nOut/1024,int32(time));
    sum_time = sum_time + time;
    
    fprintf('Total processing time: %dms\n',int32(sum_time));
end