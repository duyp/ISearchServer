function [ words, features_per_image ] = load_word_ox( wordDir, wordFileName )
%LOAD_WORD_OX Load oxford 5k words from oxford site
files = dir(fullfile(wordDir, '*.txt'));
nfiles = length(files);
words = cell(1,nfiles);
features_per_image = zeros(1,nfiles); 
parpool('local',4);
tic;
for k = 1:1000:nfiles
    eIdx = k+1000-1;
        if eIdx > nfiles
            eIdx = nfiles;
        end
    parfor i = k:eIdx
        i
        fid = fopen(strcat(wordDir,files(i).name));
        line = fgetl(fid); %ignore first line
        features_per_image(i) = str2double(fgetl(fid));
        fprintf('file %d contains %d words',i,features_per_image(i));
        %words{i} = zeros(1,features_per_image(i));
        %line = fgetl(fid);
        %while ischar(line)
        %    line = strsplit(line);
        %    w = str2double(line(1)); %first is word id
        %    words{i} = [words{i} w];
        %    line = fgetl(fid);
        %end
        fclose(fid);
    end
end

wordFile = strcat(wordDir,wordFileName);
save(wordFile, 'words');
toc;
delete(gcp);
end
