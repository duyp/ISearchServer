function dist = dist_nhi(i1, v1, i2,v2)
    n1 = length(i1);
    n2 = length(i2);
    i = 1; j = 1;
    sum = 0;
    while i <= n1 && j <= n2
        index1 = i1(i);
        index2 = i2(j);
        if index1 == index2
            d = v1(i);
            if v1(i) > v2(j)
                d = v2(j);
            end
            sum = sum + d;
            i = i+1;
            j = j+1;
        elseif index1 < index2
            i = i+1;
        elseif index1 > index2
            j = j+1;
        end
        %fprintf('%f ',sum);
    end
    dist = sum;
end