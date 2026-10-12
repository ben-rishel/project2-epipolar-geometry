%% Testing construction of Kmat of camera 1
ParametersV1 = load("Project2DataFiles\Parameters_V1_1.mat");

cam1 = ParametersV1.Parameters;

kmat_test1 = [cam1.foclen, cam1.skew, cam1.prinpoint(1); 
    0, cam1.foclen, cam1.prinpoint(2);
    0, 0, 1];

% testing the difference between the test construction and given Kmat
difference = max(abs(kmat_test1(:) - cam1.Kmat(:)));

fprintf('Max absolute difference between test Kmat and provided Kmat (camera 1): %g\n', difference);

%% Testing construction of Kmat of camera 2
ParametersV2 = load("Project2DataFiles\Parameters_V2_1.mat");

cam2 = ParametersV2.Parameters;

kmat_test2 = [cam2.foclen, cam2.skew, cam2.prinpoint(1); 
    0, cam2.foclen, cam2.prinpoint(2);
    0, 0, 1];

% testing the difference between the test construction and given Kmat
difference = max(abs(kmat_test2(:) - cam2.Kmat(:)));

fprintf('Max absolute difference between test Kmat and provided Kmat (camera 2): %g\n', difference);

%% Testing construction of Pmat of camera 1

C = cam1.position; %1x3
R = cam1.Rmat; %3x3

t = -R * C'; % 3x3 x 3x1 = 3x1 column [tx; ty; tz]

Pmat_test1 = [R, t];

difference = max(abs(Pmat_test1(:) - cam1.Pmat(:)));

fprintf('Max absolute difference between test Pmat and provided Pmat (camera 1): %g\n', difference);

%% Testing construction of Pmat of camera 2

C = cam2.position; %1x3
R = cam2.Rmat; %3x3

t = -R * C'; % 3x3 x 3x1 = 3x1 column [tx; ty; tz]

Pmat_test2 = [R, t];

difference = max(abs(Pmat_test2(:) - cam2.Pmat(:)));

fprintf('Max absolute difference between test Pmat and provided Pmat (camera 2): %g\n', difference);

%% Printing the locations of both cameras

fprintf('Camera 1 location (mm): [%.1f, %.1f, %.1f]\n', cam1.position);
fprintf('Camera 2 location (mm): [%.1f, %.1f, %.1f]\n', cam2.position);