
image_folder = pwd; % change to pathway to folder you want to read

file_pattern = fullfile(image_folder, '*.png');
image_files = dir(file_pattern);

% Loop through each image file
for k = 1:length(image_files)
    base_file_name = image_files(k).name;
    full_file_name = fullfile(image_folder, base_file_name);
    fprintf(1, 'Now reading %s\n', full_file_name);
    
    % Read the image
    img = imread(full_file_name);

    
    output = DCT(img,100); % the second number changes the resolution
    figure;
    imshow(output);

end
