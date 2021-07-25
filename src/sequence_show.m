% This code is for showing sequence generated before in psychtoolbox
% clear; clc

% Code, Available equipments, and input data setup

% Input data setting

%i_index = input('Subject i index? ');
i_index = 1;
%j_index = input('Subject j index? ');
j_index = 1;
%k_index = input('Subject k index? ');
k_index = 1;
%l_index = input('Subject k index? ');
l_index = 1;
%h_index = input('Subject k index? ');
h_index = 1;
%data_index = input('Subject dataset index? ');
data_index = 1;
%Day = input('Select your Day? ');
Day = 9;

% Code setting

%Show_feedback_force = input("Do you want to show answer in situation that user do a wrong thing(force trial)? [0:false, o.w:true] ");
Show_feedback_force = 1;
%Show_feedback_choice_2 = input('Do you want to show feedback in situation that user do response fast(choice2 trial)? [0:false, o.w:true] ');
Show_feedback_choice_2 = 1;
%Percent = input('How far you want to show the fraktals? (0-100 percentage) ');
Percent = 40;
%ImageSize = input('Fraktal Size? (in pixels) ');
ImageSize = 200;
%Money_Step = input('Input your reward money. (It should be 1000, 2000, 3000, ... Tomans) ');
Money_Step = 5000;
%Wallet_loop = input('After how many trials you want to show the wallet? (For example: 24) ');
Wallet_loop = 12;

%Is_Repeat = input('Do you want to repeat some trials? [0:false, o.w:true] ');
Is_Repeat=0;
if(Is_Repeat) 
    Repeat_Trials = input('Enter your repeating trials in one matrix [Ex. [1 3 5 12 ...]]');
end

% Ask available equipments and set them up 

% Ask available equipments
have_emg = 0;
have_eyetracker = 0;
show_eyetracker_calibration = 0;
have_fmri = 0;

if (Day == 5)
    have_emg = input('Are you going to send EMG trigger? ');
    have_eyetracker = input('Are you going to use eyetracker? ');
    if (have_eyetracker)
        show_eyetracker_calibration = input('Show eye tracker calibration? ');
    end
elseif (Day == 9)
    have_fmri = input('Are you going to gather data inside FMRI? ');
end

% Set them up

% EMG trigger
if(have_emg)
    s = serial('COM5','BaudRate',128000);
    fopen(s);
    pause(1)
end

% This is a time trigger for trials and their type
EMGT0 = GetSecs;
EMGTrigerTimes = [];

% Eyetracker

if(have_eyetracker)
    % Bina EyeTracker Initialize
    [connected, BinaHandle] =  SetupETSocketUDP();
    if(connected == 'fals')
        return;
    end
    WarnCalibMSG = warndlg('Please Calibrate the ET first');
    while (ETIsCalibrated(BinaHandle) ~= 1)

    end
    close(WarnCalibMSG)
    % Start Get gaze sending command 8 ti ET.............
    fwrite(BinaHandle, GetCommand(8));
    GazePoints={};
end

if(show_eyetracker_calibration)
    calibration_GazePoints = eyetracker_calibration(BinaHandle);
end

% MRI trigger

if(have_fmri)   
    IOPort('CloseAll');
    triger_config = 'BaudRate=57600 StopBits=1 Parity=None DataBits=8';
    [triger_handle, errmsg] = IOPort('OpenSerialPort', 'COM3', triger_config);


    wait_for_triger(triger_handle);
    IOPort('Purge', triger_handle);
    triger_data = 0;
    while (triger_data ~= 115)
        if (IOPort('BytesAvailable', triger_handle))
            [triger_data, when, errmsg] = IOPort('Read', triger_handle, 1, 1);
        end
    end

    TrigerT0 = GetSecs;
    TrigerTimes = zeros(1,48);
    
    pause(10);
end

% Load images from Fraktals dataset of the subject at specified day
imgs = zeros(1,200,200,3);      % store all images
if(data_index == 0)
    for i= 1:8
    location = ['../subjects/S_', num2str(i_index), '_', num2str(j_index), '_', num2str(k_index), '_', num2str(l_index), '_', num2str(h_index), '/D_', num2str(data_index), '/F', num2str(i), '.jpeg'];
    ds = imageDatastore(location);
    img = read(ds);            % read image from datastore
    imgs(i,:,:,:) = img;
    end
else
    for i= 1:12
        location = ['../subjects/S_', num2str(i_index), '_', num2str(j_index), '_', num2str(k_index), '_', num2str(l_index), '_', num2str(h_index), '/D_', num2str(data_index), '/F', num2str(i), '.jpeg'];
        ds = imageDatastore(location);
        img = read(ds);            % read image from datastore
        imgs(i,:,:,:) = img;
    end
end

% Laod reward bag image and set its properties
ds = imageDatastore(['../assets/coin-bag.png']);
bag_img = read(ds);
imageWidth = ImageSize;
imageHeight = ImageSize;
coinBagSize = 400;

% Input sequence
sequence_in = load(['../subjects/S_', num2str(i_index), '_', num2str(j_index), '_', num2str(k_index), '_', num2str(l_index), '_', num2str(h_index), '/D_', num2str(data_index), '/Sq_Day_', num2str(Day)]);
sequence_in = sequence_in.S; % load input sequence
nTrials = length(sequence_in);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Screen setup and other initializations
sca;
rng('shuffle');
success = audioread('../assets/success.wav');
error = audioread('../assets/error.wav');
noReward = audioread('../assets/noreward.wav');
Reward = audioread('../assets/reward.wav');

% hide the mouse cursor:
% HideCursor;

% Setup PTB with some default values
PsychDefaultSetup(2);

screenNumber = max(Screen('Screens'));
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

ds = imageDatastore(['../assets/white_fixation.jpeg']);
fixation_white_img = read(ds);
fixation_white_img = Screen('MakeTexture', window1, fixation_white_img);    

ds = imageDatastore(['../assets/red_fixation.jpeg']);
fixation_red_img = read(ds);
fixation_red_img = Screen('MakeTexture', window1, fixation_red_img);    

ds = imageDatastore(['../assets/blue_fixation.jpeg']);
fixation_blue_img = read(ds);
fixation_blue_img = Screen('MakeTexture', window1, fixation_blue_img);    

