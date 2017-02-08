function startQueryServer(nthread, dict, inv, dict_structure, pparams, datasetDir, datasetFiles)
    parfor i = 1:nthread
        fprintf('Executing thread %d\n', i);
        executeQueryThread(num2str(i), dict, inv, dict_structure, pparams, datasetDir, datasetFiles);
    end
end