
%{
Script that computes the fundamental matrix from the points selected in the
eight-point algorithm.
Step 1: Load the corrected images
Step 2: Call the 'eightpoint' function with images as arguments (user selects
the points)
Step 3: Display selected points
Step 4: Display the estimated fundamental matrix
%}

% 1. Load the corrected stereo image pair
imageV1 = imread(fullfile("Project2DataFiles", "im1corrected.jpg"));
imageV2 = imread(fullfile("Project2DataFiles", "im2corrected.jpg"));

% 2. Estimate F using the eight-point algorithm
[Feightpoint, pts1, pts2] = eightpoint(imageV1, imageV2);

% 3. Display the selected point correspondences
fprintf('imageV1 points (F):\n');
fprintf('  %14.8f  %14.8f\n', pts1');
fprintf('\nimageV2 points (F):\n');
fprintf('  %14.8f  %14.8f\n', pts2');

% 4. Display the estimated fundamental matrix
fprintf('\nFundamental Matrix (F):\n');
fprintf('  %14.8f  %14.8f  %14.8f\n', Feightpoint.');