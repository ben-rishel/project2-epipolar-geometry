function drawEpipolarLines(image, lines, points, titleText)
    % drawEpipolarLines Draw epipolar lines and their matching points on an image
    % image: image to draw on
    % lines: 3xN line coefficients [a; b; c] with a*u + b*v + c = 0
    % points: 2xN pixel locations [u; v] that should lie on the lines
    % titleText: title of the plot

    [height, width, ~] = size(image);
    colors = hsv(size(lines, 2)); % distinct color for each line/point pair

    imshow(image);
    hold on;
    for i = 1:size(lines, 2)
        a = lines(1, i);
        b = lines(2, i);
        c = lines(3, i);

        % solve for whichever coordinate keeps the line well conditioned
        if abs(b) > abs(a)
            u = [1, width];
            v = -(a * u + c) / b;
        else
            v = [1, height];
            u = -(b * v + c) / a;
        end

        plot(u, v, '-', 'Color', colors(i, :), 'LineWidth', 1.5);
        plot(points(1, i), points(2, i), 'o', 'Color', colors(i, :), ...
            'MarkerFaceColor', colors(i, :), 'MarkerSize', 6);
    end
    title(titleText);
    hold off;
end

