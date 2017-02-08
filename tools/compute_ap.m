function ap = compute_ap(resultDir)
    files = dir(fullfile(resultDir, '*result.txt'));

    sum_ap = 0;
    
    for i = 1:length(files)
        fid = fopen(strcat(resultDir, files(i).name), 'r');
        value = str2double(fgetl(fid));
        sum_ap = sum_ap + value;
        fclose(fid);
    end
    
    ap = sum_ap / length(files);
end