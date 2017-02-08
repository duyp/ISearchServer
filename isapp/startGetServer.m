function startGetServer(datasetDir, nThread)
    parfor i = 1:nThread
        fprintf('Executing thread %d\n', i);
        execute(num2str(i), datasetDir, dir(fullfile(datasetDir,'*.jpg')));
    end
end

function execute(id, datasetDir,datasetFiles)
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
        %fprintf('Thread %s: connected to %s (%s)...', id, clientId, queryContent);
        try
            result = clientRequestImage(datasetDir,datasetFiles,clientTag,queryContent);
            if isempty(result{1})
                result{1} = 'NULL';
            end
        catch
            result = {'NULL'};
        end
        service.serverRespond(clientId,result);
        %fprintf('done\n');
    end
end