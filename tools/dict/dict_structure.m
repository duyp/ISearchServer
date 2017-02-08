%% get structure
%dict_words: dictionary
function dict_structure = dict_structure(dict_words,num_iterations)
    dict_params =  {num_iterations, 'kdt', 8};
    dict_structure = ccvBowGetWordsInit(dict_words, 'flat', 'akmeans', [], dict_params);
end