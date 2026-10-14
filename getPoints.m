function [pts1, pts2] = getPoints(im1, im2, n, description)
    % getPoints Have the user click n matching points in each of the two views
    % im1, im2: the two corrected images
    % n: number of points to click
    % description: string telling the user what to click
    % pts1, pts2: 2xn pixel locations [u; v] in view 1 and view 2

    figure;
    imshow(im1, 'InitialMagnification', 'fit');
    title(description);
    [u, v] = ginput(n);
    pts1 = [u(:)'; v(:)'];

    figure;
    imshow(im2, 'InitialMagnification', 'fit');
    title(description);
    [u, v] = ginput(n);
    pts2 = [u(:)'; v(:)'];
end