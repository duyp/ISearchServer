%% Query images
function query(dict_words, inv_file, dict, files, datasetDir)
    fprintf('query...');
    verbose=0;
    q_files = dir(fullfile('C:\oxford-groundtruth', '*query.txt'));
    disp(length(q_files));
    ntop = 0;
    
    k = 0;
    % load query image
    %while k >= 0
    for k = 1:length(q_files)
        %k = input('Nhap k: \n');
        fprintf('querying file: %s\n',q_files(k).name);
        fid = fopen(strcat('C:\oxford-groundtruth\', q_files(k).name), 'r');
        str = fgetl(fid);
        [image_name, remain] = strtok(str, ' ');
        fprintf('Image_name: %s -- Remain: %s\n', image_name, remain);
        fclose(fid);
        numbers = str2num(remain);
        x1 = numbers(1);
        y1 = numbers(2);
        x2 = numbers(3);
        y2 = numbers(4);
        file = strcat('C:\oxford-images\', image_name(6:end), '.jpg');
        
        %compute rootSIFT
        I = im2single(rgb2gray(imread(file)));
        root_sift = compute_rootsift_image(I, x1, y1, x2, y2);
        
        % Test on an image
        fprintf('Test on image...\n\n');
        q_words = cell(1,1);
        q_words{1} = ccvBowGetWords(dict_words, root_sift, [], dict);
        if_weight = 'tfidf';
        if_norm = 'l1';
        if_dist = 'l1';
        [ids dists] = ccvInvFileSearch(inv_file, q_words(1), if_weight, if_norm, if_dist, ntop);

        % visualize
        if verbose ==1
            close all;
            hold on; subplot(3,5,3); imshow(I);
            title(image_name(6:end));
        end
        fid = fopen('c:\oxford-groundtruth\rank_list.txt', 'wt');
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
        
        script = ['c:\oxford-groundtruth\Test.exe c:\oxford-groundtruth\', ...
            q_files(k).name(1:end-10), ... %q_files(k).name(1:end-10)
            ' c:\oxford-groundtruth\rank_list.txt',...
            ' >result\', image_name(6:end), '_result.txt']; %q_files(k).name(1:end-10)
        system(script);
        if verbose==1
            pause;
        end
        
    end
    % clear inv file
    ccvInvFileClean(inv_file);
end