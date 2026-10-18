%{
Script that computes the fundamental matrix from the known camera
calibration parameters and checks it by drawing epipolar lines.
Steps 1-3: Taken from task3_2.m
Step 4: Compute F from the calibration parameters
Step 5: Map image 1 points to epipolar lines in image 2 and vice versa
Step 6: Show the epipolar lines on both images
%}

% 1. Load camera parameters
ParametersV1 = load(fullfile("Project2DataFiles", "Parameters_V1_1.mat"));
ParametersV2 = load(fullfile("Project2DataFiles", "Parameters_V2_1.mat"));

cam1 = ParametersV1.Parameters;
cam2 = ParametersV2.Parameters;

% 2. Load 3D points
points3DData = load(fullfile("Project2DataFiles", "mocapPoints3D.mat"));
points3D = points3DData.pts3D;

% 3. Read the two corrected images and project the 3D points into each
imageV1 = imread(fullfile("Project2DataFiles", "im1corrected.jpg"));
imageV2 = imread(fullfile("Project2DataFiles", "im2corrected.jpg"));

points2DV1 = projectPoints3Dto2D(points3D, cam1);
points2DV2 = projectPoints3Dto2D(points3D, cam2);

% 4. Compute F from the calibration parameters
[F, E, R, T] = computeFundamental(cam1, cam2);

fprintf('Rotation of camera 2 relative to camera 1:\n');
disp(R);
fprintf('Location of camera 2 in camera 1 coordinates (mm): [%.1f, %.1f, %.1f]\n', T);
fprintf('Essential matrix E:\n');
disp(E);
fprintf('Fundamental matrix F:\n');
fprintf('%14.6e %14.6e %14.6e\n', F'); % entries span many orders of magnitude

% 5. Map a subset of the points to epipolar lines in the other image
idx = 1:5:size(points3D, 2); % every 5th point to keep the plots readable
% Add 1s at bottom to make points homogeneous since not homogeneous when
% returned from projectPoints3Dto2D
p1 = [points2DV1(:, idx); ones(1, numel(idx))];
p2 = [points2DV2(:, idx); ones(1, numel(idx))];

% Both lines come from the same constraint p2' * F * p1 = 0, grouped two ways
% A line [a; b; c] holds the points with a*u + b*v + c = 0, i.e. [a b c] * [u; v; 1] = 0

% Line in image 2: group as p2' * (F * p1) = 0, so l2 = F * p1
linesInV2 = F * p1; % image 1 points -> epipolar lines in image 2

% Line in image 1: group as (p2' * F) * p1 = 0, so p2' * F is the line,
% but as a 1x3 row. Transpose it into a 3x1 column using (A * B)' = B' * A':
%   l1 = (p2' * F)' = F' * p2
linesInV1 = F' * p2; % image 2 points -> epipolar lines in image 1

% 6. Show the epipolar lines on both images
figure;

% image 2 points drawn on their epipolar lines in image 1
subplot(1,2,1);
drawEpipolarLines(imageV1, linesInV1, points2DV1(:, idx), 'Image 1: epipolar lines from image 2 points');

% image 1 points drawn on their epipolar lines in image 2
subplot(1,2,2);
drawEpipolarLines(imageV2, linesInV2, points2DV2(:, idx), 'Image 2: epipolar lines from image 1 points');