% Fixation Positions
position_fixation = [xCent-fixation_size/2, yCent-fixation_size/2, xCent+fixation_size/2, yCent+fixation_size/2];

% Arrows Settings
arrow_horizontal_offset = 130;
arrow_vertical_offset = 130;
arrow_size = 200;

ds = imageDatastore(['../assets/Arrow_d.jpeg']);
Arrow_d_img = read(ds);
Arrow_d_img = Screen('MakeTexture', window1, Arrow_d_img);    


ds = imageDatastore(['../assets/Arrow_u.jpeg']);
Arrow_u_img = read(ds);
Arrow_u_img = Screen('MakeTexture', window1, Arrow_u_img);    

ds = imageDatastore(['../assets/Arrow_l.jpeg']);
Arrow_l_img = read(ds);
Arrow_l_img = Screen('MakeTexture', window1, Arrow_l_img);    

ds = imageDatastore(['../assets/Arrow_r.jpeg']);
Arrow_r_img = read(ds);
Arrow_r_img = Screen('MakeTexture', window1, Arrow_r_img);    

% Arrows Positions
position_arrow_u = [xCent-arrow_size/2, yCent-arrow_vertical_offset-arrow_size/2, xCent+arrow_size/2, yCent-arrow_vertical_offset+arrow_size/2];
position_arrow_d = [xCent-arrow_size/2, yCent+arrow_vertical_offset-arrow_size/2, xCent+arrow_size/2, yCent+arrow_vertical_offset+arrow_size/2];
position_arrow_l = [xCent-arrow_horizontal_offset-arrow_size/2, yCent-arrow_size/2, xCent-arrow_horizontal_offset+arrow_size/2, yCent+arrow_size/2];
position_arrow_r = [xCent+arrow_horizontal_offset-arrow_size/2, yCent-arrow_size/2, xCent+arrow_horizontal_offset+arrow_size/2, yCent+arrow_size/2];


Late_Response_txt = sprintf('Sorry, too slow!'); %makes feedback string
Right_Response_txt = sprintf([num2str(floor(Money_Step/1000)), '.000', 'Tomans']); %makes feedback string
Wrong_Response_txt = sprintf('0 Tomans'); %makes feedback string
Wrong_Key_txt = sprintf('Wrong Key');
Choice_Good_txt = sprintf('Good');
Choice_Bad_txt = sprintf('Bad');
Fast_Response_txt = sprintf('Sorry, too fast!');    
Total_Points = 0;

KbName('UnifyKeyNames'); %used for cross-platform compatibility of keynaming
U = KbName('UpArrow');
D = KbName('DownArrow');
L = KbName('LeftArrow');
R = KbName('RightArrow');
E = KbName('Escape');

% Response Box
RLR = KbName('e');
RU = KbName('w');
RD = KbName('n');

