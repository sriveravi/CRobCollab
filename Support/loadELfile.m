% Samuel Rivera
% Oct 8, 2013
% This file loads the EyeLink asc file and returns a trial array
%   containing the fixation, saccade, and message information
% 
%   for example:
% 
% trial(1)
% 
% ans = 
% 
%           fixPos: [2x18 double]
%      fixDuration: [1x18 double]
%              msg: {122x1 cell}
%          msgTime: {122x1 cell}
%         fixStart: [1x18 double]
%           fixEnd: [1x18 double]
%            pupil: [1x18 double]
%      sacStartPos: [2x17 double]
%        sacEndPos: [2x17 double]
%      sacDuration: [1x17 double]
%     sacStartTime: [1x17 double]
%       sacEndTime: [1x17 double]
%           sacAmp: [1x17 double]
%           sacVel: [1x17 double]
%            trial: '1'
%            delay: '750'


function trial = loadELfile( ascFile )

if nargin < 1
%     ascFile = '/home/rivera.162/CatLabels/ExperimentResults/SilentCondition/Results6Sec/4495/4495.asc';
    ascFile = '/home/rivera.162/CatLabels/ExperimentResults/SilentCondition/Result700ms/results/4497/4497.asc';
end

fID = fopen( ascFile );


%initialize
trial(100).fixPos = [];
trial(100).fixDuration = [];
trial(100).fixStart = [];
trial(100).fixEnd = [];
trial(100).pupil = [];

trial(100).sacStartPos = [];
trial(100).sacEndPos = [];
trial(100).sacDuration = [];
trial(100).sacStartTime = [];
trial(100).sacEndTime = [];
trial(100).sacAmp = [];
trial(100).sacVel = [];

trialIdx = 0;
noFile = 0;


% skip stuff before first trial starts
line = fgetl(fID);
splitLine = strsplit(line );
while ~(strcmp( splitLine{1}, 'MSG' ) && strcmp( splitLine{3}, 'TRIALID' ))
    line = fgetl(fID);
%     if line == -1
%         break
%     end    
% line
    
    % if loaded up not a string
    if ~ischar(line)
        noFile = 1;
        break;
    end
   
    splitLine = strsplit(line ); 
    
end

if noFile  
    trial = [];
else

    % loop through each line, and read up data
    while ischar(line)

        splitLine = strsplit(line );

        % find trial start
        if strcmp( splitLine{1}, 'MSG' ) && strcmp( splitLine{3}, 'TRIALID' )
            %display( 'trial start')
            trialIdx = trialIdx+1;   
            fixIdx = 0;
            sacIdx = 0;
            msgIdx = 0;
        end

        % fixations
        if strcmp( splitLine{1}, 'EFIX' )
            fixIdx = fixIdx + 1;
            trial( trialIdx ).fixPos(:,fixIdx) = [ str2double(splitLine{6}); str2double(splitLine{7}) ];
            trial( trialIdx ).fixDuration(:,fixIdx) = [ str2double(splitLine{5})];
            trial( trialIdx ).fixStart(:,fixIdx) = [ str2double(splitLine{3})];
            trial( trialIdx ).fixEnd(:,fixIdx) = [ str2double(splitLine{4})];
            trial( trialIdx ).pupil(:,fixIdx) = [ str2double(splitLine{8})];
        end

        % saccades
        if strcmp( splitLine{1}, 'ESACC' )
            sacIdx = sacIdx + 1;
            trial( trialIdx ).sacStartPos(:,sacIdx) = [ str2double(splitLine{6}); str2double(splitLine{7}) ];
            trial( trialIdx ).sacEndPos(:,sacIdx) = [ str2double(splitLine{8}); str2double(splitLine{9}) ];       
            trial( trialIdx ).sacDuration(:,sacIdx) = [ str2double(splitLine{5})];        
            trial( trialIdx ).sacStartTime(:,sacIdx) = [ str2double(splitLine{3})];
            trial( trialIdx ).sacEndTime(:,sacIdx) = [ str2double(splitLine{4})];        
            trial( trialIdx ).sacAmp(:,sacIdx) = [ str2double(splitLine{10})]; % degrees
            trial( trialIdx ).sacVel(:,sacIdx) = [ str2double(splitLine{11})]; % dec/sec
        end 

        % custom variables
        if strcmp( splitLine{1}, 'MSG' ) && strcmp( splitLine{3}, '!V' )
            trial( trialIdx ).(splitLine{5}) = splitLine{6};
        end

        % messages
        if strcmp( splitLine{1}, 'MSG' ) && length( splitLine) == 4
            if ~strcmp( splitLine{4}, '0')
                msgIdx = msgIdx+1;
                trial( trialIdx ).msg{msgIdx,1} = splitLine{4};
                trial( trialIdx ).msgTime{msgIdx,1} = str2double(splitLine{2});
            end
        end

        % messages
        if strcmp( splitLine{1}, 'MSG' ) && length( splitLine) == 3
            if ~strcmp( splitLine{3}, '0')
                msgIdx = msgIdx+1;
                trial( trialIdx ).msg{msgIdx,1} = splitLine{3};
                trial( trialIdx ).msgTime{msgIdx,1} = str2double(splitLine{2});
            end
        end

        % get next line of file
        line = fgetl(fID);
    end

    % remove extra trials
    trial( trialIdx+1:end) = [];  % last trial isn't finished

end

fclose( fID);
%------------------------
% % show fixations on the trials
% downSize = .5;
% img = imread( 'Images/TestCat_InEnd.png' );
% img = imresize(img, downSize );
% for i1 = 1:length( trial)    
%     [mixedImage, sigma] = showFixations( img, downSize*trial(i1).fixPos, trial(i1).fixDuration, 20  );  
% end


