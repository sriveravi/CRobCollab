% Samuel Rivera


function [trials, allStarts, ghostTrials, allEnds]= cropTrialsByMsg( trials, startMsg, endMsg, offsets )
%  startMsg: message sent at stimulus onset
%  endMsg: message sent at stimulus offset (ie, blank screen message )
% 
%  ghostTrials: trials that did not actually happen, know from messages

if nargin < 1
    trials = loadELfile;
end
if nargin < 2
    startMsg = 'LoomVid';
end
if nargin < 3
    endMsg = 'EnterVid';
end
if nargin < 4 || isempty(offsets)
    offsets = zeros(2, length(trials) );  % first row value for (ms) to look before/after start message,
end                    %    negative number looks before, positive looks after 
                       % second for end message time, similarly to above


N = length( trials);
allStarts = zeros(1, N);  
allEnds =  zeros(1, N);  
ghostTrials = zeros( N,1);

for i1 = 1:N
    trial = trials(i1);
    
    % find start time for fixations, and end time
    sIdx = find(strcmp(startMsg, trial.msg), 1,'first');
    eIdx = find(strcmp(endMsg, trial.msg), 1,'first');
    if ~isempty(sIdx)        
        startTime = trial.msgTime{sIdx} + offsets(1,i1);
        endTime = trial.msgTime{eIdx} + offsets(2,i1);
        
        %endTime - startTime
    else  % we may have ghost trials
        ghostTrials(i1) = 1;
        startTime = inf;
        endTime = -inf;
    end
    allStarts(i1) = startTime;
    allEnds(i1) = endTime;
    %---------
    % cropping the fixations
    %   keep fixations starting after start time, and starting before end time
    fStIdx = find( trial.fixStart > (startTime ), 1, 'first');
    fEdIdx = find( trial.fixStart < (endTime ), 1, 'last');
    
    % if start after end index, actually not found between start/eIdx
    if fStIdx > fEdIdx
        fStIdx = [];
        fEdIdx = [];
    end

    % now crop them out
    trial.fixPos = trial.fixPos( :,fStIdx:fEdIdx);
    trial.fixDuration = trial.fixDuration( fStIdx:fEdIdx);
    trial.fixStart = trial.fixStart( fStIdx:fEdIdx);
    trial.fixEnd = trial.fixEnd( fStIdx:fEdIdx);
    trial.pupil = trial.pupil( fStIdx:fEdIdx);

    %---------
    % cropping the saccades
    %   keep saccades starting after start time, and starting before end time
    fStIdx = find( trial.sacStartTime > startTime , 1, 'first');
    fEdIdx = find( trial.sacStartTime < endTime , 1, 'last');

    % if start after end index, actually not found between start/eIdx
    if fStIdx > fEdIdx
        fStIdx = [];
        fEdIdx = [];
    end
    
    % now crop them out
    trial.sacStartPos = trial.sacStartPos( :,fStIdx:fEdIdx);
    trial.sacEndPos = trial.sacEndPos( :,fStIdx:fEdIdx);
    trial.sacDuration = trial.sacDuration( fStIdx:fEdIdx);
    trial.sacStartTime = trial.sacStartTime( fStIdx:fEdIdx);
    trial.sacEndTime = trial.sacEndTime( fStIdx:fEdIdx);
    trial.sacAmp = trial.sacAmp( fStIdx:fEdIdx);
    trial.sacVel = trial.sacVel( fStIdx:fEdIdx);

    trials(i1) = trial;
end

% remove ghost trials
trials(ghostTrials ==1) = [];
allStarts(ghostTrials ==1) = [];