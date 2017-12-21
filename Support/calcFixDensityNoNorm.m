% Samuel Rivera
% 
% Syntax: [ AOIDensity effectivNumFixation]  = calcFixDensity( fixPosVector, fixDurVector, aoiCenter, maxDist ) 
% 
% Inputs:
%  fixPosVector:  [x x x; y y y]
%  fixDurVector: vector of corresponding durations 
%  aoiCenter: coordinates of AOI centers, [ x x x; y y y ]
%  maxDist: maximum distance to a nearest AOI, anything further
%   considered not part of any AOI, returned by 'returnAOICenters.m'
% 
% Outputs:
%  AOIDensity: vector of number of relative time spent at particular AOI


function [ AOIDensity, effectivNumFixation]  = calcFixDensityNoNorm( fixPosVector, fixDurVector, ...
                        aoiCenter, maxDist, numFixation, imSize ) 

if nargin < 5 || isempty( numFixation)
    numFixation = inf;
end
if nargin < 6
    imSize = [Inf,Inf]; %x,y
end


% calcFixDensityNoNorm


%calculate AOI fixation density
numAOI = size(aoiCenter,2);
numFixation = min( numFixation, size( fixPosVector,2));  % maximum faxations
AOIDensity = zeros( numAOI,1);
effectivNumFixation = 0;

for i1 = 1:numFixation  
    
    % if fixation inside image, then get density
    if (fixPosVector(1,i1) > 0 && fixPosVector(1,i1) <= imSize(1))  ... % x-range
            && (fixPosVector(2,i1) > 0 && fixPosVector(2,i1) <= imSize(2)) % y-range   

        dist = calc2Dist( fixPosVector(:,i1), aoiCenter); % 2-norm 
        [minDist minIdx] = min( dist);    
        if minDist < maxDist 
            effectivNumFixation = effectivNumFixation+1;
            AOIDensity(minIdx) = AOIDensity(minIdx) + fixDurVector(i1);
        end       
    
    end
end

% % % normalize so the sum is 1
% % if effectivNumFixation > 0
% %     AOIDensity = AOIDensity/sum( AOIDensity);
% % end


