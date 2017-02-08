 function getConnectOld(obj,id,datasetDir,datasetFiles)
     while 1
         fprintf('\tConnecting...\n');
         try
             tic;
             client = serverConnect(obj, id,'Server 2-1','get');
             toc;
         catch
             %error('Could not connect to any client\n');
             continue;
         end
         if length(client) ~= 4
             fprintf('Problem: %s\n\tRetrying...',client);
             continue;
         end
         clientId = client{1}; % client id
         clientTag = client{2}; % query tag
         name = client{3}; % client name
         queryContent = client{4};   % client query content (image or image id)
         fprintf('Connected to %s. Getting request images...!\n',name);
         try
            result = clientRequestImage(datasetDir,datasetFiles,clientTag,queryContent);
            if isempty(result{1})
                result{1} = 'NULL';
            end
         catch
            result = {'NULL'};
         end
         fprintf('Response to client...');
         tic;
         try
             message = serverRespond(obj,clientId,result);
             time = toc*1000;
             fprintf('Done! Message: %s (%.0fms)\n',message, time);
         catch
             printf('Problem sending result to client!');
             continue;
         end
     end
end