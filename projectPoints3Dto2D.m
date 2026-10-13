function points2D = projectPoints3Dto2D(points3D, camera)
    % PROJECTPOINTS3DTO2D Project 3D world points into pixel coordinates
    % points3D: 3xN world points
    % camera: camera parameters
    % points2D: 2xN coordinates [u, v]
    
    % 1. Make the 3D points homogeneous
    % 2. Apply the pinhole camera chain (world to camera to homogeneous pixels)
    % 3. Perform homogeneous division to obtain pixel coordinates
    % 4. Return 2D points
    
    % 1. Make the 3D points homogeneous
    pointsHomogeneous = [points3D; ones(1, size(points3D, 2))];
    
    % 2. Apply the pinhole camera chain
    projected = camera.Kmat * camera.Pmat * pointsHomogeneous;
    
    % 3. Perform homogeneous division to obtain pixel coordinates
    points2D = projected(1:2, :) ./ projected(3, :);

end