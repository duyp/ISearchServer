function img_size = extract_imgsize(imgDir)
    files = dir(fullfile(imgDir, '*.jpg'));
    nfiles = length(files);
    img_size = zeros(2, nfiles);
    for i = 1: nfiles
        i
       imgPath = strcat(imgDir, files(i).name);
       [img_size(1, i), img_size(2, i), ~] = size(imread(imgPath));
    end
    save(strcat(imgDir, 'img_size.mat'), 'img_size');
end