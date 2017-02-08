function [wordset, count] =  words_count(words, outFile)
    tic;
    col = size(words,2);
    
    w= [ ];
    disp('computing...');
    for i = 1:col
        i
        n = size(words{1,i}, 2);
        for j = 1:n
            word = words{1,i}(j);
            if ~ismember(word, words{1,i}(1:j-1))
                w = [w word];
            end
        end
    end
    
    fprintf('\ncounting...\n');
    w = sort(w);
    n = size(w,2);
    wordset = [];
    count = [];
    index = 0;
    i=1;
    while i <= n - 1
        wordset = [wordset w(i)];
        count = [count 1];
        index  = index +1;
        for j = i+1:n
            if w(j) ~= w(i)
                break;
            else
                %fprintf('[%d, %d]',i, j);
                count(index) = count(index) + 1;
                i = i+1;
            end
        end
        i = i+1;
    end
    toc;
    save(outFile, 'wordset', 'count');
    fprintf('Saved wordset and count to %s\n', outFile);
end
