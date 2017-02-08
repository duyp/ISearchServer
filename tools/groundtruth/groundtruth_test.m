function  groundtruth_test(dict_words, words, dict_structure)
    clear all; close all;

    datasetDir = 'C:\oxford-images\';
    featureDir = 'C:\oxford-feat\';

    num_words = 1000000;
    num_iterations = 5;

    end_name = '_5top';
    
    dict_name = strcat('dict_oursift_',num2str(num_iterations));
    words_name = strcat('words_oursift_',num2str(num_iterations));
    words_name = strcat(words_name, end_name);
    files = dir(fullfile(datasetDir, '*.jpg'));

    inv_file = invfile_creat(words, num_words);
    words_removed_file = strcat(featureDir,words_name,'_removed.mat');
    load(words_removed_file);
    query(dict_words, inv_file, dict_structure, removed_words, files, datasetDir);
        
    %end
end

