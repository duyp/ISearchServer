function startGetServerOld(obj,id,datasetDir,datasetFiles)
%parpool('local',1);
%parfor i = 1:1
    getConnectOld(obj,10+id,datasetDir,datasetFiles);
%end
end

