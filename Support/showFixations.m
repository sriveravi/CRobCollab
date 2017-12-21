function [mixedImage, sigma] = showFixations( img, fixPos, fixDuration, sigma  )

% inputs:
%     img: file name, or image matrix
%     fixPos: like [x x x; y y y]
%     fixDuration: corresponding durations
%     sigma: smoothing width


%load img if file name given
if ischar( img )
    img = imread( img );
end

s= size(img);

[fixScape, sigma] = calcFixHeatMapWeighted( fixPos, fixDuration, s(1:2), sigma );
mixedImage = mixRGBAndGray( img, fixScape );

imshow(mixedImage);
pause(.01);
