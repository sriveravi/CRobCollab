function [img] = showFixSacX( img, fixPos, sacStart, sacEnd   )

% inputs:
%     img: file name, or image matrix
%     fixPos: like [x x x; y y y]
%     fixDuration: corresponding durations
%     sigma: smoothing width


%load img if file name given
if ischar( img )
    img = imread( img );
end

% s= size(img);
% [fixScape, sigma] = calcFixHeatMap( fixPos, fixDuration, s(1:2), sigma );
% mixedImage = mixRGBAndGray( img, fixScape );

imshow(img);
hold on
for i1 = 1:size(fixPos,2)
   plot( fixPos(1,i1), fixPos(2,i1), 'wo', 'markersize', 6, ...
       'MarkerFaceColor', 'w', 'markeredgecolor', 'k'); 
end

for i1 = 1:size(sacEnd,2)
   plot( [sacStart(1,i1) sacEnd(1,i1)], [sacStart(2,i1) sacEnd(2,i1)], 'r-', 'markersize', 6, ...
       'MarkerFaceColor', 'r', 'markeredgecolor', 'w'); 
   plot( sacEnd(1,i1), sacEnd(2,i1), 'rd', 'markersize', 6, ...
       'MarkerFaceColor', 'r', 'markeredgecolor', 'w'); 
end


hold off

pause(.1);
