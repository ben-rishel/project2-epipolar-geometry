function points3D = triangulatePoints(points2D1, cam1, points2D2, cam2)
    % triangulatePoints Recover 3D points from corresponding 2D points in two views
    % points2D1, points2D2: 2xN corresponding pixel locations in each view
    % cam1, cam2: camera parameters
    % points3D: 3xN recovered 3D points (midpoint of the closest points on the two rays)

    [c1, u1] = viewingRays(points2D1, cam1);
    [c2, u2] = viewingRays(points2D2, cam2);

    N = size(points2D1, 2);
    points3D = zeros(3, N);

    for k = 1:N
        % get kth viewing rays
        u1k = u1(:, k);
        u2k = u2(:, k);

        % find unit vector perpendicular to both rays
        u3k = cross(u1k, u2k);
        u3k = u3k / norm(u3k);

        % a*u1 + d*u3 - b*u2 = c2 - c1
        % ->
        % [u1, u3, -u2] * [a; d; b] = c2 - c1
        x = [u1k, u3k, -u2k] \ (c2 - c1);
        a = x(1);
        b = x(3);

        P1 = c1 + a * u1k;
        P2 = c2 + b * u2k;

        points3D(:, k) = (P1 + P2) / 2;
    end