KbQueueCreate; % creates cue using defaults
KbQueueStart;  % starts the cue
Screen('BlendFunction', window1, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Start screen
Screen('TextSize', window1, 70);
DrawFormattedText(window1, 'Press a key to begin', 'center', 'center', white);
Screen('Flip',window1);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo
KbStrokeWait;
Screen('Flip',window1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%***************************** README *************************************
% User's key reaction: 0-> no reaction available for the user
% 1-> too soon, 2-> on time right, 3-> on time wrong, 4-> too late
% 5-> wrong key
%**************************************************************************
RTs = zeros(256, nTrials); % save reaction time
RKs = zeros(1, nTrials); % save key reaction 

RT = 0;
if(Is_Repeat)
    Ts = Repeat_Trials;
else
    Ts = 1:nTrials;
end


choice_pos = j_index; % Show good hint top -> 1

for t = Ts
    type = sequence_in(1,t);
    
    if (mod(t,Wallet_loop) == 1 && (Day == 2 || Day == 5 || Day == 6 || Day == 7) && ~Is_Repeat) % Wallet Show
        
        EMGTrigerTimes = [EMGTrigerTimes [0;(GetSecs - EMGT0)]];
        
        bag_position = [xCent-coinBagSize/2, yCent-coinBagSize/2, xCent+coinBagSize/2, yCent+coinBagSize/2];
        bag_text_position_y = yCent+coinBagSize/2 + 70;
        if(t==1)
            bag_text = sprintf(['0', 'Tomans']); %makes feedback string
        else
            bag_text = sprintf([num2str(floor(Total_Points/1000)), '.000', 'Tomans']); %makes feedback string
        end
        Image_bag = Screen('MakeTexture', window1, bag_img);
        
        Screen('DrawTextures', window1, Image_bag, [], bag_position);
        DrawFormattedText(window1,bag_text, 'center', bag_text_position_y, white);
        
        Screen('Flip',window1);
       
        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.1);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,1} = eyetracker_wait(3, BinaHandle);
        else
            WaitSecs(3);
        end
        
        Screen('Flip',window1);
        WaitSecs(rand(1)+1);
    end
    
    EMGTrigerTimes = [EMGTrigerTimes [type;(GetSecs - EMGT0)]];

    if (type == 1) % force trial
        
        key = sequence_in(2,t);
        frk = floor(key/10);
        side = mod(key, 10);

        % If we were using arrows
        % Screen('DrawDots' ,  window1 , [xCent; yCent], 30, white, [], 2);
        % Screen('DrawTextures', window1, Arrow_l_img, [], position_arrow_l);
        % Screen('DrawTextures', window1, Arrow_r_img, [], position_arrow_r);

        Screen('DrawTextures', window1, fixation_white_img, [], position_fixation);

        Screen('Flip', window1);
        
        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.01);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,2} = eyetracker_wait(0.8, BinaHandle);
        else
            WaitSecs(0.8);
        end
        
        KbQueueFlush; %Flushes Buffer so only response after stimonset are recorded
        
        Image = Screen('MakeTexture', window1, uint8(squeeze(imgs(frk,:,:,:))));    
        
        if  side == 1
            position = [xCent-Delta_X-imageWidth/2, yCent-imageHeight/2, xCent-Delta_X+imageWidth/2, yCent+imageHeight/2]; %left
            position_x = xCent - Delta_X - imageWidth/2;
        elseif  side == 2
            position = [xCent+Delta_X-imageWidth/2, yCent-imageHeight/2, xCent+Delta_X+imageWidth/2, yCent+imageHeight/2]; %right   
            position_x = xCent + Delta_X - imageWidth/2;
        end
        
        position_y = yCent-floor(imageHeight*0.75);
        
        % If we were using arrows
        % Screen('DrawDots' ,  window1 , [xCent; yCent], 30, white, [], 2);
        % Screen('DrawTextures', window1, Arrow_l_img, [], position_arrow_l);
        % Screen('DrawTextures', window1, Arrow_r_img, [], position_arrow_r);
        
        Screen('DrawTextures', window1, Image, [], position);
        Screen('DrawTextures', window1, fixation_white_img, [], position_fixation);
        
        Screen('Flip',window1);
        
        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.04);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,3} = eyetracker_wait(1.2, BinaHandle);
        else
            WaitSecs(1.2);
        end
 
        Screen('DrawTextures', window1, Image, [], position);
        ChoiceStart = Screen('Flip',window1);
        
        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.07);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,4} = eyetracker_wait(1.2, BinaHandle);
        else
            WaitSecs(1.2);
        end
            
        [pressed, firstPress]=KbQueueCheck; %  check if any key was pressed.
        
        if pressed %if key was pressed do the following
            RT = firstPress - ChoiceStart;
            RTs(:,t) = RT;
            
            key_index = checkLastKeyPressed(RT, [L, R, E]);
            RT = firstPress(~firstPress==0)- ChoiceStart;
            
            if key_index == L
                key = 1;
            elseif key_index == R
                key = 2;
            elseif key_index == E
                sca;
                return
            else
                key = 3;
            end
            
            if(Show_feedback_force)
                if frk < 5
                    Screen('DrawTextures', window1, Image, [], position);
                    DrawFormattedText(window1,Right_Response_txt, position_x, position_y, white);
                else
                    Screen('DrawTextures', window1, Image, [], position);
                    DrawFormattedText(window1,Wrong_Response_txt, position_x, position_y, white);
                end
            end
            
            if RT > 0
                if (((key==1) && (side==1)) || ((key==2) && (side==2)))
                    if frk < 5
                        soundsc(Reward, 44100); 
                        Total_Points = Total_Points + Money_Step;
                        Screen('DrawTextures', window1, Image, [], position);
                        DrawFormattedText(window1,Right_Response_txt, position_x, position_y, white);
                    else
                        soundsc(noReward, 44100); 
                        Screen('DrawTextures', window1, Image, [], position);
                        DrawFormattedText(window1,Wrong_Response_txt, position_x, position_y, white);
                    end

                    Screen('Flip',window1)
                    RT = 2;
                elseif (key == 3)
                    soundsc(error, 44100);
                    DrawFormattedText(window1,Wrong_Key_txt,'center','center',[255 0 0]);
                    Screen('Flip',window1)
                    RT = 5;
                else
                    soundsc(error, 44100);
                    DrawFormattedText(window1,Wrong_Key_txt,'center','center',[255 0 0]);
                    Screen('Flip',window1)
                    RT = 3;
                end
            else
                soundsc(error, 44100);
                DrawFormattedText(window1,Fast_Response_txt,'center','center',[255 0 0]);
                Screen('Flip',window1);
                RT = 1;
            end
        else
            soundsc(error, 44100);
            DrawFormattedText(window1,Late_Response_txt,'center','center',[255 0 0]);
            Screen('Flip',window1);
            RT = 4;
        end        
        WaitSecs(1);
    end
    
    if (type == 2) % choice1

        key = sequence_in(2,t);
        frk = floor(key/10);
        side = mod(key, 10);

        % If we were using arrows
        % Screen('DrawDots' ,  window1 , [xCent; yCent], 30, [256,0, 0], [], 2);
        % Screen('DrawTextures', window1, Arrow_u_img, [], position_arrow_u);
        % Screen('DrawTextures', window1, Arrow_d_img, [], position_arrow_d);
        
        Screen('DrawTextures', window1, fixation_red_img, [], position_fixation);
        
        Screen('Flip', window1);
        
        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.01);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,2} = eyetracker_wait(0.8, BinaHandle);
        else
            WaitSecs(0.8);
        end
        
        KbQueueFlush; % Flushes Buffer so only response after stimonset are recorded
        
        Image = Screen('MakeTexture', window1, uint8(squeeze(imgs(frk,:,:,:))));    
        
        if  side == 1
            position = [xCent-Delta_X-imageWidth/2, yCent-imageHeight/2, xCent-Delta_X+imageWidth/2, yCent+imageHeight/2]; %left
            position_x_good = xCent - Delta_X - imageWidth/2 + 10;
            position_x_bad = xCent - Delta_X - imageWidth/2 + 35;
        elseif  side == 2
            position = [xCent+Delta_X-imageWidth/2, yCent-imageHeight/2, xCent+Delta_X+imageWidth/2, yCent+imageHeight/2]; %right   
            position_x_good = xCent + Delta_X - imageWidth/2 + 10;
            position_x_bad = xCent + Delta_X - imageWidth/2 + 35;
        end
        
        if choice_pos == 1 % show good hint top
            position_y_good = yCent-floor(imageHeight*0.75); 
            position_y_bad = yCent+floor(imageHeight*0.9); 
        else % show bad hint top
            position_y_good = yCent+floor(imageHeight*0.9); 
            position_y_bad = yCent-floor(imageHeight*0.75); 
        end
        
        % If we were using arrows
        % Screen('DrawDots' ,  window1 , [xCent; yCent], 30, [256,0, 0], [], 2);
        % Screen('DrawTextures', window1, Arrow_u_img, [], position_arrow_u);
        % Screen('DrawTextures', window1, Arrow_d_img, [], position_arrow_d);
        
        Screen('DrawTextures', window1, Image, [], position);
        Screen('DrawTextures', window1, fixation_red_img, [], position_fixation);

        Screen('Flip',window1);
        
        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.04);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,3} = eyetracker_wait(1.2, BinaHandle);
        else
            WaitSecs(1.2);
        end
        
        DrawFormattedText(window1,Choice_Good_txt, position_x_good, position_y_good, white);
        DrawFormattedText(window1,Choice_Bad_txt, position_x_bad, position_y_bad, white);
        ChoiceStart = Screen('Flip',window1);

        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.07);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,4} = eyetracker_wait(2, BinaHandle);
        else
            WaitSecs(2);
        end
        
        [pressed, firstPress]=KbQueueCheck; %  check if any key was pressed.
        if pressed %if key was pressed do the following
            RT = firstPress - ChoiceStart;
            RTs(:,t) = RT;
            
            key_index = checkLastKeyPressed(RT, [U, D, E]);
            RT = firstPress(~firstPress==0)- ChoiceStart;
            
            if key_index == U
                key = 1;
            elseif key_index == D
                key = 2;
            elseif key_index == E
                sca;
                return
            else
                key = 3;
            end

            if RT > 0
                if ((key==1) && ((frk < 5) && (choice_pos==1) || (frk > 4) && (choice_pos==2)))
                    soundsc(success, 44100);  
                    RT = 2;
                    Total_Points = Total_Points + Money_Step;
                elseif ((key==2) && ((frk < 5) && (choice_pos==2) || (frk > 4) && (choice_pos==1)))
                    soundsc(success, 44100);
                    RT = 2;
                    Total_Points = Total_Points + Money_Step;
                elseif (key == 3)
                    soundsc(error, 44100);
                    DrawFormattedText(window1,Wrong_Key_txt,'center','center',white);
                    Screen('Flip',window1)
                    RT = 5;
                else
                    soundsc(success, 44100);
                    RT = 3;
                end
            else
                soundsc(error, 44100);
                DrawFormattedText(window1,Fast_Response_txt,'center','center',[255 0 0]);
                Screen('Flip',window1);
                RT = 1;
            end
        else
            soundsc(error, 44100);
            DrawFormattedText(window1,Late_Response_txt,'center','center',[255 0 0]);
            Screen('Flip',window1);
            RT = 4;
        end        
        WaitSecs(1);
    end
    
    if (type == 3) % choice2
        key = sequence_in(2,t);
        frk_left = floor(key/10);
        frk_right = mod(key, 10);

        % Set the blend function for the screen
        Screen('DrawDots' ,  window1 , [xCent; yCent], 30, [0,0, 256], [], 2);
        Screen('DrawTextures', window1, Arrow_l_img, [], position_arrow_l);
        Screen('DrawTextures', window1, Arrow_r_img, [], position_arrow_r);
        Screen('Flip', window1);
        
        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.01);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,2} = eyetracker_wait(0.8, BinaHandle);
        else
            WaitSecs(0.8);
        end
        
        KbQueueFlush; % Flushes Buffer so only response after stimonset are recorded
        
        Image_left = Screen('MakeTexture', window1, uint8(squeeze(imgs(frk_left,:,:,:))));    
        Image_right = Screen('MakeTexture', window1, uint8(squeeze(imgs(frk_right,:,:,:))));    

        position_left = [xCent-Delta_X-imageWidth/2, yCent-imageHeight/2, xCent-Delta_X+imageWidth/2, yCent+imageHeight/2]; %left
        position_right = [xCent+Delta_X-imageWidth/2, yCent-imageHeight/2, xCent+Delta_X+imageWidth/2, yCent+imageHeight/2]; %right   
        
        position_y_response = yCent-floor(imageHeight*0.75);
        
        Screen('DrawDots' ,  window1 , [xCent; yCent], 30, [0,0, 256], [], 2); 
        Screen('DrawTextures', window1, Arrow_l_img, [], position_arrow_l);
        Screen('DrawTextures', window1, Arrow_r_img, [], position_arrow_r);
        Screen('DrawTextures', window1, Image_left, [], position_left);
        Screen('DrawTextures', window1, Image_right, [], position_right);
        
        Screen('Flip',window1);
        
        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.04);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,3} = eyetracker_wait(1.2, BinaHandle);
        else
            WaitSecs(1.2);
        end
        
        Screen('DrawTextures', window1, Image_left, [], position_left);
        Screen('DrawTextures', window1, Image_right, [], position_right);
        ChoiceStart = Screen('Flip',window1);

        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.07);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,4} = eyetracker_wait(2, BinaHandle);
        else
            WaitSecs(2);
        end
        
        [pressed, firstPress]=KbQueueCheck; %  check if any key was pressed.
        if pressed %if key was pressed do the following
            
            RT = firstPress - ChoiceStart;
            RTs(:,t) = RT;
            
            key_index = checkLastKeyPressed(RT, [L, R, E]);
            RT = firstPress(~firstPress==0)- ChoiceStart;
            
            if key_index == L
                key = 1;
            elseif key_index == R
                key = 2;
            elseif key_index == E
                sca;
                return
            else
                key = 3;
            end
            
            RT= firstPress(~firstPress==0)- ChoiceStart;
            if firstPress(L)
                key = 1;
            elseif firstPress(R)
                key = 2;
            elseif firstPress(E)
                sca;
                return
            else
                key = 3;
            end
            
            if RT > 0
                if ((key==1) && (frk_left < 5)) || ((key==2) && (frk_right < 5))
                    soundsc(success, 44100);  
                    RT = 2;
                    Total_Points = Total_Points + Money_Step;
                    if(key==1)
                        position_x_response = xCent - Delta_X - imageWidth/2 + 10;
                    else
                        position_x_response = xCent + Delta_X - imageWidth/2 + 10;
                    end          
                    Screen('DrawTextures', window1, Image_left, [], position_left);
                    Screen('DrawTextures', window1, Image_right, [], position_right);
                    DrawFormattedText(window1,Right_Response_txt, position_x_response, position_y_response, white);
                    Screen('Flip',window1);
                elseif (key == 3)
                    soundsc(error, 44100);
                    DrawFormattedText(window1,Wrong_Key_txt,'center','center',[255 0 0]);
                    Screen('Flip',window1)
                    RT = 5;
                else
                    soundsc(success, 44100);
                    RT = 3;
                    if(key==1)
                        position_x_response = xCent - Delta_X - imageWidth/2 + 10;
                    else
                        position_x_response = xCent + Delta_X - imageWidth/2 + 10;
                    end
                    Screen('DrawTextures', window1, Image_left, [], position_left);
                    Screen('DrawTextures', window1, Image_right, [], position_right);
                    DrawFormattedText(window1,Wrong_Response_txt, position_x_response, position_y_response, white);
                    Screen('Flip',window1);
                end
            else
                soundsc(error, 44100);
                DrawFormattedText(window1,Fast_Response_txt,'center','center',[255 0 0]);
                Screen('Flip',window1);
                RT = 1;
            end
        else
            soundsc(error, 44100);
            DrawFormattedText(window1,Late_Response_txt,'center','center',[255 0 0]);
            Screen('Flip',window1);
            RT = 4;
        end        
        WaitSecs(1);
    end
    
    if (type == 4) % choice2'
        
        key = sequence_in(2,t);
        frk_up = floor(key/100);
        frk_down = mod(floor(key/10),10);
        side = mod(key, 10); 

        % If we were using arrows
        % Screen('DrawDots' ,  window1 , [xCent; yCent], 30, [0,0, 256], [], 2);
        % Screen('DrawTextures', window1, Arrow_u_img, [], position_arrow_u);
        % Screen('DrawTextures', window1, Arrow_d_img, [], position_arrow_d);
        
        Screen('DrawTextures', window1, fixation_blue_img, [], position_fixation);
        Screen('Flip', window1);

        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.01);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,2} = eyetracker_wait(0.8, BinaHandle);
        else
            WaitSecs(0.8);
        end
        
        KbQueueFlush; % Flushes Buffer so only response after stimonset are recorded
        
        Image_up = Screen('MakeTexture', window1, uint8(squeeze(imgs(frk_up,:,:,:))));    
        Image_down = Screen('MakeTexture', window1, uint8(squeeze(imgs(frk_down,:,:,:))));    

        if(side == 1) % left
            position_up = [xCent- Delta_X*cos(pi/4)-imageWidth/2, yCent-Delta_X*sin(pi/4)-imageHeight/2, xCent-Delta_X*cos(pi/4)+imageWidth/2, yCent-Delta_X*sin(pi/4)+imageHeight/2]; %left up
            position_down = [xCent- Delta_X*cos(pi/4)-imageWidth/2, yCent+Delta_X*sin(pi/4)-imageHeight/2, xCent-Delta_X*cos(pi/4)+imageWidth/2, yCent+Delta_X*sin(pi/4)+imageHeight/2]; %left down
            position_x_response = xCent- Delta_X*cos(pi/4) - floor(imageWidth*0.3);
        else % right
            position_up = [xCent + Delta_X * cos(pi/4)-imageWidth/2, yCent-Delta_X*sin(pi/4)-imageHeight/2, xCent+Delta_X*cos(pi/4)+imageWidth/2, yCent-Delta_X*sin(pi/4)+imageHeight/2]; %right up
            position_down = [xCent + Delta_X * cos(pi/4)-imageWidth/2, yCent+Delta_X*sin(pi/4)-imageHeight/2, xCent+Delta_X*cos(pi/4)+imageWidth/2, yCent+Delta_X*sin(pi/4)+imageHeight/2]; %right down 
            position_x_response = xCent+ Delta_X*cos(pi/4) - floor(imageWidth*0.3);
        end
        
        Screen('DrawTextures', window1, Image_up, [], position_up);
        Screen('DrawTextures', window1, Image_down, [], position_down);
                
        % If we were using arrows
        % Screen('DrawDots' ,  window1 , [xCent; yCent], 30, [0,0, 256], [], 2);
        % Screen('DrawTextures', window1, Arrow_u_img, [], position_arrow_u);
        % Screen('DrawTextures', window1, Arrow_d_img, [], position_arrow_d);
        
        Screen('DrawTextures', window1, fixation_blue_img, [], position_fixation);
        
        Screen('Flip',window1);
        
        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.04);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,3} = eyetracker_wait(1.2, BinaHandle);
        else
            WaitSecs(1.2);
        end

        Screen('DrawTextures', window1, Image_up, [], position_up);
        Screen('DrawTextures', window1, Image_down, [], position_down);
        ChoiceStart = Screen('Flip',window1);

        % EMG Trigger
        if(have_emg)
            fprintf(s,'111111110100'); 
            pause(0.07);
            fprintf(s,'000000000100');
        end
        
        % Wait
        if(have_eyetracker)
            GazePoints{t,4} = eyetracker_wait(2, BinaHandle);
        else
            WaitSecs(2);
        end
        
        [pressed, firstPress]=KbQueueCheck; %  check if any key was pressed.
        if pressed %if key was pressed do the following
            RT = firstPress - ChoiceStart;
            RTs(:,t) = RT;
            
            key_index = checkLastKeyPressed(RT, [U, D, E]);
            RT = firstPress(~firstPress==0)- ChoiceStart;
            
            if key_index == U
                key = 1;
            elseif key_index == D
                key = 2;
            elseif key_index == E
                sca;
                return
            else
                key = 3;
            end            
            
            if RT > 0
                if ((key==1) && (frk_up < 5)) || ((key==2) && (frk_down < 5))
                    soundsc(Reward, 44100);  
                    RT = 2;
                    
                    Total_Points = Total_Points + Money_Step;
                    if(key==1)
                        position_y_response = yCent-Delta_X*sin(pi/4)-imageHeight/2 - 30;
                    else
                        position_y_response = yCent+Delta_X*sin(pi/4)-imageHeight/2 - 30;
                    end  
                    Screen('DrawTextures', window1, Image_up, [], position_up);
                    Screen('DrawTextures', window1, Image_down, [], position_down);
                    DrawFormattedText(window1,Right_Response_txt, position_x_response, position_y_response, white);
                    Screen('Flip',window1);
                    
                elseif (key == 3)
                    soundsc(error, 44100);
                    DrawFormattedText(window1,Wrong_Key_txt,'center','center',[255 0 0]);
                    Screen('Flip',window1)
                    RT = 5;
                else
                    soundsc(noReward, 44100);
                    RT = 3;
                    
                    if(key==1)
                        position_y_response = yCent-Delta_X*sin(pi/4)-imageHeight/2 - 30;
                    else
                        position_y_response = yCent+Delta_X*sin(pi/4)-imageHeight/2 - 30;
                    end  
                    Screen('DrawTextures', window1, Image_up, [], position_up);
                    Screen('DrawTextures', window1, Image_down, [], position_down);
                    DrawFormattedText(window1,Wrong_Response_txt, position_x_response, position_y_response, white);
                    Screen('Flip',window1);
                    
                end
            else
                soundsc(error, 44100);
                DrawFormattedText(window1,Fast_Response_txt,'center','center',[255 0 0]);
                if(Show_feedback_choice_2)
                    if(key==1)
                        position_y_response = yCent-Delta_X*sin(pi/4)-imageHeight/2 - 30;
                        if frk_up < 5
                             Screen('DrawTextures', window1, Image_up, [], position_up);
                             Screen('DrawTextures', window1, Image_down, [], position_down);
                             DrawFormattedText(window1,Right_Response_txt, position_x_response, position_y_response, white);
                        else
                             Screen('DrawTextures', window1, Image_up, [], position_up);
                             Screen('DrawTextures', window1, Image_down, [], position_down);
                             DrawFormattedText(window1,Wrong_Response_txt, position_x_response, position_y_response, white);
                        end
                    else
                        position_y_response = yCent+Delta_X*sin(pi/4)-imageHeight/2 - 30;
                        if frk_down < 5
                             Screen('DrawTextures', window1, Image_up, [], position_up);
                             Screen('DrawTextures', window1, Image_down, [], position_down);
                             DrawFormattedText(window1,Right_Response_txt, position_x_response, position_y_response, white);
                        else
                             Screen('DrawTextures', window1, Image_up, [], position_up);
                             Screen('DrawTextures', window1, Image_down, [], position_down);
                             DrawFormattedText(window1,Wrong_Response_txt, position_x_response, position_y_response, white);
                        end
                    end  
                    
                else
                    soundsc(error, 44100);
                    Screen('DrawTextures', window1, Image_up, [], position_up);
                    Screen('DrawTextures', window1, Image_down, [], position_down);
                    DrawFormattedText(window1,Fast_Response_txt,'center','center',[255 0 0]);
                end
                Screen('Flip',window1);
                RT = 1;
            end
        else
            soundsc(error, 44100);
            DrawFormattedText(window1,Late_Response_txt,'center','center',[255 0 0]);
            Screen('Flip',window1);
            RT = 4;
        end        
        WaitSecs(1);
    end
    
    if (type == 5) % passive viewing trial
        key = sequence_in(2,t);
        frk = floor(key/100);
        side = mod(floor(key/10),10);
        elevation = mod(key, 10); 
   
        Image = Screen('MakeTexture', window1, uint8(squeeze(imgs(frk,:,:,:))));    
       
        if  side == 1 && elevation == 1
            position = [xCent- Delta_X*cos(pi/4)-imageWidth/2, yCent-Delta_X*sin(pi/4)-imageHeight/2, xCent-Delta_X*cos(pi/4)+imageWidth/2, yCent-Delta_X*sin(pi/4)+imageHeight/2]; %left top
        elseif  side == 1 && elevation == 2
            position = [xCent-Delta_X-imageWidth/2, yCent-imageHeight/2, xCent-Delta_X+imageWidth/2, yCent+imageHeight/2]; %left
        elseif  side == 1 && elevation == 3
            position = [xCent- Delta_X*cos(pi/4)-imageWidth/2, yCent+Delta_X*sin(pi/4)-imageHeight/2, xCent-Delta_X*cos(pi/4)+imageWidth/2, yCent+Delta_X*sin(pi/4)+imageHeight/2]; %left bottom
        elseif  side == 2 && elevation == 1
            position = [xCent + Delta_X * cos(pi/4)-imageWidth/2, yCent-Delta_X*sin(pi/4)-imageHeight/2, xCent+Delta_X*cos(pi/4)+imageWidth/2, yCent-Delta_X*sin(pi/4)+imageHeight/2]; %right top
        elseif side == 2 && elevation == 2
            position = [xCent + Delta_X-imageWidth/2, yCent-imageHeight/2, xCent+Delta_X+imageWidth/2, yCent+imageHeight/2]; %right
        elseif side == 2 && elevation == 3
            position = [xCent + Delta_X * cos(pi/4)-imageWidth/2, yCent+Delta_X*sin(pi/4)-imageHeight/2, xCent+Delta_X*cos(pi/4)+imageWidth/2, yCent+Delta_X*sin(pi/4)+imageHeight/2]; %right bottom       
        end

        % Show
        Screen('DrawDots' , window1 , [xCent; yCent], 30, white, [], 2);
        Screen('Flip',window1);
        WaitSecs(10);
        Screen('DrawDots' , window1 , [xCent; yCent], 30, white, [], 2);
        Screen('Flip',window1);
        WaitSecs(0.2);
        Screen('DrawTextures', window1 , Image, [], position);
        Screen('Flip',window1);
        WaitSecs(10);
        
        RT = 0;
    end
    
    if (type == 6) % choice1'
        key = sequence_in(2,t);
        frk = floor(key/100);        
        side = mod(floor(key/10), 10);
        t_type = mod(key, 10);
                
        % If we were using arrows
        % Screen('DrawTextures', window1, Arrow_u_img, [], position_arrow_u);
        % Screen('DrawTextures', window1, Arrow_d_img, [], position_arrow_d);
        % Screen('DrawTextures', window1, Arrow_r_img, [], position_arrow_r);
        % Screen('DrawTextures', window1, Arrow_l_img, [], position_arrow_l);

        Screen('DrawDots' ,  window1 , [xCent; yCent], 30, [256,0, 0], [], 2);

        Screen('Flip', window1);
        WaitSecs(0.5);
        KbQueueFlush; % Flushes Buffer so only response after stimonset are recorded
        
        Image = Screen('MakeTexture', window1, uint8(squeeze(imgs(frk,:,:,:))));    
        
        if  side == 1
            position = [xCent-Delta_X-imageWidth/2, yCent-imageHeight/2, xCent-Delta_X+imageWidth/2, yCent+imageHeight/2]; %left
            position_x_good = xCent - Delta_X - imageWidth/2 + 10;
            position_x_bad = xCent - Delta_X - imageWidth/2 + 35;
        elseif  side == 2
            position = [xCent+Delta_X-imageWidth/2, yCent-imageHeight/2, xCent+Delta_X+imageWidth/2, yCent+imageHeight/2]; %right   
            position_x_good = xCent + Delta_X - imageWidth/2 + 10;
            position_x_bad = xCent + Delta_X - imageWidth/2 + 35;
        end
        
        if choice_pos == 1 % show good hint top
            position_y_good = yCent-floor(imageHeight*0.75); 
            position_y_bad = yCent+floor(imageHeight*0.9); 
        else % show bad hint top
            position_y_good = yCent+floor(imageHeight*0.9); 
            position_y_bad = yCent-floor(imageHeight*0.75); 
        end
        Screen('DrawDots' ,  window1 , [xCent; yCent], 30, [256,0, 0], [], 2);

        Screen('DrawTextures', window1, Image, [], position);
        Screen('Flip',window1);
        
        WaitSecs(1.2);
        
        DrawFormattedText(window1,Choice_Good_txt, position_x_good, position_y_good, white);
        DrawFormattedText(window1,Choice_Bad_txt, position_x_bad, position_y_bad, white);
        ChoiceStart = Screen('Flip',window1);

        WaitSecs(2);        
        [pressed, firstPress]=KbQueueCheck; %  check if any key was pressed.
        if pressed % if key was pressed do the following
            RT = firstPress - ChoiceStart;
            RTs(:,t) = RT;
            
            key_index = checkLastKeyPressed(RT, [U, D, L, R, E]);
            RT = firstPress(~firstPress==0)- ChoiceStart;
            
            if key_index == U
                key = 1;
            elseif key_index == D
                key = 2;
            elseif (key_index == L || key_index == R)
                key = 3;
            elseif key_index == E
                sca;
                return
            else
                key = 4;
            end

            if RT > 0
                if ((key==1) && ((t_type==1) && (choice_pos==1) || (t_type==2) && (choice_pos==2)))
                    soundsc(success, 44100);  
                    RT = 2;
                    Total_Points = Total_Points + Money_Step;
                elseif ((key==2) && ((t_type==1) && (choice_pos==2) || (t_type==2) && (choice_pos==1)))
                    soundsc(success, 44100);
                    RT = 2;
                    Total_Points = Total_Points + Money_Step;
                elseif ((key==3) && (t_type==3))
                    soundsc(success, 44100);
                    RT = 2;
                    Total_Points = Total_Points + Money_Step;
                elseif (key == 4)
                    soundsc(error, 44100);
                    DrawFormattedText(window1,Wrong_Key_txt,'center','center',white);
                    Screen('Flip',window1)
                    RT = 5;
                else
                    soundsc(success, 44100);
                    RT = 3;
                end
            else
                soundsc(error, 44100);
                DrawFormattedText(window1,Fast_Response_txt,'center','center',[255 0 0]);
                Screen('Flip',window1);
                RT = 1;
            end
        else
            soundsc(error, 44100);
            DrawFormattedText(window1,Late_Response_txt,'center','center',[255 0 0]);
            Screen('Flip',window1);
            RT = 4;
        end        
        WaitSecs(1);
    end
    
    if (type == 7) % rest1
        
        if(have_fmri)
            TrigerTimes(t) = GetSecs - TrigerT0;
        end
        
        Screen('Flip', window1);
        WaitSecs(2);
        
        for irest = 1:3 
            Screen('DrawDots' ,  window1 , [xCent; yCent], fixation_size, [255,255, 255], [], 2);
            Screen('Flip', window1);
            WaitSecs(1.8);

            Screen('Flip', window1);
            WaitSecs(0.4);
        end
 
        RTs(:,t) = -1 .* ones(size(RTs, 1),1);
        RT = -1;
        
    end
    
    if (type == 8) % probe
        
        if(have_fmri)
            TrigerTimes(t) = GetSecs - TrigerT0;
        end
        
        key = sequence_in(2,t);
        frk = floor(key/1000);        
        side = mod(floor(key/100), 10);
        t_type = mod(floor(key/10), 10);
        repeat = mod(key, 10);
        Image = Screen('MakeTexture', window1, uint8(squeeze(imgs(frk,:,:,:))));    
       
        for rep = 1:repeat 
        for elevation = [2 1 3]
            if  side == 1 && elevation == 1
                position = [xCent- Delta_X*cos(pi/4)-imageWidth/2, yCent-Delta_X*sin(pi/4)-imageHeight/2, xCent-Delta_X*cos(pi/4)+imageWidth/2, yCent-Delta_X*sin(pi/4)+imageHeight/2]; %left top
            elseif  side == 1 && elevation == 2
                position = [xCent-Delta_X-imageWidth/2, yCent-imageHeight/2, xCent-Delta_X+imageWidth/2, yCent+imageHeight/2]; %left
            elseif  side == 1 && elevation == 3
                position = [xCent- Delta_X*cos(pi/4)-imageWidth/2, yCent+Delta_X*sin(pi/4)-imageHeight/2, xCent-Delta_X*cos(pi/4)+imageWidth/2, yCent+Delta_X*sin(pi/4)+imageHeight/2]; %left bottom
            elseif  side == 2 && elevation == 1
                position = [xCent + Delta_X * cos(pi/4)-imageWidth/2, yCent-Delta_X*sin(pi/4)-imageHeight/2, xCent+Delta_X*cos(pi/4)+imageWidth/2, yCent-Delta_X*sin(pi/4)+imageHeight/2]; %right top
            elseif side == 2 && elevation == 2
                position = [xCent + Delta_X-imageWidth/2, yCent-imageHeight/2, xCent+Delta_X+imageWidth/2, yCent+imageHeight/2]; %right
            elseif side == 2 && elevation == 3
                position = [xCent + Delta_X * cos(pi/4)-imageWidth/2, yCent+Delta_X*sin(pi/4)-imageHeight/2, xCent+Delta_X*cos(pi/4)+imageWidth/2, yCent+Delta_X*sin(pi/4)+imageHeight/2]; %right bottom       
            end
            
            % Show
            Screen('DrawDots' , window1 , [xCent; yCent], fixation_size, white, [], 2);
            Screen('Flip',window1);
            WaitSecs(0.2);
            Screen('DrawDots' , window1 , [xCent; yCent], fixation_size, white, [], 2);
            Screen('DrawTextures', window1 , Image, [], position);
            Screen('Flip',window1);
            WaitSecs(0.8);

        end
        end
        
        
        % Set the blend function for the screen
        Screen('DrawDots' ,  window1 , [xCent; yCent], fixation_size, [256,0, 0], [], 2);
        Screen('Flip', window1);
        WaitSecs(0.5);
        KbQueueFlush; %Flushes Buffer so only response after stimonset are recorded
                
        if  side == 1
            position = [xCent-Delta_X-imageWidth/2, yCent-imageHeight/2, xCent-Delta_X+imageWidth/2, yCent+imageHeight/2]; %left
            position_x_good = xCent - Delta_X - imageWidth/2 + 10;
            position_x_bad = xCent - Delta_X - imageWidth/2 + 35;
        elseif  side == 2
            position = [xCent+Delta_X-imageWidth/2, yCent-imageHeight/2, xCent+Delta_X+imageWidth/2, yCent+imageHeight/2]; %right   
            position_x_good = xCent + Delta_X - imageWidth/2 + 10;
            position_x_bad = xCent + Delta_X - imageWidth/2 + 35;
        end
        
        if choice_pos == 1 % show good hint top
            position_y_good = yCent-floor(imageHeight*0.75); 
            position_y_bad = yCent+floor(imageHeight*0.9); 
        else % show bad hint top
            position_y_good = yCent+floor(imageHeight*0.9); 
            position_y_bad = yCent-floor(imageHeight*0.75); 
        end
        
        Screen('DrawDots' ,  window1 , [xCent; yCent], fixation_size, [256,0, 0], [], 2);
        Screen('DrawTextures', window1, Image, [], position);
        DrawFormattedText(window1,Choice_Good_txt, position_x_good, position_y_good, white);
        DrawFormattedText(window1,Choice_Bad_txt, position_x_bad, position_y_bad, white);
        ChoiceStart = Screen('Flip',window1);

        WaitSecs(2.5);   
        
        [pressed, firstPress]=KbQueueCheck; %  check if any key was pressed.
        if pressed %if key was pressed do the following
            RT = firstPress - ChoiceStart;
            RTs(:,t) = RT;
            
            key_index = checkLastKeyPressed(RT, [RLR, RU, RD, E]);
            RT = firstPress(~firstPress==0)- ChoiceStart;
            
            if key_index == RU
                key = 1;
            elseif key_index == RD
                key = 2;
            elseif (key_index == RLR)
                key = 3;
            elseif key_index == E
                sca;
                return
            else
                key = 4;
            end

            if RT > 0
                if ((key==1) && ((t_type==1) && (choice_pos==1) || (t_type==2) && (choice_pos==2)))
                    soundsc(success, 44100);  
                    RT = 2;
                    Total_Points = Total_Points + Money_Step;
                elseif ((key==2) && ((t_type==1) && (choice_pos==2) || (t_type==2) && (choice_pos==1)))
                    soundsc(success, 44100);
                    RT = 2;
                    Total_Points = Total_Points + Money_Step;
                elseif ((key==3) && (t_type==3))
                    soundsc(success, 44100);
                    RT = 2;
                    Total_Points = Total_Points + Money_Step;
                elseif (key == 4)
                    soundsc(error, 44100);
                    DrawFormattedText(window1,Wrong_Key_txt,'center','center',white);
                    Screen('Flip',window1)
                    RT = 5;
                else
                    soundsc(success, 44100);
                    RT = 3;
                end
            else
                soundsc(error, 44100);
                DrawFormattedText(window1,Fast_Response_txt,'center','center',[255 0 0]);
                Screen('Flip',window1);
                RT = 1;
            end
        else
            soundsc(error, 44100);
            DrawFormattedText(window1,Late_Response_txt,'center','center',[255 0 0]);
            Screen('Flip',window1);
            RT = 4;
        end                
        
    end
    
    RKs(t) = RT;
    
    % ITI
    if(type ~= 8)
        Screen('Flip',window1);
        WaitSecs(rand(1)+1);
    end
    
