function time = query_groundtruth(dict_words, inv_file, dict_structure, groundtruthDir, datasetDir, params)
%% Query groundtruth images: compute mean Average Precision (mAP) for dataset

% dict_words:               dictionary
% inv_file:                 inverted file index 
% dict_structure:           dict structure
% datasetDir:               dataset directory

%returns: after ranking, this function will run script to compute mAP from result directory

    fprintf('query...');
    verbose=1;
    files = dir(fullfile(datasetDir, '*.jpg'));
    q_files = dir(fullfile(groundtruthDir, '*query.txt'));
    disp(length(q_files));
    ntop = 0;
    
    k = 0;
    % load query image
    %while k >= 0
    time = zeros(1,length(q_files));
    for k = 1:length(q_files)
        %k = input('Nhap k: \n');
        fprintf('\nQuerying file: %s\n',q_files(k).name);
        [image_name, points] = groundtruth_extractinfo(strcat(groundtruthDir, q_files(k).name));
        file = strcat(datasetDir, image_name(6:end), '.jpg');  %gt55
        %file = strcat(datasetDir, image_name(1:end), '.jpg');
        %% compute rootSIFT
        I = im2single(rgb2gray(imread(file)));
        [root_sift, ~] = compute_rootsift_image(I);
        
        %% compute words
        q_words = cell(1,1);
        q_words{1} = ccvBowGetWords(dict_words, root_sift, [], dict_structure);
        
        %remove stop words
        %q_words{1} = remove_stop_words(q_words{1},words_removed);

        if (~exist('params', 'var'))
            params.if_weight = 'tfidf';
            params.if_norm = 'l1';
            params.if_dist = 'l1';
        end
        
        %[ids, dists] = ccvInvFileSearch(inv_file, q_words(1), params.if_weight, params.if_norm, params.if_dist, ntop);
        tic;
        [ids, ~] = ccvInvFileSearch(inv_file, q_words(1), params.if_weight, params.if_norm, params.if_dist, ntop);
        time(k) = toc;
        
        % visualize
        if verbose ==1
            close all;
            hold on; subplot(3,5,3); imshow(I);
            title(image_name(1:end));
        end
        
        fid = fopen(strcat(groundtruthDir, 'rank_list.txt'), 'wt');
        for i=1:size(ids{1},2)
                    % Show only 10 highest score images
            if verbose == 1 && i<=10
                %i
                subplot(3, 5, 5+i);
                fprintf('%s\n',files(ids{1}(i)).name);
                imshow(imread(strcat(datasetDir, files(ids{1}(i)).name)));
                title(files(ids{1}(i)).name);    
            end
            
            fprintf(fid, '%s\n', files(ids{1}(i)).name(1:end-4));
            
        end
        fclose(fid);
        
        %fprintf('name: %s\n image_name: %s',q_files(k).name(1:end-10), image_name(6:end));
        
        fprintf('computing mAP...\n');
        script_file = sprintf('%sTest.exe %s', groundtruthDir, groundtruthDir);
        script = [script_file, ...
            q_files(k).name(1:end-15), ... %q_files(k).name(1:end-10)
            sprintf(' %srank_list.txt', groundtruthDir),...
            ' >result\new-our-invfile\result-30i-5top-18.5-200\', image_name(1:end), '_result.txt']; %q_files(k).name(1:end-10)
        system(script);
        
        if verbose==1
            pause;
        end
        
    end
%    % clear inv file
    ccvInvFileClean(inv_file);
end

%% remove stop words from query image words
function q_words = remove_stop_words(q_words, words_removed)
    j = 1;
    while j <= size(q_words, 2)
       if ismember(q_words(j), words_removed)
           q_words(j) = [];
       else j = j+ 1;
       end;
    end
end
