function test()
    %javaaddpath('E:\InstanceSearch-UIT\Instance-Search-Server\ISService.jar');
    datasetDir =    'E:/InstanceSearch-UIT/dataset/oxbuild_images/';
    datasetFiles = dir(fullfile(datasetDir,'*.jpg'));
    %featureDir =    'E:/InstanceSearch-UIT/dataset/oxbuild_features/';
    dictionaryDir = 'E:/InstanceSearch-UIT/dataset/oxbuild_dictionaries/';
    wordDir =       'E:/InstanceSearch-UIT/dataset/oxbuild_words/';
    datasetFiles = dir(fullfile(datasetDir,'*.jpg'));
    
    dict_name = 'dict_oxford5k_1M_20i';
    words_name = 'word-oxford5k-2700-1M-20i';
    
    dict_params =  {20, 'kdt', 8};
    
    dict_file = strcat(dictionaryDir, dict_name,'.mat');
    load(dict_file);
    
    words_file = strcat(wordDir, words_name,'.mat');
    load(words_file);
    dict_structure = ccvBowGetWordsInit(dict_words, 'flat', 'akmeans', [], dict_params);
    num_words = 1000000;
    inv_file = invfile_creat(words, num_words);
    query_groundtruth_norm(dict_words, inv_file, dict_structure, datasetDir);
    obj = ISServiceService;
    %startQueryServerOld(obj,tag,datasetDir,datasetFiles,dict_words,inv_file,dict_structure)
    %ccvInvFileClean(inv_file);
end