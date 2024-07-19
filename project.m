% Run script to generate low-resolution images
disp('Running generate_low_res_images.m...');
generate_low_res_images;

% Run script to train the SRCNN model
disp('Running train_srcnn.m...');
train_srcnn;

% Run script to import and use the trained SRCNN model
disp('Running srcnn.m...');
srcnn;

disp('All scripts have been run successfully.');
