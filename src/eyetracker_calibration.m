function [GazePoints] = eyetracker_calibration (BinaHandle)
% this code is a 54 secs passiveviewing task for eyetracker calibration

%Percent = input('How far you want to show the fraktals? (0-100 percentage) ');
Percent = 40;

sca;
rng('shuffle');

% Setup PTB with some default values
PsychDefaultSetup(2);

screenNumber = max(Screen('Scree  ns'));
% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','ConserveVRAM', 16384);
[window1, rect] = PsychImaging('Openwindow', screenNumber, black, [], 32, 2,...
    [], [],  kPsychNeed32BPCFloat);

% Get the size of the on screen window1
[screenXpixels, screenYpixels] = Screen('windowSize', window1);

infix = 0;
fixWinSize = 100;

fixationWindow = [-fixWinSize -fixWinSize fixWinSize fixWinSize];
fixationWindow = CenterRect(fixationWindow, rect);

% Get the centre coordinate of the window1
[xc, yc] = RectCenter(rect);
slack = Screen('GetFlipInterval', window1)/2;

Screen(window1,'FillRect',black);
Screen('Flip', window1);

% Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 2);

% Get the size of the on screen window1
screen_size = get(0, 'ScreenSize');
Delta_X = floor(Percent * screen_size(3) / 200);

% % Left and right hand destination rectangles
[xCent, yCent] = RectCenter(rect);

% Fixation Settings
fixation_size = 30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

positions = [[xCent yCent]
             [xCent + Delta_X yCent]
             [xCent - Delta_X yCent]
             [xCent + Delta_X * cos(pi/4) yCent - Delta_X*sin(pi/4)]
             [xCent - Delta_X * cos(pi/4) yCent + Delta_X*sin(pi/4)]
             [xCent + Delta_X * cos(pi/4) yCent + Delta_X*sin(pi/4)]
             [xCent - Delta_X * cos(pi/4) yCent - Delta_X*sin(pi/4)]
             [xCent yCent + Delta_X]
             [xCent yCent - Delta_X]
            ];


% Start screen
Screen('TextSize', window1, 70);
DrawFormattedText(window1, 'Press a key to begin', 'center', 'center', white);
Screen('Flip',window1);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo
KbStrokeWait;
Screen('Flip',window1);

GazePoints=cell(9);
    
for t = 1:9
    pos = positions(t,:);
    Screen('DrawDots' ,  window1 , pos, fixation_size, [255,255, 255], [], 2);
    Screen('Flip', window1);
    
    % 6 secs pause and data gathering
    gz=[];
    tic 
    tt  = toc;
    while(tt < 6)
       gz = [gz;ReadGaze(BinaHandle)];
       tt = toc;
    end
    GazePoints{t}=gz;
    clear gz
end

sca;
clear Screen;

end