
function[sift, fsize, coord] = sift_image(imgPath)
%% compute SIFT features of an image
%imgPath:   image location

%return:
% - sift:           sift features (128 x nPoints)
% - fsize:          number of key points
% - featureCoord:   the coordinate of points (2 x nPoints)

    %% Convert image to single precision gray scale image    
    I = im2single(rgb2gray(imread(imgPath)));
    
    %% Use detector Hessian Affine to detect words
    [frame, sift] = vl_covdet(I, 'method', 'Hessian', 'EstimateAffineShape', true);
    coord = [frame(1, :); frame(2, :)];
    fsize = size(sift,2);
end