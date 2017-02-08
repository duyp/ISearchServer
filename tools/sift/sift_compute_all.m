function[features, features_per_image, coords] = sift_compute_all(datasetDir, featureDir, featureName)
%% compute SIFT features for all images (.jpg files) in dataset directory. Use 

%datasetDir:                directory contains dataset
%featuresDir:               directory for saving data
%featureName:               feature name

%returns:
% - features:               sift features
% - features_per_image:     number of features per image
    files = dir(fullfile(datasetDir, '*.jpg'));
    nfiles = length(files);
    features = [];
    coords = [];
    features_per_image = zeros(1, nfiles);
    
    fprintf('Computing SIFT features:\n');
    parpool('local',4);
    tic;
    %for i=1:1000:nfiles
    for i=1:1000:nfiles
        eIdx = i+1000-1;
        if eIdx > nfiles
            eIdx = nfiles;
        end
        features = [];
        parfor k=i:eIdx
            k
            imgPath = strcat(datasetDir, files(k).name);
            %compute sift feature
            [sift, features_per_image(k), coord] = sift_image(imgPath);
            features = [features sift];
            coords = [coords coord];
        end
        
        fprintf('Saving %d features....',length(features));
        f = strcat(featureDir,featureName,num2str(i),'-',num2str(eIdx),'.bin');
        fprintf(f);
        %save SIFT features
        fid = fopen(f, 'w');
        fwrite(fid, features, 'single');
        fclose(fid);
        fprintf('\ndone!\n');
        
    end
    
        %fprintf('Saving %d features....',length(features));
        %fprintf(strcat(featureDir,featureName,'.bin'));
        %%save SIFT features
        %fid = fopen(strcat(featureDir,featureName,'.bin'), 'w');
        %fwrite(fid, features, 'single');
        %fclose(fid);
        %fprintf('\ndone!\n');
        
    save(strcat(featureDir, featureName,'_coords.mat'), 'coords');
    save(strcat(featureDir, featureName,'_info.mat'), 'features_per_image', 'files');
    toc;
    delete(gcp);
end