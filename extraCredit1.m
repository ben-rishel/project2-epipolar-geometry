%{
Script that crops both views tightly around the person, updates the camera
intrinsics and F matrix for the cropped views, and checks both.
Steps 1-3: Taken from task3_5.m
Step 4: Pick a cropping rectangle around the person in each view
Step 5: Crop the images, save them as new files, and update the cameras
Step 6: Check 3D to 2D projection in the cropped views
Step 7: Compute F for the cropped views and check its epipolar lines
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

% 4. Pick a cropping rectangle around the person in each view
% The projected mocap points outline the body, so take their bounding box and pad
% it so the head, hands, and feet (which extend past the markers) stay in frame
% The boundingRect function is defined further down this file
padding = 100; % pixels
rect1 = boundingRect(points2DV1, padding, size(imageV1));
rect2 = boundingRect(points2DV2, padding, size(imageV2));

fprintf('Crop rectangle view 1 [col, row, width, height]: [%d, %d, %d, %d]\n', rect1);
fprintf('Crop rectangle view 2 [col, row, width, height]: [%d, %d, %d, %d]\n', rect2);

% 5. Crop the images and update the cameras, saving the crops as new files
[croppedV1, croppedCam1] = cropView(imageV1, cam1, rect1);
[croppedV2, croppedCam2] = cropView(imageV2, cam2, rect2);

% No loss of quality
imwrite(croppedV1, fullfile("Project2DataFiles", "im1cropped.jpg"), 'Quality', 100);
imwrite(croppedV2, fullfile("Project2DataFiles", "im2cropped.jpg"), 'Quality', 100);

fprintf('Cropped Kmat (camera 1):\n');
disp(croppedCam1.Kmat);
fprintf('Cropped Kmat (camera 2):\n');
disp(croppedCam2.Kmat);

% 6. Check 3D to 2D projection in the cropped views
% project straight into the cropped views with the modified cameras
croppedPoints2DV1 = projectPoints3Dto2D(points3D, croppedCam1);
croppedPoints2DV2 = projectPoints3Dto2D(points3D, croppedCam2);

% these should equal the full-image projections shifted by the crop offset
shiftError1 = max(abs(croppedPoints2DV1 - (points2DV1 - [rect1(1) - 1; rect1(2) - 1])), [], 'all');
shiftError2 = max(abs(croppedPoints2DV2 - (points2DV2 - [rect2(1) - 1; rect2(2) - 1])), [], 'all');
fprintf('Max difference from shifted full-image projection (pixels): view 1 %g, view 2 %g\n', ...
    shiftError1, shiftError2);

figure;

subplot(1,2,1);
imshow(croppedV1);
hold on;
plot(croppedPoints2DV1(1,:), croppedPoints2DV1(2,:), 'r.', 'MarkerSize', 15);
title('Cropped camera 1 projection');

subplot(1,2,2);
imshow(croppedV2);
hold on;
plot(croppedPoints2DV2(1,:), croppedPoints2DV2(2,:), 'r.', 'MarkerSize', 15);
title('Cropped camera 2 projection');

% 7. Compute F for the cropped views and check its epipolar lines
% Cropping only changes K, and E depends only on R and T, so E is unchanged.
% Passing the cropped cameras into computeFundamental gives
%   F_crop = inv(K2_crop)' * E * inv(K1_crop)
[croppedF, ~, ~, ~] = computeFundamental(croppedCam1, croppedCam2);

fprintf('Fundamental matrix F for the cropped views:\n');
fprintf('%14.6e %14.6e %14.6e\n', croppedF'); % entries span many orders of magnitude

% the original F must not work on cropped pixels, which shows the update matters
F = computeFundamental(cam1, cam2);

p1 = [croppedPoints2DV1; ones(1, size(croppedPoints2DV1, 2))];
p2 = [croppedPoints2DV2; ones(1, size(croppedPoints2DV2, 2))];
fprintf('Mean distance of cropped points to their epipolar lines (pixels):\n');
fprintf('  cropped F:  %g\n', meanLineDistance(croppedF, p1, p2));
fprintf('  original F: %g\n', meanLineDistance(F, p1, p2));

idx = 1:5:size(points3D, 2); % every 5th point to keep the plots readable
linesInV2 = croppedF * p1(:, idx); % image 1 points -> epipolar lines in image 2
linesInV1 = croppedF' * p2(:, idx); % image 2 points -> epipolar lines in image 1

figure;

% image 1 points with the epipolar lines from their matching image 2 points
subplot(1,2,1);
drawEpipolarLines(croppedV1, linesInV1, croppedPoints2DV1(:, idx), 'Cropped image 1: epipolar lines from image 2 points');

% image 2 points with the epipolar lines from their matching image 1 points
subplot(1,2,2);
drawEpipolarLines(croppedV2, linesInV2, croppedPoints2DV2(:, idx), 'Cropped image 2: epipolar lines from image 1 points');


function rect = boundingRect(points, padding, imageSize)
    % boundingRect Padded bounding box of 2D points, clipped to the image
    % points: 2xN pixel locations [u; v]
    % padding: pixels added on every side
    % imageSize: size of the image, [height, width, ...]
    % rect: [col, row, width, height] with integer pixel values

    firstCol = max(1, floor(min(points(1,:)) - padding));
    firstRow = max(1, floor(min(points(2,:)) - padding));
    lastCol = min(imageSize(2), ceil(max(points(1,:)) + padding));
    lastRow = min(imageSize(1), ceil(max(points(2,:)) + padding));

    rect = [firstCol, firstRow, lastCol - firstCol + 1, lastRow - firstRow + 1];
end

function d = meanLineDistance(F, p1, p2)
    % meanLineDistance Mean point-to-epipolar-line distance over both images
    % F: fundamental matrix with p2' * F * p1 = 0
    % p1, p2: 3xN homogeneous matching points in image 1 and image 2
    % d: mean distance in pixels, using |a*u + b*v + c| / sqrt(a^2 + b^2)

    lines2 = F * p1;
    lines1 = F' * p2;
    d2 = abs(sum(p2 .* lines2)) ./ sqrt(lines2(1,:).^2 + lines2(2,:).^2);
    d1 = abs(sum(p1 .* lines1)) ./ sqrt(lines1(1,:).^2 + lines1(2,:).^2);
    d = mean([d1, d2]);
end
