% Load the trained SRCNN model
load('srcnn_model.mat', 'srcnn_model');

% Define directories
lr_dir = 'LR_images';  
output_dir = 'HR_images_using_SRCNN'; 
if ~exist(lr_dir, 'dir')
    mkdir(lr_dir);
end

% Get list of low-resolution images
lr_images = dir(fullfile(lr_dir, '*.png')); % Assuming the images are in PNG format

% Loop through each low-resolution image
for i = 1:length(lr_images)
    % Load low-resolution image
    lr_image_path = fullfile(lr_dir, lr_images(i).name);
    lr_image = imread(lr_image_path);
    if size(lr_image, 3) == 3
        lr_image = rgb2gray(lr_image);
    end
    lr_image = imresize(lr_image, [256 256]);
    lr_image = im2single(lr_image); 

    % Apply SRCNN model to enhance the image
    enhanced_image = predict(srcnn_model, lr_image);

    % Save the enhanced image
    output_image_path = fullfile(output_dir, lr_images(i).name);
    imwrite(enhanced_image, output_image_path);
end

disp('Super-resolution applied and images saved.');