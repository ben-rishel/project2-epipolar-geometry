function [croppedImage, croppedCam] = cropView(image, cam, rect)
    % cropView Crop an image and update the camera intrinsics to match
    % image: image to crop
    % cam: camera parameters for the image
    % rect: cropping rectangle [col, row, width, height], where (col, row) is
    %       the upper left pixel kept from the original image
    % croppedImage: the cropped image
    % croppedCam: camera parameters that project into the cropped image's pixels

    % 1. Crop the image
    % 2. Shift the principal point by the crop offset
    % 3. Rebuild Kmat from the shifted principal point

    col = rect(1);
    row = rect(2);
    width = rect(3);
    height = rect(4);

    % 1. Crop the image
    croppedImage = image(row:row + height - 1, col:col + width - 1, :);

    % 2. Shift the principal point
    % pixel (col, row) in the original becomes pixel (1, 1) in the crop, so every
    % pixel moves by the same offset:
    %   u_crop = u - (col - 1),  v_crop = v - (row - 1)
    % Cropping only moves the image origin, so focal length and skew don't change.
    % Only the principal point (the pixel where the optical axis hits the image) moves
    offset = [col - 1, row - 1];
    croppedCam = cam;
    croppedCam.prinpoint = cam.prinpoint - offset;

    % 3. Rebuild Kmat (same construction as task3_1.m)
    % this equals A * Kmat with A = [1 0 -(col-1); 0 1 -(row-1); 0 0 1]
    croppedCam.Kmat = [cam.foclen, cam.skew, croppedCam.prinpoint(1);
        0, cam.foclen, croppedCam.prinpoint(2);
        0, 0, 1];
end
