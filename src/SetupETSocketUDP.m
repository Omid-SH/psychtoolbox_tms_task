function [Success, ETHandle] = SetupETSocketUDP()

%% Initializing Connection to the Server


if ~exist('Connection1','var')
    Connection1 = udp('127.0.0.1', 6060);
    Connection1.Timeout = 0.1;
    Connection1.BytesAvailableFcn = @CheckRecievedCommands_B;
    
    set(Connection1,'InputBufferSize',20000);
    set(Connection1,'OutputBufferSize',20000);
    
end

% while ~strcmp(Connection1.Status, 'open')
% end

fopen(Connection1);

% send data to signal server which client connected.
 fwrite(Connection1, GetCommand(2));

pause(0.1);
% check server availabality... 
a = ETIsCalibrated(Connection1);
if(a == -1)
    disp('Server not found')
    ETHandle = Connection1;
    Success = 'fals';
    return;
end
%

% if ~exist('Connection2','var')
%     Connection2=udp('192.168.0.1', 'RemotePort', 6025, 'LocalPort', 6022);
%     Connection2.Timeout=0.1;
%     Connection2.BytesAvailableFcn=@CheckRecievedCommands_B;
%     set(Connection2,'InputBufferSize',64);
%     set(Connection2,'OutputBufferSize',64);
% else
%     fclose(Connection2);
% end
% 
% if strcmp(Connection2.Status, 'closed')
%     fopen(Connection2);
% end
%% Check the Connection

% BlackrockPresent=0;
% while (BlackrockPresent==0)
%     fprintf(Connection1,Presenter);
%     pause(1);
%     disp('Blackrock Not Running!');
%     if strcmp(NewCommand,'Cheetah')
%         BlackrockPresent=1;
%     end
% end

%%%%%%%%%%%%
clc
Success = 'true';
disp('Connected to Server!')
ETHandle = Connection1;

end