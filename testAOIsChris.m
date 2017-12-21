% Samuel Rivera
% March 27, 2014

% load( '../../InfantCatLabels/Analysis/treeAois.mat', 'aois');

 path( path, 'Support');

% the x x x;
%     y y y   coordinates  
aois = [ 20,  50,  100;
         20,  150,  300];

% here read your own image     
img = imread( 'media/New_Volume/InfantCatLabels/Analysis/cat1_33336.png');



radius = 30;

showFigure = 1;
viewAOILandscape( aois, radius, img, showFigure );


