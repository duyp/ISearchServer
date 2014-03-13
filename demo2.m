function DEMO

% Author: Mohamed Aly <malaa@vision.caltech.edu>
% Date: October 6, 2010

% Bag of Words demo
bag_of_words();

%--------------------------------------------------------------------------
% Bag of Words 
%--------------------------------------------------------------------------
function bag_of_words()


% define some constants
fprintf('Creating features\n');
file = dir('C:\oxford-feat\feature.bin');
fid = fopen('C:\oxford-feat\feature.bin', 'r');
features = fread(fid, [128, file.bytes/(4*128)], 'float');
fclose(fid);
load('C:\oxford-feat\feat_info.mat');

num_images = length(files);
dim = 128;
num_features = size(features,2);

%labels = reshape(repmat(uint32(1:num_images), features_per_image, 1), [], 1)';

% build the dictionary
dict_type = 'akmeans'; % try also 'hkmeans'
fprintf('Building the dictionary: %s\n', dict_type);
%%
switch dict_type
  % create an AKM dictionary
  case 'akmeans'
    num_words = 100;
    num_iterations = 5;
    num_trees = 2;
    dict_params =  {num_iterations, 'kdt', num_trees};

  % create an HKM dictionary
  case 'hkmeans'
    num_words = 100;
    num_iterations = 5;
    num_levels = 2;
    num_branches = 10;
    dict_params = {num_iterations, num_levels, num_branches};
end; % switch

% build the dictionary
dict_words = ccvBowGetDict(features, [], [], num_words, 'flat', dict_type, ...
  [], dict_params);

%%
% get the words for the features: words is a cell array with an entry for
% every image, which contains the word id for every feature
fprintf('Computing the words\n');
dict = ccvBowGetWordsInit(dict_words, 'flat', dict_type, [], dict_params);
words = cell(1, num_images);
for i=1:num_images
  words{i} = ccvBowGetWords(dict_words, features(:,labels==i), [], dict);
end;
ccvBowGetWordsClean(dict);

%%
% create an inverted file for the images
fprintf('Creating and searching an inverted file\n');
if_weight = 'none';
if_norm = 'l1';
if_dist = 'l1';
inv_file = ccvInvFileInsert([], words, num_words);
ccvInvFileCompStats(inv_file, if_weight, if_norm);

% search for the first two
[ids dists] = ccvInvFileSearch(inv_file, words(1:4), if_weight, if_norm, ...
  if_dist, 5)

% clear inv file
ccvInvFileClean(inv_file);

% restore seed
ccvRandSeed(old_seed, 'restore');

%%
% Min-Hash LSH index
fprintf('Creating and searching a Min-Hash LSH index\n');
ntables = 3;
nfuncs = 2;
dist = 'jac';

% create and insert
lsh = ccvLshCreate(ntables, nfuncs, 'min-hash', dist, 0, 0, 0, 100);
ccvLshInsert(lsh, words, 0);

% search for first two
[ids dists] = ccvLshKnn(lsh, words, words(1:2), 5, dist)

% clear
ccvLshClean(lsh);

end % bag_of_words function

end % DEMO function