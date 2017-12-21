% Samuel Rivera
% July 13, 2011
% 
% Syntax: [ AOISequence AOIDuration] =calcAOIFixSequence( eyePos, aoiCenter, maxDist, maxFixations) 
% 
% Inputs:
%  P: fixations like  [x x x; y y y]
%  aoiCenter: coordinates of AOI in image scale, returned by 'returnAOICenters.m'
%               in form of 2xD
%  maxDist: maximum distance to a nearest AOI, anything further
%   considered not part of any AOI, returned by 'returnAOICenters.m'
% 
% Outputs:
%  AOIOrderList: AOI sequence
% 

function [ AOIOrderList ] =calcMMFixSequence( P, aoiCenter, maxDist, imSize ) 


% make sure no nans in aoiCenter matrix, set to 0
aoiCenter( isnan(aoiCenter)) = 0;

% initialize in case
if nargin < 3 || isempty(maxDist)
    maxDist = inf;
end
if nargin < 4 || isempty(imSize)
    imSize = [inf; inf];  % [ xMax; yMax ]
end





% % initialize some paramters
% fixationWinSize = 6;
% fixationThreshold = 15;
% if nargin < 4 || isempty( maxFixations )
%     maxFixations = 3;
% end

% % scale eye tracks(using default value ), calculate fixations
% [ eyePos imRange] = scaleEyeTrack( eyePos,  [] ); 
% [ fixationVector P ]  = codeFixations( eyePos, fixationWinSize, fixationThreshold );

% initialize some variables
% numAOI = size(aoiCenter,2);
numFixation = size( P,2);
AOIOrderList = zeros(numFixation,1); 
outsideAOI = size( aoiCenter,2)+1;
% AOIDurationList =  zeros(numFixation,1);
effectivNumFixation = 0;

if ~isempty(aoiCenter) 
    
    % find AOI fixation sequence
    for i1 = 1:numFixation  
        % if fixation inside image, find closest AOI
        if (P(1,i1) > 0 && P(1,i1) <= imSize(1))  ... % x-range
                && (P(2,i1) > 0 && P(2,i1) <= imSize(2)) % y-range

            dist = calc2Dist( P(:,i1), aoiCenter); % 2-norm distance
            [minDist minIdx] = min( dist);  
            effectivNumFixation = effectivNumFixation+1;
        else
            % othersie, the minimum distance is outside
            minDist = inf;
            effectivNumFixation = effectivNumFixation+1;
        end

        % add to AOI if close enough   
        if minDist < maxDist                
            AOIOrderList(effectivNumFixation) = minIdx;
        else %otherwise, add to the 'outside' AOI
            AOIOrderList(effectivNumFixation) = outsideAOI;
        end            
    end
end

% code as a matrix of indicator variables
% if effectivNumFixation >0  
%     AOISequence = zeros( numAOI, maxFixations); 
%     AOIDuration = zeros( 1, maxFixations);
%     for i1 = 1:min(effectivNumFixation, maxFixations) 
%         AOISequence(AOIOrderList(i1),i1) = 1; % indicator for AOI (1)
%         AOIDuration(i1) = AOIDurationList(i1);
%     end
%     
% else % all 0 if no relevant AOI
%     AOISequence = zeros( numAOI,maxFixations);
%     AOIDuration = zeros( 1, maxFixations);
% end




