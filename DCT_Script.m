
image_folder = pwd; % change to pathway to folder you want to read
outputDir = 'dctCompressedImages';
file_pattern = fullfile(image_folder, '*.png');
image_files = dir(file_pattern);


% Loop through each image file
for k = 1:length(image_files)
    base_file_name = image_files(k).name;



    full_file_name = fullfile(image_folder, base_file_name);
    fprintf(1, '\n\nNow reading %s\n', base_file_name);
    fileSize = dir(base_file_name).bytes;
    fprintf('Original File Size: %d \n', fileSize)
    % Read the image
    img = imread(full_file_name);


    outputImage = DCT(img,100);
    % figure;
    % imshow(outputImage);
    [~, name, ext] = fileparts(image_files(k).name);
    outputFileName = fullfile(outputDir, [name '_filtered' ext]);

    imwrite(outputImage, outputFileName)

    fileSizeFiltered = dir(outputFileName).bytes;
    fprintf('Filtered File Size: %d \n', fileSizeFiltered)
    % fileSize = image_files.bytes;

end
