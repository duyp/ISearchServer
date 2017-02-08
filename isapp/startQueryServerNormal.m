function startQueryServerNormal(nthread, dict_words, inv_file, dict_structure, datasetDir, datasetFiles)
    parfor i = 1:nthread
        fprintf('Executing thread %d\n', i);
        executeQueryThreadNormal(num2str(i), dict_words, inv_file, dict_structure, datasetDir, datasetFiles);
    end
end