%% Bina EyeTracker Initialize
[connected, BinaHandle] =  SetupETSocketUDP();
if(connected == 'false')
    return;
end
WarnCalibMSG = warndlg('Please Calibrate the ET first');
while (ETIsCalibrated(BinaHandle) ~= 1)
  
end
close(WarnCalibMSG)

%% Initialize task

%%

%% Start Get gaze sending command 8 ti ET.............
fwrite(BinaHandle, GetCommand(8));

%% Start Task main loop and show your stimulus and handle gaze

    GazePoints = ReadGaze(BinaHandle);
%%

%% Disconnect from ET...