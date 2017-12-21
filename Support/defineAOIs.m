% Samuel Rivera
% March 15, 2014 
%
%  input: 
%     img: the loaded up image matrix
%     outDist:  radius for AOI
% 
%  notes:  click several points with left button, and the mean of those
%       will be AOI center.  Click anyhwere with right button to separate
%       from next AOI.
%       Hit return to end input.


function aois = defineAOIs( img, outDist, showFigure )

if nargin < 1
    img = imread( '../cat1_33336.png');
end
if nargin < 2
    outDist = 300;
end
if nargin < 3
    showFigure = 0;
end


imshow( img);

% remove last right click if at end
[x,y,button] = ginput();
if button(end) == 3
    button(end) = [];
    x(end) = [];
    y(end) = [];
end

%find index of splitting for AOIs
split = find( button==3);

% define aois
numAOIs = length(split)+1;
aois = zeros( 2, numAOIs);
startIdx = 1;
for i1 = 1:(numAOIs-1)
    endIdx = split(i1)-1;
    aois(:,i1) = [ mean( x(startIdx:endIdx)) ; mean( y(startIdx:endIdx)) ];
    startIdx = split(i1)+1;
end
aois(:,end) = [ mean( x(startIdx:end)) ; mean( y(startIdx:end)) ];


% save( '../treeAois.mat', 'aois');
if showFigure
    viewAOILandscape( aois, outDist, img, showFigure );
end







