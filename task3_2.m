%{
Script that applies the projectPoints3Dto2D function.
1. Load camera parameters
2. Load 3D points
3. Read the two corrected images
4. Call the projectPoints3Dto2D function for each camera
5. Show the images with their projected points to check for accuracy
%}

% 1. Load camera parameters
ParametersV1 = load(fullfile("Project2DataFiles", "Parameters_V1_1.mat"));
ParametersV2 = load(fullfile("Project2DataFiles", "Parameters_V2_1.mat"));

cam1 = ParametersV1.Parameters;
cam2 = ParametersV2.Parameters;

% 2. Load 3D points

points3DData = load(fullfile("Project2DataFiles", "mocapPoints3D.mat"));
points3D = points3DData.pts3D;

% 3. Read the two corrected images

imageV1 = imread(fullfile("Project2DataFiles", "im1corrected.jpg"));
imageV2 = imread(fullfile("Project2DataFiles", "im2corrected.jpg"));

% 4. Call the projectPoints3Dto2D function for each camera

points2DV1 = projectPoints3Dto2D(points3D, cam1);
points2DV2 = projectPoints3Dto2D(points3D, cam2);

% 5. Show the images with their projected points to check for accuracy

figure;

% showing camera 1 points
subplot(1,2,1); % puts image on the left
imshow(imageV1); % draws image
hold on; % keeps the image there while drawing 2D points
plot(points2DV1(1,:), points2DV1(2,:), 'r.', 'MarkerSize', 15); % plots red dots at 2D points
title('Camera 1 projection');

% showing camera 2 points
subplot(1,2,2); 
imshow(imageV2); 
hold on;
plot(points2DV2(1,:), points2DV2(2,:), 'r.', 'MarkerSize', 15);
title('Camera 2 projection');