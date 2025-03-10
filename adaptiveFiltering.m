function output = adaptiveMedianFilter(input)

    % Makes sure input is in grayscale
    if size(input, 3) == 3
        input = rgb2gray(input);
    end

    % Max Window Size, for our purposes 7
    maxWindowSize = 7;
    
    % Gathers the Rows and Columns of the 2D input matrix
    [rows, cols] = size(input);
    output = input;

    % Takes account for the size size of the border
    padSize = floor(maxWindowSize / 2);
    paddedInput = padarray(input, [padSize, padSize], 'symmetric');
    
    for i = 1:rows
        for j = 1:cols
            %Initial Window Size
            windowSize = 3;
            
            % Allows us to work with double values to avoid rounding errors
            currentValue = double(input(i, j));

            
            pixelReplaced = false;
            
            % Runs the adaptive mean filtering
            while windowSize <= maxWindowSize
                halfWindowSize = floor(windowSize / 2);

                % Determines where to start and end the window given the
                % border padding
                rowStart = i + padSize - halfWindowSize;
                rowEnd = i + padSize + halfWindowSize;
                colStart = j + padSize - halfWindowSize;
                colEnd = j + padSize + halfWindowSize;

                %Gets the current window and sorts the values
                window = paddedInput(rowStart:rowEnd, colStart:colEnd);
                sortedWindow = sort(window(:));

                % Gets the mean, min, and max values of the sorted window
                medianValue = median(sortedWindow);
                minValue = sortedWindow(1);
                maxValue = sortedWindow(end);

                % Checks if the current pixel is valid
                if currentValue > minValue && currentValue < maxValue
                    output(i, j) = currentValue;
                    pixelReplaced = true;
                    break;
                else
                    % If the pixel is not valid, replace it with the median
                    if windowSize == maxWindowSize
                        output(i, j) = medianValue;
                        pixelReplaced = true;
                        break;
                    else
                        %Increases the window size until we get to the max
                        windowSize = windowSize + 2;
                    end
                end
            end
            %If the pixel is not replaced by the end of the whilem replace
            %with the median value
            if ~pixelReplaced
                output(i, j) = medianValue;
            end
        end
    end
    % Converts the output back to uint8 so we can display it
    output = uint8(output);  
end

% Define the directory containing the images
inputDir = 'inputImagePath';
outputDir = 'savedImagePath';

% Get a list of all image files in the directory
imageFiles = dir(fullfile(inputDir, '*.jpg')); 

% Creates a new directory if it does not exist
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% Loop through each image file
for k = 1:length(imageFiles)

    disp("Image: ")
    disp(k)

    % Gets the image
    inputFileName = fullfile(inputDir, imageFiles(k).name);
    inputImage = imread(inputFileName);
    
    % Applies Adaptive Median Filter to denoise the image
    outputImage = adaptiveMedianFilter(inputImage);
    for i = 1:3
        outputImage = adaptiveMedianFilter(uint8(outputImage));
    end
    
    % Construction of the Output file
    [~, name, ext] = fileparts(imageFiles(k).name);
    outputFileName = fullfile(outputDir, [name '_filtered' ext]);
    imwrite(outputImage, outputFileName);
end

disp('Batch processing complete.');
