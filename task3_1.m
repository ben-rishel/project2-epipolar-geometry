%{
This script constructs the Kmat and Pmat for both camera 1 and camera 2
from the internal and external parameters, respectively. Then, it checks to
ensure that the Kmat and Pmat that are constructed are equivalent to the
given Kmat and Pmat. Lastly, the locations of the cameras are printed.
%}

%% Testing construction of Kmat of camera 1
ParametersV1 = load("Project2DataFiles\Parameters_V1_1.mat");

cam1 = ParametersV1.Parameters;

% creating Kmat for camera 1 based on definition in slides
kmat_test1 = [cam1.foclen, cam1.skew, cam1.prinpoint(1); 
    0, cam1.foclen, cam1.prinpoint(2);
    0, 0, 1];

% testing the difference between the test construction and given Kmat
differenceK1 = max(abs(kmat_test1(:) - cam1.Kmat(:)));

fprintf('Max absolute difference between test Kmat and provided Kmat (camera 1): %g\n', difference);

%% Testing construction of Kmat of camera 2
ParametersV2 = load("Project2DataFiles\Parameters_V2_1.mat");

cam2 = ParametersV2.Parameters;

% creating Kmat for camera 2 based on definition in slides
kmat_test2 = [cam2.foclen, cam2.skew, cam2.prinpoint(1); 
    0, cam2.foclen, cam2.prinpoint(2);
    0, 0, 1];

% testing the difference between the test construction and given Kmat
differenceK2 = max(abs(kmat_test2(:) - cam2.Kmat(:)));

fprintf('Max absolute difference between test Kmat and provided Kmat (camera 2): %g\n', difference);

%% Testing construction of Pmat of camera 1

C1 = cam1.position; %1x3
R1 = cam1.Rmat; %3x3

t1 = -R1 * C1'; % 3x3 x 3x1 = 3x1 column [tx; ty; tz]

% combining the partitioned matrices
Pmat_test1 = [R1, t1];

differenceP1 = max(abs(Pmat_test1(:) - cam1.Pmat(:)));

fprintf('Max absolute difference between test Pmat and provided Pmat (camera 1): %g\n', difference);

%% Testing construction of Pmat of camera 2

C2 = cam2.position; %1x3
R2 = cam2.Rmat; %3x3

t2 = -R2 * C2'; % 3x3 x 3x1 = 3x1 column [tx; ty; tz]

Pmat_test2 = [R2, t2];

differenceP2 = max(abs(Pmat_test2(:) - cam2.Pmat(:)));

fprintf('Max absolute difference between test Pmat and provided Pmat (camera 2): %g\n', difference);

%% Printing the locations of both cameras

fprintf('Camera 1 location (mm): [%.1f, %.1f, %.1f]\n', cam1.position);
fprintf('Camera 2 location (mm): [%.1f, %.1f, %.1f]\n', cam2.position);