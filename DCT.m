% close all
% clear
% 
% % Usage
% inputImage = imread('0001.png');
% figure;
% imshow(inputImage);
% output = DCT(inputImage,100);
% figure;
% imshow(output);


function output = DCT(input,deltaIn);

% Makes sure input is in grayscale
if size(input, 3) == 3
    input = im2gray(input);
end

% init variables
image = input;
block_size = 8;
delta = deltaIn;

% Ensure picture is correct size
[image_height, image_width] = size(image);
padded_height = ceil(image_height / block_size) * block_size;
padded_width = ceil(image_width / block_size) * block_size;
imagePadded = padarray(image, [padded_height - image_height, padded_width - image_width], 'post');
image_double = double(imagePadded);

% DCT Matrix for 8 size block
T = dct(eye(8));


% Calculate size of image
[height, width] = size(image_double);
reconstructed_image = zeros(height, width);

% DCT and DCT reconstruction
for row = 1:block_size:height
    for col = 1:block_size:width

        block = image_double(row:row+block_size-1, col:col+block_size-1);
        dct_coeffs = T * block * T';
        quantized_coeffs = round(dct_coeffs / delta);
        reconstructed_coeffs = quantized_coeffs * delta;
        reconstructed_block = T' * reconstructed_coeffs * T;
        reconstructed_image(row:row+block_size-1, col:col+block_size-1) = reconstructed_block;
    end
end


% Round and Clip Image
reconstructed_image_rounded = round(reconstructed_image);
reconstructed_image_clipped = max(min(reconstructed_image_rounded, 255), 0);

% remove extra rows and columns
rows_to_remove = image_height:padded_height;
cols_to_remove = image_width:padded_width;
reconstructed_image_clipped(rows_to_remove, :, :) = [];
reconstructed_image_clipped(:, cols_to_remove, :) = [];


output = uint8(reconstructed_image_clipped);
end






