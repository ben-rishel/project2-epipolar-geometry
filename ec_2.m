%{
Script that uses homographies to generate top-down views of the floor from both source images without user input.
Adapted from the provided planewarpdemo.m code from the course

Step 1: Set the floor region in world coordinates
Step 2: Read source images
Step 3: Load camera parameters
Step 4: Compute homographies from the floor to the source images
Step 5: Make output images using the same scale along X and Y
Step 6: Compute homographies from output to source coordinates
Step 7: Warp the source images into the output images
Step 8: Display results
%}

% 1. Set the floor region in world coordinates

% fixed bounds in mm select the floor area shown in output
% estimated using task 3.4 code
Xmin = -4500;
Xmax = 6500;
Ymin = -6000;
Ymax = 5000;

% 2. Read source images
source1 = imread(fullfile('Project2DataFiles', 'im1corrected.jpg'));
source2 = imread(fullfile('Project2DataFiles', 'im2corrected.jpg'));
[nr1,nc1,nb1] = size(source1);
[nr2,nc2,nb2] = size(source2);

% 3. Load camera parameters
cameraData1 = load(fullfile('Project2DataFiles', 'Parameters_V1_1.mat'));
cameraData2 = load(fullfile('Project2DataFiles', 'Parameters_V2_1.mat'));
cam1 = cameraData1.Parameters;
cam2 = cameraData2.Parameters;

% 4. Compute homographies from the floor to the source images

% combine intrinsic and extrinsic matrices for each camera
P1 = cam1.Kmat * cam1.Pmat;
P2 = cam2.Kmat * cam2.Pmat;

% obtain homography between floor coords and source image coords
% for floor, Z=0, so the third column contributes nothing
H1 = P1(:, [1,2,4]);
H2 = P2(:, [1,2,4]);

% 5. Make output images using the same scale along X and Y

% equal X and Y scales preserve angles and relative distances on the floor
s = min([(nc1-1)/(Xmax-Xmin), (nr1-1)/(Ymax-Ymin), (nc2-1)/(Xmax-Xmin), (nr2-1)/(Ymax-Ymin)]);
outCols = ceil(s*(Xmax-Xmin)) + 1;
outRows = ceil(s*(Ymax-Ymin)) + 1;
dest1 = zeros(outRows,outCols,nb1);
dest2 = zeros(outRows,outCols,nb2);

% 6. Compute homographies from output to source coordinates

% S converts output pixels to floor X-Y coordinates
S = [1/s 0 Xmin - 1/s; 0 -1/s Ymax + 1/s; 0 0 1];
% combine output-to-floor and floor-to-source transforms
Hd1 = H1*S;
Hd2 = H2*S;

% 7. Warp the source images into the output images

% make a grid of output pixel coordinates
[xx,yy] = meshgrid(1:outCols, 1:outRows);

% divide by the homogeneous coordinate to obtain source pixel locations
denom1 = Hd1(3,1)*xx + Hd1(3,2)*yy + Hd1(3,3);
hxintrp1 = (Hd1(1,1)*xx + Hd1(1,2)*yy + Hd1(1,3)) ./ denom1;
hyintrp1 = (Hd1(2,1)*xx + Hd1(2,2)*yy + Hd1(2,3)) ./ denom1;

denom2 = Hd2(3,1)*xx + Hd2(3,2)*yy + Hd2(3,3);
hxintrp2 = (Hd2(1,1)*xx + Hd2(1,2)*yy + Hd2(1,3)) ./ denom2;
hyintrp2 = (Hd2(2,1)*xx + Hd2(2,2)*yy + Hd2(2,3)) ./ denom2;

% interpolate each source color channel at the computed source locations
for b = 1:nb1
    dest1(:,:,b) = interp2(double(source1(:,:,b)), hxintrp1,hyintrp1,'linear',0)/255.0;
end
for b = 1:nb2
    dest2(:,:,b) = interp2(double(source2(:,:,b)), hxintrp2,hyintrp2,'linear',0)/255.0;
end

% 8. Display results
fig1 = figure(1);
imagesc(dest1); axis image;
title('Camera 1 top-down view');

waitfor(fig1);

figure(2);
imagesc(dest2); axis image;
title('Camera 2 top-down view');