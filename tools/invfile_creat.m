
% create an inverted file for the images
function inv_file = invfile_creat(words, num_words)
    fprintf('Creating and searching an inverted file\n');
    if_weight = 'tfidf';
    if_norm = 'l1';
    if_dist = 'l1';
    inv_file = ccvInvFileInsert([], words, num_words);
    ccvInvFileCompStats(inv_file, if_weight, if_norm);
    %save('inverted_file.mat', 'if_weight', 'if_norm', 'if_dist', 'inv_file');
end