function dict_words = dict_build(dict_file, features, num_words, dict_params)
%% Run AKM to build dictionary from features data

%dict_file:   file locations
%features:    sift features
%num_words:   number of centers (dictionary size)
%dict_params: dictionary parameters

%return:
% - dict_words: the dictionary
    fprintf('Building the dictionary:\n');
    %matlabpool('open',3);
    dict_words = ccvBowGetDict(features, [], [], num_words, 'flat', 'akmeans', ...
        [], dict_params);
    %matlabpool close;
    save(dict_file, 'dict_words');
    fprintf('saved: %s', dict_file);
end
