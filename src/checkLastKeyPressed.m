function out = checkLastKeyPressed(in, keys)
% checkLastKeyPressed function the last time in in(keys)
    maxx = -1;
    out = 1;
    for i = keys 
        if(in(i) > maxx)
            maxx = in(i);
            out = i;
        end
    end
end
