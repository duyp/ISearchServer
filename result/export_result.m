%[text, data] = xlsread('result.xlsx');
r_files = dir(fullfile('*.txt'));
acc = [];
data = cell(1+size(r_files,1),3);
data{1,1} = 'STT';
data{1,2} = 'Query image';
data{1,3} = 'Accuracy';

for i=1:length(r_files)
    fid = fopen(r_files(i).name, 'r');
    acc = [acc fscanf(fid, '%f')];
    fclose(fid);
    data{1+i, 1} = num2str(i);
    data{1+i, 2} = r_files(i).name(1:end-11);
    data{1+i, 3} = acc(end);
end
mean(acc)

xlswrite('result.xlsx', data);