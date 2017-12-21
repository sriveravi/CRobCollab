% Notes: calculates 2-norm distance from target vector to all query vectors
%
% syntax:  dist = calcEuclidDist( target, query)
%
% Inputs:
%   target: (d by 1) vector of the target vector
%   query: (d by N) matrix of the query vectors (dimensionality is d, num
%       samples is N )
% 
% Outputs:
%   dist: vector of all 2-Norm distances

function dist = calc2Dist( target, query)


dist = ( repmat(target,1,size(query,2)) - query);
dist = sqrt(sum(dist.^2,1));
        
        