function coords = coords_compute(coords_file, features_per_image, feature_coords, num_images)
%% compute sparse frequency vector

%coords_file:           file location
%feature_coords:        coordinates of features
%num_images:            number of images in dataset
%features_per_image:    feature size of each image

%returns:
% - coords:              nImage x nCoords per image

    fprintf('Computing coords\n');
    coords = cell(1, num_images);
    for i=1:num_images   
        i
        if i==1
            bIndex = 1;
        else
            bIndex = sum(features_per_image(1:i-1))+1;
        end
        eIndex = bIndex + features_per_image(i)-1;
        coords{i} = feature_coords(:, bIndex:eIndex);
    end;
    save(coords_file, 'coords');

end

