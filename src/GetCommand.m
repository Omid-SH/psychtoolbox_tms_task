function Command = GetCommand(input)
    str = dec2base(input,10,2);
    str(:) = str - 48;
    Command = reverse(str);
    
end