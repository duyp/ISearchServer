function result = clientRequestImage(datasetDir,datasetFiles,client_tag,ids)
    list = strsplit(ids,',');
    n = length(list)
    result = cell(1,n);
    for i=1:n
        id = int32(str2double(list{i}));
        if strcmp(client_tag,'get-thumbnail')
            result{i} = base64file(strcat(datasetDir,'jpgThumbnails\',datasetFiles(id).name)); % jpgThumbnails\ for lower quality -> better speed
        elseif strcmp(client_tag,'get-full')
            result{i} = base64file(strcat(datasetDir,datasetFiles(id).name));
        elseif strcmp(client_tag,'get-preview')
            result{i} = base64file(strcat(datasetDir,'jpgPreview500\',datasetFiles(id).name));
        end
    end
end