function [features, features_per_image, feature_coords] = sift_load(featureDir, featureName)
%% load sift data
    %load(strcat(featureDir, featureName,'_info.mat'));
    %load(strcat(featureDir, featureName,'_coords.mat'));
    
    fprintf('Loading SIFT features:\n');
    feat_file = strcat(featureDir, featureName,'.bin');
    file = dir(feat_file);
    %features = zeros(128, file.bytes/(4*128), 'single');
    fid = fopen(feat_file, 'r');
    features = single(fread(fid, [128, file.bytes/(4*128)], '*single'));
    %features = int8(fread(fid, [128, file.bytes/(128)], '*int8'));
    fclose(fid);
    
end