end


% Finall show of the wallet

if(Day ==  2 || Day == 5)
    bag_position = [xCent-coinBagSize/2, yCent-coinBagSize/2, xCent+coinBagSize/2, yCent+coinBagSize/2];
    bag_text_position_y = yCent+coinBagSize/2 + 70;
    bag_text = sprintf([num2str(floor(Total_Points/1000)), '.000', 'Tomans']); %makes feedback string
    Image_bag = Screen('MakeTexture', window1, bag_img);

    Screen('DrawTextures', window1, Image_bag, [], bag_position);
    DrawFormattedText(window1,bag_text, 'center', bag_text_position_y, white);

    Screen('Flip',window1);
    WaitSecs(10);
end

% Save data

if(Is_Repeat)
    RKs_temp = RKs;
    RTs_temp = RTs;
    load(['../subjects/S_', num2str(i_index), '_', num2str(j_index), '_', num2str(k_index), '_', num2str(l_index), '_', num2str(h_index), '/D_', num2str(data_index), '/OUT_Day_RT_', num2str(Day)], 'RTs');
    load(['../subjects/S_', num2str(i_index), '_', num2str(j_index), '_', num2str(k_index), '_', num2str(l_index), '_', num2str(h_index), '/D_', num2str(data_index), '/OUT_Day_RK_', num2str(Day)], 'RKs');
    RKs(Repeat_Trials) = RKs_temp(Repeat_Trials);
    RTs(:, Repeat_Trials) = RTs_temp(:, Repeat_Trials);  
end

save(['../subjects/S_', num2str(i_index), '_', num2str(j_index), '_', num2str(k_index), '_', num2str(l_index), '_', num2str(h_index), '/D_', num2str(data_index), '/OUT_Day_RT_', num2str(Day)], 'RTs');
save(['../subjects/S_', num2str(i_index), '_', num2str(j_index), '_', num2str(k_index), '_', num2str(l_index), '_', num2str(h_index), '/D_', num2str(data_index), '/OUT_Day_RK_', num2str(Day)], 'RKs');
save(['../subjects/S_', num2str(i_index), '_', num2str(j_index), '_', num2str(k_index), '_', num2str(l_index), '_', num2str(h_index), '/D_', num2str(data_index), '/OUT_Day_ALL_', num2str(Day)]);

sca;
clear Screen;