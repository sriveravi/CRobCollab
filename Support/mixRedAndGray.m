 % returns an image which is a mixture of an RGB image and a grayscale image

function mixedImage = mixRedAndGray( oriImage, grayImage )
% grayScalar = .7*255./max(max(grayImage));

if length(size( oriImage ))==2  %if grayscale
    
    [X, map] = gray2ind( oriImage );
    oriImage = ind2rgb(X,map);

%     mixedImage = .3.*oriImage + uint8(grayScalar.*grayImage); 
%     
% else % its color
%     mixedImage = .8.*oriImage + repmat(uint8(grayScalar.*grayImage), [1,1,3]);
end

redImage = zeros( size(grayImage,1), size(grayImage,2), 3);
redImage(:,:,1) = grayImage;
redImage = redImage./(max(max(max(redImage)))*(2) );  %1.2,   .75

% mixedImage = oriImage + uint8(grayScalar.*grayImage); 
mixedImage = oriImage + redImage;