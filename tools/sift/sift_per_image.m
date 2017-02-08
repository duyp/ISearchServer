
%% compute SIFT features of an image
%imgPath: image location path
function[sift, fsize] = sift_per_image(imgPath)
    %% Convert image to single precision gray scale image    
    I = im2single(rgb2gray(imread(imgPath)));
    
    %% Use detector Hessian Affine to detect words
    [frame, sift] = vl_covdet(I, 'method', 'Hessian', 'EstimateAffineShape', true);
    fsize = size(sift,2);
end