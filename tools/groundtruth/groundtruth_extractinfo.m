function [image_name, points] = groundtruth_extractinfo(file_name)
    fid = fopen(file_name, 'r');
    str = fgetl(fid);
    [image_name, remain] = strtok(str, ' ');
    fclose(fid);
    
    numbers = str2num(remain);
    points.x1 = numbers(1);
    points.y1 = numbers(2);
    points.x2 = numbers(3);
    points.y2 = numbers(4);
    
    
    %numbers = str2num(remain);
%     points.x1 = 0; %numbers(1);
%     points.y1 = 0; %numbers(2);
%     points.x2 = 0; %numbers(3);
%     points.y2 = 0; %numbers(4);
end