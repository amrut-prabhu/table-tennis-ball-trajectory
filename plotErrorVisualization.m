% Visualize actual vs smoothed data
function plotErrorVisualization(i, res, results_path)
figH = figure;
figName = strcat('Actual vs Smooth Coordinates for Sequence: ', num2str(i));
set(figH, 'NumberTitle', 'off', 'Name', figName);

% Smooth data
smooth = smoothdata(res, 1, 'sgolay', 5);

% Error: x
subplot(3, 3, 1);
plot(res(:, 1));
hold on;
plot(smooth(:, 1));
title('X Coordinates');

% Error: y
subplot(3, 3, 2);
plot(res(:, 2));
hold on;
plot(smooth(:, 2));
title('Y Coordinates');

% Error: z
subplot(3, 3, 3);
plot(res(:, 3));
hold on;
plot(smooth(:, 3));
title('Z Coordinates');

hold on;

% Plot best fit with (x, y, z)
subplot(3, 3, [4, 9]);

% camera 1
R1 = [9.6428667991264605e-01 -2.6484969138677328e-01 -2.4165916859785336e-03;
    -8.9795446022112396e-02 -3.1832382771611223e-01 -9.4371961862719200e-01;
    2.4917459103354755e-01 9.1023325674273947e-01 -3.3073772313234923e-01];

t1 = [1.3305621037591506e-01;
    -2.5319578738559911e-01;
    2.2444637695699150e+00];

t1 = -inv(R1) * t1;

% camera 2
R2 = [9.4962278945631540e-01 3.1338395965783683e-01 -2.6554800661627576e-03;
    1.1546856489995427e-01 -3.5774736713426591e-01 -9.2665194751235791e-01;
    -2.9134784753821596e-01 8.7966318277945221e-01 -3.7591104878304971e-01];

t2 = [-4.2633372670025989e-02;
    -3.5441906393933242e-01;
    2.2750378317324982e+00];

t2 = -inv(R2) * t2;

% camera 3
R3 = [-9.9541881789113029e-01 3.8473906154401757e-02 -8.7527912881817604e-02;
    9.1201836523849486e-02 6.5687400820094410e-01 -7.4846426926387233e-01;
    2.8698466908561492e-02 -7.5301812454631367e-01 -6.5737363964632056e-01];

t3 = [-6.0451734755080713e-02;
    -3.9533167111966377e-01;
    2.2979640654841407e+00];

t3 = -inv(R3) * t3;

% Plot camera locations
scatter3(t1(1), t1(2), t1(3));
hold on;
scatter3(t2(1), t2(2), t2(3));
hold on;
scatter3(t3(1), t3(2), t3(3));
hold on;

% Plot camera 1 axes
plot3([t1(1) t1(1)+ R1(1, 1)], [t1(2) t1(2) + R1(1, 2)], [t1(3) t1(3) + R1(1, 3)], 'Color', [255, 0, 0] / 255);
plot3([t1(1) t1(1)+ R1(2, 1)], [t1(2) t1(2) + R1(2, 2)], [t1(3) t1(3) + R1(2, 3)], 'Color', [0, 255, 0] / 255);
plot3([t1(1) t1(1)+ R1(3, 1)], [t1(2) t1(2) + R1(3, 2)], [t1(3) t1(3) + R1(3, 3)], 'Color', [0, 0, 255] / 255);
hold on;

% Plot camera 2 axes
plot3([t2(1) t2(1)+ R2(1, 1)], [t2(2) t2(2) + R2(1, 2)], [t2(3) t2(3) + R2(1, 3)], 'Color', [255, 0, 0] / 255);
plot3([t2(1) t2(1)+ R2(2, 1)], [t2(2) t2(2) + R2(2, 2)], [t2(3) t2(3) + R2(2, 3)], 'Color', [0, 255, 0] / 255);
plot3([t2(1) t2(1)+ R2(3, 1)], [t2(2) t2(2) + R2(3, 2)], [t2(3) t2(3) + R2(3, 3)], 'Color', [0, 0, 255] / 255);
hold on;

% Plot camera 3 axes
plot3([t3(1) t3(1)+ R3(1, 1)], [t3(2) t3(2) + R3(1, 2)], [t3(3) t3(3) + R3(1, 3)], 'Color', [255, 0, 0] / 255);
plot3([t3(1) t3(1)+ R3(2, 1)], [t3(2) t3(2) + R3(2, 2)], [t3(3) t3(3) + R3(2, 3)], 'Color', [0, 255, 0] / 255);
plot3([t3(1) t3(1)+ R3(3, 1)], [t3(2) t3(2) + R3(3, 2)], [t3(3) t3(3) + R3(3, 3)], 'Color', [0, 0, 255] / 255);
hold on;

% Plot points
plot3(res(:, 1), res(:, 2), res(:, 3), 'MarkerEdgeColor', [0 0 0.5]);
hold on;

% Plot smooth curve for data points
plot3(smooth(:, 1), smooth(:, 2), smooth(:, 3), 'LineWidth', 1.0);
hold on;

% Display Standard Deviation
dim = [0.15 0.15 .3 .3];
sd = get_sd_dev(res, smooth);
str = {'Standard Deviation', sd};
text(1, 1.5, 1, str);

% Set axes limits
xlim([-1 2])
ylim([-2.5 2.5])
zlim([-0.5 1.5])

legend('Actual Data', 'Smooth Data')
title('Error Analysis');

% Save figure as .jpg
p = fullfile(results_path, strcat('error_visualization_', num2str(i), '.jpg'));
print(figH, '-djpeg', p);
end

% Get the deviation between projection and smoothed curve points
% Precondition: Number of rows in res and smooth are equal
function sd = get_sd_dev(res, smooth)
sd = 0;
[r, ~] = size(res);

for i = 1 : r
    distance = norm(res(i, :) - smooth(i, :));
    sd  = sd + (distance * distance);
end
sd = sqrt(sd);
end