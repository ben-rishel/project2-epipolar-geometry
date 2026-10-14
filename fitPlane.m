function [a, b, c, d] = fitPlane(pts)
    % fitPlane Fit a plane through three 3D points
    % pts: 3x3 matrix, one point per column [X; Y; Z], must not be collinear
    % a, b, c: unit normal of the plane
    % d: plane offset, so the plane is a*X + b*Y + c*Z + d = 0
    
    % split points into separate 3x1 vectors
    p1 = pts(:, 1);
    p2 = pts(:, 2);
    p3 = pts(:, 3);

    % normal is perpendicular to the two vectors lying in the plane
    n = cross(p2 - p1, p3 - p1);
    n = n / norm(n);

    % unpack coefficients
    a = n(1);
    b = n(2);
    c = n(3);

    % plane passes through p1, so n'*p1 + d = 0
    d = -n' * p1;
end