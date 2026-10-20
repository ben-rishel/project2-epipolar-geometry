
%{
Script that computes the fundamental matrix from the points selected in the
eight point algorithm.
Step 1: Load the corrected imaged
Step 2: Call 'eightpoint' function with images as arguments (user selects
the points)
Step 3: Display fundamental matrix
%}

% 1. Read the two corrected images
imageV1 = imread(fullfile("Project2DataFiles", "im1corrected.jpg"));
imageV2 = imread(fullfile("Project2DataFiles", "im2corrected.jpg"));

% 2. Call eightpoint function
Fmat = eightpoint(imageV1, imageV2)

% 3. Print Fundamental matrix
fprintf('Fundamental Matrix (F):\n');
fprintf('  %14.8f  %14.8f  %14.8f\n', Fmat.');