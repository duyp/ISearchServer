function dist = dist_l2(i1, v1, i2,v2)
    n1 = length(i1);
    n2 = length(i2);
    i = 1; j = 1;
    sum = 0;
    while i <= n1 && j <= n2
        index1 = i1(i);
        index2 = i2(j);
        if index1 == index2
            d = v1(i) - v2(j); d = d*d;
            i = i+1;
            j = j+1;
        elseif index1 < index2
            d = v1(i) * v1(i);
            i = i+1;
        elseif index1 > index2
            d = v2(j) * v2(j);
            j = j+1;
        end
        sum = sum + d;
    end
    
    while (i <= n1)
        sum = sum + v1(i) * v1(i);
        i = i+1;
    end
    
    while (j <= n2)
        sum = sum + v2(j) * v2(j);
        j = j+1;
    end
    
    dist = sqrt(sum);
end