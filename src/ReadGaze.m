function GazePoints = ReadGaze(ETHandle)
GazePoints = [];
if(ETHandle.BytesAvailable == ETHandle.InputBufferSize)
    while(ETHandle.BytesAvailable > 0)
        fread(ETHandle, ETHandle.BytesAvailable);
    end
    GazePoints = [-1,-1,0,0];
    return;
end
%disp(ETHandle.BytesAvailable)
if(ETHandle.BytesAvailable > 0)
  while(ETHandle.BytesAvailable > 0)  
        GazePoints = [GazePoints; GetETParams(fread(ETHandle, 34))];
  end
% else
%     GazePoints = [-1,-1,0,0];
end
%disp(ETHandle.BytesAvailable)
return;