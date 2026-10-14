%{
Script that uses triangulation to make 3D measurements in the scene from hand-clicked matching points in the two views.
Steps 1-2: Taken from task3_2.m
Step 3: Fit a plane to the floor and verify it is roughly Z = 0
Step 4: Fit a plane to the striped wall and report the equation
Step 5: Measure the height of the doorway
Step 6: Measure the height of the person
Step 7: Locate the center of the camera mounted on the tripod
%}

% 1. Load camera parameters
ParametersV1 = load(fullfile("Project2DataFiles", "Parameters_V1_1.mat"));
ParametersV2 = load(fullfile("Project2DataFiles", "Parameters_V2_1.mat"));
cam1 = ParametersV1.Parameters;
cam2 = ParametersV2.Parameters;

% 2. Read in images
im1 = imread(fullfile("Project2DataFiles", "im1corrected.jpg"));
im2 = imread(fullfile("Project2DataFiles", "im2corrected.jpg"));

% 3. Floor

% prompt user to select floor points
[pts1, pts2] = getPoints(im1, im2, 3, 'Select 3 floor points from each image (same spots)');

% triangulate to convert to 3D world coordinates
floor3D = triangulatePoints(pts1, cam1, pts2, cam2);

% fit a plane using the 3 points
[fa, fb, fc, fd] = fitPlane(floor3D);

% flip the whole equation so the floor normal points up (positive z), matching Z = 0
% this step is necessary to use arccos to compute the angle error of the normal vector
if fc < 0
    fa = -fa;
    fb = -fb;
    fc = -fc;
    fd = -fd;
end
fn = [fa; fb; fc]; % floor normal as a column vector

fprintf('The equation of the floor is %.4fx + %.4fy + %.4fz + %.2f = 0\n', fa, fb, fc, fd);

% verify the floor is roughly Z = 0
tiltDeg = acosd(fc);   % angle between the floor normal and the Z axis
fprintf('Floor normal is tilted %.2f degrees from the Z axis\n', tiltDeg);
fprintf('\n');

% 4. Wall

% prompt user to select floor points
[pts1, pts2] = getPoints(im1, im2, 3, 'Select 3 striped wall points from each image (same spots)');

% triangulate to convert to 3D world coordinates
wall3D = triangulatePoints(pts1, cam1, pts2, cam2);

% fit a plane using the 3 points
[wa, wb, wc, wd] = fitPlane(wall3D);

fprintf('The equation of the wall is %.4fx + %.4fy + %.4fz + %.2f = 0\n', wa, wb, wc, wd);
fprintf('\n');

% 5. Doorway height

% prompt user to select top of doorway point
[pts1, pts2] = getPoints(im1, im2, 1, 'Click the top right corner of the doorway');

% triangulate to convert to 3D world coordinates
doorway3D = triangulatePoints(pts1, cam1, pts2, cam2);

fprintf('Doorway height: %.2f mm\n', doorway3D(3));
fprintf('\n');

% 6. Person height

% prompt user to select top of person's head point
[pts1, pts2] = getPoints(im1, im2, 1, 'Click the top of the head of the person');

% triangulate to convert to 3D world coordinates
head3D = triangulatePoints(pts1, cam1, pts2, cam2);

fprintf('Person height: %.2f mm\n', head3D(3));
fprintf('\n');

% 7. Striped wall camera location

% prompt user to select location of camera near striped wall point
[pts1, pts2] = getPoints(im1, im2, 1, 'Click the camera mounted on a tripod next to the striped wall');

% triangulate to convert to 3D world coordinates
camera3D = triangulatePoints(pts1, cam1, pts2, cam2);

fprintf('Tripod camera center: [%.1f, %.1f, %.1f] mm\n', camera3D);
fprintf('\n');