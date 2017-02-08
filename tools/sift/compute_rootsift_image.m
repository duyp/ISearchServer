function [root_sift, coord] = compute_rootsift_image(I, points)

    % compute rootSIFT features
    %fprintf('Extracting features...\n');
    [frame, sift] = vl_covdet(I, 'method', 'Hessian', 'estimateAffineShape', true);
    if(~exist('points','var'))
        [root_sift, coord] = rootsift(sift, frame);
        return;
    end
    idx = zeros(1, size(frame, 2));
    for i=1:size(frame,2)
         if frame(1,i) <= points.x2 && frame(1,i) >= points.x1 && ...
                 frame(2,i) <= points.y2 && frame(2,i) >= points.y1
            idx(i) = 1;
         end
    end
    [root_sift, coord] = rootsift(sift, frame, idx);
end

function [root_sift, coord] = rootsift(sift, frame, idx)
    nfeat = size(sift, 2);
    if (~exist('idx', 'var'))
       idx = zeros(1, nfeat);
       idx(:) = 1;
    end
    
    root_sift = zeros(128, sum(idx));
    c=1;
    x = [];
    y = [];
    for i=1:nfeat
        if idx(i)==1
            root_sift(:,c) = sqrt(sift(:,i) / sum(sift(:,i)));
            c=c+1;
            x = [x frame(1, i)];
            y = [y frame(2, i)];
        end
    end
    coord = [x; y];
end