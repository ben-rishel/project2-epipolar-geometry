function [c, u] = viewingRays(points2D, camera)
    % viewingRays Obtain the location of the camera and the unit vector pointing out from the camera into the world
    % points2D: 2xN pixel locations
    % camera: camera parameters

    N = size(points2D, 2); % number of points
    R = camera.Rmat; % world to camera rotation
    K = camera.Kmat; % camera intrinsics
    tau = camera.Pmat(:, 4); % camera translation vector

    p_m = [points2D; ones(1, N)]; % homogeneous points

    c = -R' * tau; % camera center in world coordinates
    v = R' * (K \ p_m); % vector pointing out from camera into the world
    u = v ./ vecnorm(v); % convert to unit vector
end