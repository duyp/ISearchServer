function [words, dict_structure] = words_load(words_file, dict_words, dict_params)
%% Load words
% load words (computed) from file

%words_file:            file location
%dict_words:            dictionary
%dict_params:           dictionary parameters (dict_params =  {num_iterations, 'kdt', num_trees})

%returns:
% - words:              the words of all dataset
% - dict_structure:     dictionary structure (ccvBowGetWordsInit)

    fprintf('Words init...\n');
    dict_structure = ccvBowGetWordsInit(dict_words, 'flat', 'akmeans', [], dict_params);
    fprintf('Loading the words...\n');
    load(words_file);
end