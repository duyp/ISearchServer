%connect to web service, retrival client query info, query processing
%return result to web service
% tag: server tag (query | get)
% id: server id
% datasetDir: dataset directory
% datasetFiles: dataset files, obtained by dir(fullfile(datasetDir))
% dict: BoW dictionary
% inv: inverted file index (proposed - multi level inverted index)
% dict_structure: obtained by ccvBowGetDict(...)
% pparams: pyramid params (pyramidLevel and dictionarySize)
function startConnect(tag,id,datasetDir,datasetFiles,dict,inv,dict_structure,pparams)
    
    % initial service connection
    service = javaObjectEDT('com.uit.instancesearch.services.ISServiceProxy');
    % connection loop: Ctrl-C to terminate
    while 1
        fprintf('\tConnecting...\n');
        try
            %tic;
            %getting client query informations
            client = cell(service.serverConnect(id,'Server 2-1',tag));
            %toc;
        catch
            %error('Could not connect to any client\n');
            continue;
        end
        if length(client) ~= 4
            fprintf('Problem: %s\n\tRetrying...',client{1});
            continue;
        end
        clientId = client{1};       % client id
        clientTag = client{2};      % query tag
        name = client{3};           % client name
        queryContent = client{4};   % client query content (image or image id)
        fprintf('Connected to %s. Querying...!\n',name);
        %tic;
        %try
            if strcmp(tag,'query')
                % query
                result = clientQuery(queryContent,dict,inv,dict_structure,pparams,datasetDir,datasetFiles,50,15);
            elseif strcmp(tag,'get')
                %fprintf('Getting image(s): %s ...',queryContent);
                tic;
                result = clientRequestImage(datasetDir,datasetFiles,clientTag,queryContent);
                time = toc*1000;
                fprintf('%s done! result size: %.2fkB (%.0fms)\n',id,length(result{1})/1024,time);
            end
        if isempty(result{1})
            result{1} = 'NULL';
        end
        %catch
        %    fprintf('Query problem !\n');
        %    continue;
        %end
       % toc;
        fprintf('Response to client...');
        tic;
        message = service.serverRespond(clientId,result); %return java.lang.String, use char(str..) to convert to matlab string
        time = toc*1000;
        fprintf('Done! Message: %s (%.0fms)\n',char(message), time);
    end
end