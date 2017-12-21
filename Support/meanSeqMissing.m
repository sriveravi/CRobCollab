% Samuel Rivera
% 

function [xVals, mVals] = meanSeqMissing( vals, splitBy, missIndicator )


if nargin < 2 || isempty(splitBy)
    splitBy = 5;
end

if nargin <3 || isempty(missIndicator)
    missIndicator = -1;
end

% preallocate
N = length(vals);
x = 1:N;
x(vals == missIndicator) = [];
vals(vals == missIndicator) = [];

%for output
nOut = length(1:splitBy:(N));
mVals = zeros(1,nOut);
xVals = zeros(1,nOut);

% get means
ctr = 1;
for i1 =1:splitBy:(N)
    mVals(ctr) = mean(vals(x>=i1 & x <(i1+splitBy)));
    xVals(ctr) = i1+splitBy-1;
    ctr = ctr+1;
end

