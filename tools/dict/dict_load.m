function dict_words = dict_load(dict_file)
%% Load the dictionary

%dict_file: file locations

%return:
% - dict_words: dictionary

    fprintf('Loading the dictionary...\n');
    load(dict_file);
end
