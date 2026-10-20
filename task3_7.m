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

% 5. Map a subset of the points to epipolar lines in the other image
idx = 1:5:size(points3D, 2); % every 5th point to keep the plots readable
% Add 1s at bottom to make points homogeneous since not homogeneous when
% returned from projectPoints3Dto2D
p1 = [points2DV1; ones(1, size(points2DV1, 2))];
p2 = [points2DV2; ones(1, size(points2DV2, 2))];

SEDcalibrated = 0;

for i=1:size(p1, 2)
    x1 = p1(:,i);
    x2 = p2(:,i);

    l1 = F' * x2;
    l2 = F * x1;

    d1 = abs(x1' * l1) / sqrt(l1(1)^2 + l1(2)^2);
    d2 = abs(x2' * l2) / sqrt(l2(1)^2 + l2(2)^2);
    
    % Accumulate squared distances for SED
    SEDcalibrated = SEDcalibrated + d1^2 + d2^2;

end

SEDcalibrated = SEDcalibrated / (2*size(p1, 2));

SEDeightpoint = 0;

for i=1:size(p1, 2)
    x1 = p1(:,i);
    x2 = p2(:,i);

    l1 = Fmat' * x2;
    l2 = Fmat * x1;

    d1 = abs(x1' * l1) / sqrt(l1(1)^2 + l1(2)^2);
    d2 = abs(x2' * l2) / sqrt(l2(1)^2 + l2(2)^2);
    
    % Accumulate squared distances for SED
    SEDcalibrated = SEDcalibrated + d1^2 + d2^2;
    
end

SEDeightpoint = SEDeightpoint / (2 * size(p1, 2));

fprintf('Calibrated F SED:   %.6f pixels^2\n', SEDcalibrated);
fprintf('Eight-Point F SED:  %.6f pixels^2\n', SEDeightpoint);