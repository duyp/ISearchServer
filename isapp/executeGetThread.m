function executeGetThread(id, datasetDir,datasetFiles)
    service = javaObjectEDT('com.uit.instancesearch.services.ISServiceProxy');
    while 1
        try
            %tic;
            %getting client query informations
            client = cell(service.serverConnect(id,'Server 2 (get)','get'));
            %toc;
        catch
            %error('Could not connect to any client\n');
            continue;
        end
        if length(client) ~= 4
            %fprintf('Problem: %s\n\tRetrying...',client{1});
            continue;
        end
        clientId = client{1};       % client id
        clientTag = client{2};      % query tag
        %name = client{3};           % client name
        queryContent = client{4};   % client query content (image or image id)
        fprintf('Thread %s: connected to %s (%s)...', id, clientId, queryContent);
        tic;
        try
            result = clientRequestImage(datasetDir,datasetFiles,clientTag,queryContent);
            if isempty(result{1})
                result{1} = 'NULL';
            end
        catch
            result = {'NULL'};
        end
        service.serverRespond(clientId,result);
        time = toc * 1000;
        fprintf('done (%dms)\n', int32(time));
    end
end