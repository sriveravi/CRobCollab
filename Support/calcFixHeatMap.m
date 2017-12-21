% Samuel Rivera
% June 27, 2011, updated April 5, 2012
% Notes: This function calculates a denisity of fixations over the entire
%   image, a time invariant feature.  With some gaussian smoothing.

% function [fixScape sigma] = calcFixHeatMap( fixPos, fixDuration, imageHW, sigma )
% 
% Inputs:
%   fixPos: [2xD] matrix with first row X, 2nd row Y coordinates of
%       fixations
%   fixDuration: corresponding duration of fixations
%   imageHW: [Height, width] of image
%   sigma: kernel bandwidth, leave as [] to calculate based on a % of
%         nearest neighbors
% 
% Outputs:
%   fixScape: density of fixations around image
%   sigma: sigma used (in case non specified and want to reuse)
% 


function [fixScape, sigma] = calcFixHeatMap( fixPos, fixDuration, imageHW, sigma )

fixPos = round( fixPos);
durationMap = zeros( imageHW);



for i1 = 1:length( fixDuration )
    if fixPos(1,i1) > 0 && fixPos(1,i1) < imageHW(2)
        if  fixPos(2,i1) > 0 && fixPos(2,i1) < imageHW(1)
                durationMap( fixPos(2,i1), fixPos(1,i1)) = durationMap( fixPos(2,i1), fixPos(1,i1))+1; 
        end
    end
end

%calc sigma if not given
if nargin < 4 || isempty(sigma)    
    NNPercent = 1/5;  %average distance of the nearest neighbors to calculate sigma 
    [ meanDist, allDist ] = calcPairwiseDistances( fixPos );
    allDist = sort( allDist, 'ascend');
    numNN = max( 1, floor(length(allDist)*NNPercent));
    sigma = mean( allDist(1:numNN));
end
 

fixScape = getFixDensityByConv( durationMap, sigma );
