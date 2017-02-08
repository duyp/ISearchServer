function words = words_remove_stopw(words, coords, wordset, count, percent, mod, words_file, coords_file)
    tic;
    save(words_file, 'words');
    save(coords_file, 'coords');
    
    A = [count; wordset];
    A = rot90(A);
    A = sortrows(A);
    num_words = size(wordset, 2);
    num_rm = percent*num_words/100;

    word_column = uint8(2);
    num_images = size(words,2);
    
    removed_words = [];
    
    %remove bottom words count
    if strcmp(mod,'all') || strcmp(mod,'bottom')
        removed_words = [removed_words A(1:num_rm, word_column)];
    end
    %remove top words,
    if strcmp(mod,'all') || strcmp(mod,'top')
        removed_words = [removed_words A(num_words - num_rm + 1:num_words, word_column)];
    end
    
    fprintf('removing words...\n');
    for i = 1: num_images
        i
        j = 1;
        while j <= size(words{i}, 2)
           if ismember(words{i}(j), removed_words)
               words{i}(j) = [];
               coords{i}(:,j) = [];
           else j = j + 1;
           end;
        end
    end       
   
    %save(words_removed_file,'removed_words');
    fprintf('saving words and coords:\n%s\n%s) !', words_file, coords_file);
    save(words_file, 'words');
    save(coords_file, 'coords');
    
    toc;
end
