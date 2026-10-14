%{
Script that applies the projectPoints3Dto2D function.
Steps 1-3: Taken from task3_2.m
Step 5: Get viewing rays
Step 6: Triangulate to recover 3D points
Step 7: Measure error against original 3D points 
%}

% 1. Load camera parameters
ParametersV1 = load(fullfile("Project2DataFiles", "Parameters_V1_1.mat"));
ParametersV2 = load(fullfile("Project2DataFiles", "Parameters_V2_1.mat"));

cam1 = ParametersV1.Parameters;
cam2 = ParametersV2.Parameters;

% 2. Load 3D points
points3DData = load(fullfile("Project2DataFiles", "mocapPoints3D.mat"));
points3D = points3DData.pts3D;

% 3. Call the projectPoints3Dto2D function for each camera
points2DV1 = projectPoints3Dto2D(points3D, cam1);
points2DV2 = projectPoints3Dto2D(points3D, cam2);

% 4. Triangulate points
recovered3D = triangulatePoints(points2DV1, cam1, points2DV2, cam2);

% 5. Measure error
sqDist = sum((recovered3D - points3D).^2, 1);
MSE = mean(sqDist);

fprintf('Mean squared error: %g\n', MSE);