function [F, E, R, T] = computeFundamental(cam1, cam2)
    % computeFundamental Compute the fundamental matrix from known camera calibration
    % cam1, cam2: camera parameters for view 1 and view 2
    % F: 3x3 fundamental matrix such that p2' * F * p1 = 0 (pixel coordinates)
    % E: 3x3 essential matrix such that x2' * E * x1 = 0 (camera coordinates)
    % R: rotation taking camera 1 axes to camera 2 axes
    % T: location of camera 2 in camera 1 coordinates

    % 1. Find the rotation and translation of camera 2 relative to camera 1
    % 2. Build the skew-symmetric matrix S from T
    % 3. Combine them into the essential matrix E = R S
    % 4. Convert E into pixel coordinates using the K matrices

    R1 = cam1.Rmat; % world to camera 1 rotation
    R2 = cam2.Rmat; % world to camera 2 rotation
    C1 = cam1.position'; % camera 1 center in world coordinates (3x1)
    C2 = cam2.position'; % camera 2 center in world coordinates (3x1)

    % 1. Relative rotation and translation

    % R: rotation from camera 1 coordinates to camera 2 coordinates
    % R1 rotates world coordinates into camera 1 coordinates
    % R1' reverses that conversion (a rotation's transpose is its inverse): camera 1 to world
    % R2 then rotates world into camera 2, so R2 * R1' goes camera 1 -> world -> camera 2
    % (read right to left, since R1' acts on the vector first)
    R = R2 * R1';

    % T: camera 2's position as seen from camera 1
    % C2 - C1 is the arrow from camera 1 to camera 2 in world coordinates,
    % and R1 rotates that arrow into camera 1 coordinates
    T = R1 * (C2 - C1);

    % 2. Skew-symmetric matrix so that S * x = cross(T, x)
    S = [0, -T(3), T(2);
        T(3), 0, -T(1);
        -T(2), T(1), 0];

    % 3. Essential matrix
    E = R * S;

    % 4. Fundamental matrix: F = K2^-T * E * K1^-1
    F = inv(cam2.Kmat)' * E * inv(cam1.Kmat);

    % F is only defined up to scale, so normalize it for readability
    F = F / norm(F, 'fro');
end
