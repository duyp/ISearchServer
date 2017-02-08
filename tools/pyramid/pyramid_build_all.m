function pyramid_build_all(datasetDir, dataBaseDir, img_size, words, coords, beginImage, endImage, params)
%function pyramid_build_all(fnames, dataBaseDir, img_size, words, coords, beginImage, endImage, params) %temp 100k
tic;
fprintf('Building Spatial Pyramid\n\n');

fnames = dir(fullfile(datasetDir, '*.jpg'));
num_files = size(fnames,1);
imageFileList = cell(num_files,1);

for f = 1:num_files
	imageFileList{f} = fnames(f).name;
end

if(~exist('params','var'))
    params.maxImageSize = 1024;
    params.gridSpacing = 8;
    params.patchSize = 16;
    params.dictionarySize = 1000000;
    params.numTextonImages = 50;
    params.pyramidLevels = 3;
end
if(~isfield(params,'maxImageSize'))
    params.maxImageSize = 1024;
end
if(~isfield(params,'gridSpacing'))
    params.gridSpacing = 8;
end
if(~isfield(params,'patchSize'))
    params.patchSize = 16;
end
if(~isfield(params,'dictionarySize'))
    params.dictionarySize = 1000000;
end
if(~isfield(params,'numTextonImages'))
    params.numTextonImages = 50;
end
if(~isfield(params,'pyramidLevels'))
    params.pyramidLevels = 3;
end
if(~exist('canSkip','var'))
    canSkip = 1;
end

binsHigh = 2^(params.pyramidLevels-1);

fprintf('level: %d, dictSize: %d',params.pyramidLevels,params.dictionarySize);

%pyramid_all = zeros(length(imageFileList),params.dictionarySize*sum((2.^(0:(params.pyramidLevels-1))).^2));

if endImage > length(imageFileList)
    endImage = length(imageFilelist);
end
for f = beginImage:endImage
    f
    imageFName = imageFileList{f};
    [dirN base] = fileparts(imageFName);
    baseFName = fullfile(dirN, base);
    
    outFName = fullfile(dataBaseDir, sprintf('%s_pyramid_%d_%d.mat', baseFName, params.dictionarySize, params.pyramidLevels));
    outFNameCompressed = fullfile(dataBaseDir, sprintf('%s_pyramid_%d_%d_compressed.mat', baseFName, params.dictionarySize, params.pyramidLevels));
    
    %% get width and height of input image
    wid = img_size(2, f);
    hgt = img_size(1, f);
    
    pyramid = pyramid_compute(words{f},coords{f},wid,hgt,params);
    
    %K = hist_isect(pyramid, pyramid);
    
    [ids ,values] = compress_sparse_vector(pyramid);
    
    % save pyramid
    %save(outFName, 'pyramid');
    save(outFNameCompressed, 'ids', 'values');
    
end
toc;
end