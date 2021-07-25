function [gz] = eyetracker_wait(waitTime, BinaHandle)
% this code gathers gaze data for specified time 
    gz=[];
    tic 
    tt  = toc;
    while(tt < waitTime)
        gz = [gz;ReadGaze(BinaHandle)];
        tt = toc;
    end
end

