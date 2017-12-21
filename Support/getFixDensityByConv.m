
function density = getFixDensityByConv( durationMap, sigma )


%convolve maps with 2d Gaussian kernel
% matlabpool 4;
% display('Convolving Duration Based Fixation Density Maps');


if nargin < 2 || isempty( sigma)
    sigma= 10;
end
map_size =size( durationMap); % [600 800];
gauss_kernel = fspecial('gaussian',map_size,sigma);

% conv_maps = cell(1,num_images);
% 
% parfor(counter = 1:num_images,4)
%    conv_maps{1,counter} = imfilter(fixation_maps_duration{4,counter},gauss_kernel,'conv');
% end
% matlabpool close;
% for cur_image = 1:num_images
%     fixation_maps_duration{5,cur_image} = conv_maps{1,cur_image};
% end

density = imfilter(durationMap, gauss_kernel, 'conv');
    

%normalize maps
% display('Normalizing Duration Based Fixation Density Maps');
% for counter = 1:num_images
%     fixation_maps_duration{6,counter} = fixation_maps_duration{5,counter}/sum(fixation_maps_duration{5,counter}(:));
% end
