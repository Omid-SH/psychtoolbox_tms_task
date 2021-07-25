function Params = GetETParams(input)
    if(length(input) < 34)
        Params = [-1,-1,-1,-1];
        return;
    end
    Params = typecast(uint8(input(3:10)), 'double');
    Params = [Params, typecast(uint8(input(11:18)), 'double')];
    Params = [Params, double(typecast(uint8(input(19:26)), 'int64'))];
    Params = [Params, typecast(uint8(input(27:34)), 'double')];
end