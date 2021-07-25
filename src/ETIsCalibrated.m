function IsCalib = ETIsCalibrated(ETHandle)
    fwrite(ETHandle, GetCommand(2));
    fd = fread(ETHandle, 34);
    pr = GetETParams(fd);
    IsCalib = pr(1);
end