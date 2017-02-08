function p_query =  query_groundtruth_SPM(dict_words, inv_file, dict_structure, pyramid_all, pyramid_params, groundtruthDir, datasetDir)
%% Query groundtruth images: compute mean Average Precision (mAP) for dataset

% dict_words:               dictionary
% inv_file:                 inverted file index 
% dict_structure:           dict structure
% datasetDir:               dataset directory

%returns: after ranking, this function will run script to compute mAP from result directory

    fprintf('query...');
    verbose=0;
    files = dir(fullfile(datasetDir, '*.jpg'));
    q_files = dir(fullfile(groundtruthDir, '*query.txt'));
    disp(length(q_files));
    ntop = 0;
    
    k = 0;
    % load query image
    %while k >= 0
    for k = 1:length(q_files)
        %k = input('Nhap k: \n');
        %% extract query info
        fprintf('\nQuerying file: %s\n',q_files(k).name);
        [image_name, points] = groundtruth_extractinfo(strcat(groundtruthDir, q_files(k).name));
        %file = strcat(datasetDir, image_name(6:end), '.jpg');
        file = strcat(datasetDir, image_name(1:end), '.jpg');
        %% compute rootSIFT
        I = im2single(rgb2gray(imread(file)));
        [h, w, ~] = size(I);
        [root_sift, coord] = compute_rootsift_image(I);
        
        %% compute words
        q_words = cell(1,1);
        q_words{1} = ccvBowGetWords(dict_words, root_sift, [], dict_structure);
        
        %% compute spatial pyramid
        fprintf('Computing spatial pyramid...\n');
        
        p_query = pyramid_compute(q_words{1}, coord, w, h, pyramid_params);
        [q_ids, q_values] = compress_sparse_vector(p_query);  
        
        %% inverted file search
        fprintf('inverted file search...\n');
        if_weight = 'tfidf';
        if_norm = 'l1';
        if_dist = 'l1';
        [indexes, ~] = ccvInvFileSearch(inv_file, q_words(1), if_weight, if_norm, if_dist, ntop);
        
        %ranked_ids = indexes{1};
        ids = ranking_spm(pyramid_all, q_ids, q_values, indexes{1});
        
        %ranked_ids = indexes{1};
        ranked_ids = ids;
        
        %ranked_ids = indexes{1};
        
        %% visualize
        if verbose ==1
            close all;
            hold on; subplot(3,5,3); imshow(I);
            %title(image_name(6:end));
            title(image_name(1:end));
        end
        fid = fopen(strcat(groundtruthDir, 'rank_list.txt'), 'wt');
        for i=1:size(ranked_ids,2)
           %i
                    % Show only 10 highest score images
            if verbose == 1 && i<=10
                %i
                subplot(3, 5, 5+i);
                %fprintf('%s\n',files(ranked_ids(i)).name);
                imshow(imread(strcat(datasetDir, files(ranked_ids(i)).name)));
                title(files(ranked_ids(i)).name);    
            end
            name = files(ranked_ids(i)).name(1:end-4);
            fprintf(fid, '%s\n', name);
        end
        fclose(fid);
        
        %fprintf('name: %s\n image_name: %s',q_files(k).name(1:end-10), image_name(6:end));
        %% run script to compute mAP
        fprintf('computing mAP...\n');
        script_file = sprintf('%sTest.exe %s', groundtruthDir, groundtruthDir);
        script = [script_file, ...
            q_files(k).name(1:end-15), ... %q_files(k).name(1:end-10)
            sprintf(' %srank_list.txt', groundtruthDir),...
            ' >result\new-our-invfile\result-spm-5i-dict500-l2-200\', image_name(1:end), '_result.txt']; %q_files(k).name(1:end-10)
        system(script);
        if verbose==1
            pause;
        end
        
    end
    % clear inv file
    %ccvInvFileClean(inv_file);
end