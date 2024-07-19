% Define directories
hr_dir = 'HR_images'; 
lr_dir = 'LR_images';  

% Get list of images
hr_images = dir(fullfile(hr_dir, '*.png'));
lr_images = dir(fullfile(lr_dir, '*.png'));
num_images = length(hr_images);

% Preallocate cell arrays to hold image data
high_res_images = cell(num_images, 1);
low_res_images = cell(num_images, 1);

% Load and preprocess images
for i = 1:num_images
    % Load high-resolution image
    hr_image_path = fullfile(hr_dir, hr_images(i).name);
    hr_image = imread(hr_image_path);
    if size(hr_image, 3) == 3
        hr_image = rgb2gray(hr_image);
    end
    hr_image = imresize(hr_image, [256 256]); % Resize to 256x256 or any desired consistent size
    high_res_images{i} = im2single(hr_image);
    
    % Load low-resolution image
    lr_image_path = fullfile(lr_dir, lr_images(i).name);
    lr_image = imread(lr_image_path);
    if size(lr_image, 3) == 3
        lr_image = rgb2gray(lr_image);
    end
    lr_image = imresize(lr_image, [256 256]); % Resize to 256x256 or any desired consistent size
    low_res_images{i} = im2single(lr_image);
end

% Convert cell arrays to 4D arrays for training
high_res_images = cat(4, high_res_images{:});
low_res_images = cat(4, low_res_images{:});

% Define SRCNN model
layers = [
    imageInputLayer([256 256 1]) % Match the resized image dimensions
    convolution2dLayer(9, 64, 'Padding', 'same')
    reluLayer()
    convolution2dLayer(5, 32, 'Padding', 'same')
    reluLayer()
    convolution2dLayer(5, 1, 'Padding', 'same')
    regressionLayer()
];

% Set training options
options = trainingOptions('adam', ...
    'InitialLearnRate', 0.001, ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 16, ...
    'Shuffle', 'every-epoch', ...
    'Plots', 'training-progress');

% Train the SRCNN model
srcnn_model = trainNetwork(low_res_images, high_res_images, layers, options);

% Save only the necessary model
save('srcnn_model.mat', 'srcnn_model');

% Clear variables to save memory
clear high_res_images low_res_images;

disp('Model training completed and saved.');
