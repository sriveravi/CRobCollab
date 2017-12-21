% % Assumes bmp/jpg images, can change in function ( by line 66)

imageFolder = './';
markingsFolder= 'Annotations/';
numPts = 4;


% 4 point regular 
%---------------------
% we mark all deterministic features, such as if there are 4 feet.  If
% there are less than 4, the additional AOIs will just be off off the
% image - I think (-1,-1)



% 1 point system (unique)
%--------------------
% just mark the closes point that is a deterministic feature.  
%  New-New objects click somewhere off object (far corner)


% 4 point system (common frame)
%-------------------
% 1: between eyes
% 2: closes shoulder
% 3: back fin
% 4: closest foot





pauloMarkerSupremeCustomList(imageFolder, markingsFolder, numPts )



