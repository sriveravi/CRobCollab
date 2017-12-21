% add my scripts to path, so matlab knows where the function files are saved
path( path, 'Support');  % that folder has most basic data loading/viewing stuff
path( path, 'strings/strings');  % if you have an older MATLAB, you may need some text manipulation functions

%----------------------------------
%----------------------------------

% load exp data
trials = loadELfile( 'ChrisData/chris.asc');

% remove the last trial if didn't finish (no responseMade message sent)
if isempty(find(strcmp( 'responseMade', trials(end).msg), 1)) 
    trials(end) = []; 
end


%NOTE
% you can see that trials is a structure array with all the information,
% so trials(1) has all the info for the first trial, trials(2) for the
% second, and so on
%See what data is in there like:

trials(1)

trials(1).KEYPRESS
trials(1).RT

%----------------------------------
%----------------------------------

% extract fixations/saccades/pupil size from time between certain messages
% were sent
startMsg = 'target'; 
endMsg = 'interstim';
offsets = [0, 0];
[ targetToInterstim, timesTarget ] = cropTrialsByMsg( trials, startMsg, endMsg, offsets );
% targetToInterstim has all the trial info,from between the time you send the messages
% 'target' to 'interstim';


startMsg = 'test'; 
endMsg = 'responseMade';
offsets = [0, 0];
[ testToResponse, timesTest ] = cropTrialsByMsg( trials, startMsg, endMsg, offsets );
% testToResponse has all the trial info,from between the time you send the messages
% 'test'  to 'responseMade'


%----------------------------------
%----------------------------------

%load/create an image
img = uint8( zeros( 1000,1000,3));  %black image  (height, width, 3 color chanels) (make it your screen size)
 % or img =  imread( 'file location');
 
% show fixations on an image for trial 1, trial segment testToResponse
trial = 1;
sigma = 10;  % gaussian smoothing parameter
[mixedImage ] = showFixations( img, targetToInterstim(trial).fixPos, targetToInterstim(trial).fixDuration, sigma  );
