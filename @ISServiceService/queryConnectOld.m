 function queryConnectOld(obj,tag,id,datasetDir,datasetFiles,dict_words,inv_file,dict_structure)
     while 1
         fprintf('\tConnecting...\n');
         try
             tic;
             client = serverConnect(obj, id,'Server 2-1',tag);
             toc;
         catch
             %error('Could not connect to any client\n');
             continue;
         end
         if length(client) ~= 4
             fprintf('Problem: %s\n\tRetrying...',client);
             continue;
         end
         clientId = client{1};
         clientTag = client{2};
         name = client{3};
         queryContent = client{4};
         fprintf('Connected to %s. Querying...!\n',name);
         tic;
         try
             if strcmp(tag,'query')
                 result = clientQueryNormal(queryContent,dict_words,inv_file,dict_structure,datasetDir,datasetFiles,50, 18);
             elseif strcmp(tag,'get')
                 fprintf('Getting image: %s ...',queryContent);
                 tic;
                 result = clientRequestImage(datasetDir,datasetFiles,clientTag,int32(str2double(queryContent)));
                 time = toc*1000;
                 fprintf('Done! Result size: %.2fkB (%.0fms)\n',length(result{1})/1024,time);
             end
         catch
             fprintf('Query problem !\n');
             continue;
         end
         toc;
         fprintf('Response to client...');
         tic;
         message = serverRespond(obj,clientId,result);
         time = toc*1000;
         fprintf('Done! Message: %s (%.0fms)\n',message, time);
     end
end