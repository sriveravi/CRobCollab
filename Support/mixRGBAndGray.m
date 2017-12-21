% returns an image which is a mixture of an RGB image and a grayscale image

function mixedImage = mixRGBAndGray( oriImage, grayImage )
grayScalar = .5*255./max(max(grayImage));

if length(size( oriImage ))==2  %if grayscale
    mixedImage = .3.*oriImage + uint8(grayScalar.*grayImage); 
else % its color
    mixedImage = .5.*oriImage + repmat(uint8(grayScalar.*grayImage), [1,1,3]);
end

