function [wordset, count] = words_count_rm_stopw(wordset, count, percent, mod)
    tic;
    A = [count; wordset];
    A = rot90(A);
    A = sortrows(A);
    num_words = size(wordset, 2);
    num_rm = percent*num_words/100;

    word_column = uint8(2);
    count_column = uint8(1);
    
    %remove bottom words count
    if strcmp(mod,'all') || strcmp(mod,'bottom')
        wordset = rot90(A(num_rm+1:num_words, word_column));
        count   = rot90(A(num_rm+1:num_words, count_column));
    end
    %remove top words,
    if (strcmp(mod,'all') || strcmp(mod,'top'))
        wordset = rot90(A(1:num_words - num_rm, word_column));
        count   = rot90(A(1:num_words - num_rm, count_column));
    end
    toc;
end
