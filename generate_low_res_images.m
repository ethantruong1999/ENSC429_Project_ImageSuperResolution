% Define directories
hr_dir = 'HR_images'; 
lr_dir = 'LR_images';  
if ~exist(lr_dir, 'dir')
    mkdir(lr_dir);
end

% Downscale factor
scale = 2; % Example scale factor

% Get list of high-resolution images
hr_images = dir(fullfile(hr_dir, '*.png')); % Assuming the images are in PNG format

% Ensure there are no more than 100 images
num_images = length(hr_images);

% Preallocate cell arrays to hold image data
high_res_images = cell(num_images, 1);
low_res_images = cell(num_images, 1);

% Loop through each high-resolution image
for i = 1:num_images
    % Load high-resolution image
    hr_image_path = fullfile(hr_dir, hr_images(i).name);
    hr_image = imread(hr_image_path);
    if size(hr_image, 3) == 3
        hr_image = rgb2gray(hr_image);
    end
    hr_image = im2single(hr_image); % Convert to single precision
    
    % Resize high-resolution image to 256x256
    hr_image_resized = imresize(hr_image, [256 256]);
    high_res_images{i} = hr_image_resized;
    
    % Downscale the image and then resize to 256x256
    lr_image = imresize(hr_image, 1/scale, 'bicubic');
    lr_image_resized = imresize(lr_image, [256 256]);
    low_res_images{i} = lr_image_resized;
    
    % Save low-resolution image
    lr_image_path = fullfile(lr_dir, hr_images(i).name);
    imwrite(lr_image_resized, lr_image_path);
end

disp('Low-resolution images generated and resized to 256x256.');
