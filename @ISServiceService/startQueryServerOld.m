function startQueryServerOld(obj,tag,datasetDir,datasetFiles,dict_words,inv_file,dict_structure)
%parpool('local',2);
%parfor i = 1:2
    queryConnectOld(obj,tag,1,datasetDir,datasetFiles,dict_words,inv_file,dict_structure)
%end
end

