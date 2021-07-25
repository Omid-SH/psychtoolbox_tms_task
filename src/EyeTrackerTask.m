% Clear the workspace and the screen

close all;
clc;
clearvars;
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
%% trigger config
ioObj = io64;
status = io64(ioObj);
% address = hex2dec('D100');          %standard LPT1 output port address
data_out=0;                                 %sample data value
%io64(ioObj,address,data_out);
try
    
%%
% Bina EyeTracker Initialize
[connected, BinaHandle] =  SetupETSocketUDP();
% BinaHandle =  SetupETSocket();
if(connected == 'fals')
    return;
end
WarnCalibMSG = warndlg('Please Calibrate the ET first');
while (ETIsCalibrated(BinaHandle) ~= 1)
  
end
close(WarnCalibMSG)

%%
% Write Video
ResVid = VideoWriter('Result.avi');
ResVid.FrameRate=20;
open(ResVid)
%%
% Get the screen numbers
screens = Screen('Screens');
Screen('Preference', 'SkipSyncTests', 1);
% Draw to the external screen if avaliable
screenNumber = min(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
inc = white - grey;

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Get the size of the on screen window
[screenXpixels, screenYpixels] =  Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


%% Get Locations

D=[pwd filesep 'pic.jpg'];
theImage = imread(D);
image{2}=theImage;

D=[pwd filesep 'rsz_text.jpg'];
theImage = imread(D);
image{1}=theImage;

%%
string_text='Are you ready for the experiment?\n\n(Press any key to start experiment)';
DrawFormattedText(window, string_text,'center', screenYpixels * 0.5 ,[0 0 0]);%[1 0.2 0.3]); %screenYpixels * 0.85 ,[1 0.2 0.3]
Screen('Flip', window); %%% make a buffer

KbWait;
%Start getting gaze from Bina
fwrite(BinaHandle, GetCommand(8));
for i=1:2
    imageTexture = Screen('MakeTexture', window, image{i});
    Screen('DrawTexture', window, imageTexture);
    Screen('Flip', window); % sends the image to the screen to show
    %io64(ioObj,address,i);
    im1=Screen('GetImage', window);
%      WaitSecs(30)
    tic
    tt = toc;
    while tt < 20
        im=im1;
%         for gi = 1: ResVid.FrameRate / 5 + 1
            GazePoints = ReadGaze(BinaHandle);
            x=mean(GazePoints(:,2));
            y=mean(GazePoints(:,1));
            if(x > 10 && y > 10)
                im(max(0,x-5):min(size(im,1),x+5),max(0,y-5):min(size(im,2),y+5),1)=255;
                im(max(0,x-5):min(size(im,1),x+5),max(0,y-5):min(size(im,2),y+5),2)=0;
                im(max(0,x-5):min(size(im,1),x+5),max(0,y-5):min(size(im,2),y+5),3)=0;
            end
%         end
        writeVideo(ResVid,im);
        tt = toc;

    end
            % Get the size of the on screen window
            [screenXpixels, screenYpixels] = Screen('WindowSize', window);
            
            % Query the frame duration
            ifi = Screen('GetFlipInterval', window);
            
            % Set up alpha-blending for smooth (anti-aliased) lines
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            
            % Setup the text type for the window
            Screen('TextFont', window, 'Ariel');
            Screen('TextSize', window, 36);
            
            % Get the centre coordinate of the window
            [xCenter, yCenter] = RectCenter(windowRect);
            
            % Here we set the size of the arms of our fixation cross
            fixCrossDimPix = 40;
            
            % Now we set the coordinates (these are all relative to zero we will let
            % the drawing routine center the cross in the center of our monitor for us)
            xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
            yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
            allCoords = [xCoords; yCoords];
            
            % Set the line width for our fixation cross
            lineWidthPix = 4;
            
            % Draw the fixation cross in white, set it to the center of our screen and
            % set good quality antialiasing
            Screen('DrawLines', window, allCoords,...
                lineWidthPix, black, [xCenter yCenter], 2);
            
            % Flip to the screen
            Screen('Flip', window);
                %io64(ioObj,address,0);               
im1=Screen('GetImage', window);
tic
tt = toc;
while (tt < 5)
    im=im1;
%     for gi = 1: ResVid.FrameRate / 5 + 1
        GazePoints = ReadGaze(BinaHandle);

        x=mean(GazePoints(:,2));
        y=mean(GazePoints(:,1));  
        if(x > 10 && y > 10 ) 
            im(max(0,x-5):min(size(im,1),x+5),max(0,y-5):min(size(im,2),y+5),1)=255;
            im(max(0,x-5):min(size(im,1),x+5),max(0,y-5):min(size(im,2),y+5),2)=0;
            im(max(0,x-5):min(size(im,1),x+5),max(0,y-5):min(size(im,2),y+5),3)=0;
        end
%     end
    writeVideo(ResVid,im); 
    tt = toc;

end

    
end
close(ResVid);
sca;
catch
   sca;  
end
fwrite(BinaHandle, GetCommand(5));
