function [words, dict_structure] = words_compute(words_file, coords_file, ...
                                                features, features_per_image, feature_coords, ...
                                                dict_words, dict_params, num_images)
%% compute sparse frequency vector

%words_file:            file location
%features:              sift features
%dict_words:            dictionary
%dict_params:           dictionary parameters
%num_images:            number of images in dataset
%features_per_image:    feature size of each image

%returns:
% - words:              nImage x nWords per image
% - dict_structure:     dictionary structure (ccvBowGetWordsInit)

    fprintf('Words init...\n');
    dict_structure = ccvBowGetWordsInit(dict_words, 'flat', 'akmeans', [], dict_params);
    
    fprintf('Computing words\n');
    words = cell(1, num_images);
    coords = cell(1, num_images);
    for i=1:num_images
        i
        if i==1
            bIndex = 1;
        else
            bIndex = sum(features_per_image(1:i-1))+1;
        end
        eIndex = bIndex + features_per_image(i)-1;
        words{i} = ccvBowGetWords(dict_words, features(:, bIndex:eIndex), [], dict_structure);
        coords{i} = feature_coords(:, bIndex:eIndex);
    end;
    save(words_file, 'words');
    save(coords_file, 'coords');
    
    %fprintf('Computing sparse frequency vector\n');
    %dict = ccvBowGetWordsInit(dict_words, 'flat', 'akmeans', [], dict_params);
    %words = ccvBowGetWords(dict_words, root_sift, [], dict);
    %ccvBowGetWordsClean(dict);
end

