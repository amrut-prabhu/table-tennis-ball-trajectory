% Triangulate 3D positions using SVD
clear all;
close all;

% camera 1
R1 = [9.6428667991264605e-01 -2.6484969138677328e-01 -2.4165916859785336e-03;
    -8.9795446022112396e-02 -3.1832382771611223e-01 -9.4371961862719200e-01;
    2.4917459103354755e-01 9.1023325674273947e-01 -3.3073772313234923e-01];

t1 = [1.3305621037591506e-01;
    -2.5319578738559911e-01;
    2.2444637695699150e+00];

t1 = -inv(R1) * t1;

K1 = [870.14531487461625 0 949.42001822880479;
    0 870.14531487461625 487.20049852775117; 
    0 0 1];

% camera 2
R2 = [9.4962278945631540e-01 3.1338395965783683e-01 -2.6554800661627576e-03; 
    1.1546856489995427e-01 -3.5774736713426591e-01 -9.2665194751235791e-01; 
    -2.9134784753821596e-01 8.7966318277945221e-01 -3.7591104878304971e-01];

t2 = [-4.2633372670025989e-02; 
    -3.5441906393933242e-01; 
    2.2750378317324982e+00];

t2 = -inv(R2) * t2;

K2 = [893.34367240024267 0 949.96816131377727;
    0 893.34367240024267 594.79562177577259;
    0 0 1];

% camera 3
R3 = [-9.9541881789113029e-01 3.8473906154401757e-02 -8.7527912881817604e-02;
    9.1201836523849486e-02 6.5687400820094410e-01 -7.4846426926387233e-01;
    2.8698466908561492e-02 -7.5301812454631367e-01 -6.5737363964632056e-01];

t3 = [-6.0451734755080713e-02; 
    -3.9533167111966377e-01; 
    2.2979640654841407e+00];

t3 = -inv(R3) * t3;

K3 = [872.90852997159800 0 944.45161471037636;
    0 872.90852997159800 564.47334036925656;
    0 0 1];

for i = 0 : 9
    figH = figure;
    results_path = fullfile(pwd, 'results');

    % Plot camera locations
    scatter3(t1(1), t1(2), t1(3));
    hold on;
    scatter3(t2(1), t2(2), t2(3));
    hold on;
    scatter3(t3(1), t3(2), t3(3));
    hold on;
    
    % Plot camera 1 axes
    plot3([t1(1) t1(1)+ R1(1, 1)], [t1(2) t1(2) + R1(1, 2)], [t1(3) t1(3) + R1(1, 3)]);
    plot3([t1(1) t1(1)+ R1(2, 1)], [t1(2) t1(2) + R1(2, 2)], [t1(3) t1(3) + R1(2, 3)]);
    plot3([t1(1) t1(1)+ R1(3, 1)], [t1(2) t1(2) + R1(3, 2)], [t1(3) t1(3) + R1(3, 3)]);
    hold on;
    
    % Plot camera 2 axes
    plot3([t2(1) t2(1)+ R2(1, 1)], [t2(2) t2(2) + R2(1, 2)], [t2(3) t2(3) + R2(1, 3)]);
    plot3([t2(1) t2(1)+ R2(2, 1)], [t2(2) t2(2) + R2(2, 2)], [t2(3) t2(3) + R2(2, 3)]);
    plot3([t2(1) t2(1)+ R2(3, 1)], [t2(2) t2(2) + R2(3, 2)], [t2(3) t2(3) + R2(3, 3)]);
    hold on;
    
    % Plot camera 3 axes
    plot3([t3(1) t3(1)+ R3(1, 1)], [t3(2) t3(2) + R3(1, 2)], [t3(3) t3(3) + R3(1, 3)]);
    plot3([t3(1) t3(1)+ R3(2, 1)], [t3(2) t3(2) + R3(2, 2)], [t3(3) t3(3) + R3(2, 3)]);
    plot3([t3(1) t3(1)+ R3(3, 1)], [t3(2) t3(2) + R3(3, 2)], [t3(3) t3(3) + R3(3, 3)]);
    hold on;
    
    % Process points and plot a scatter plot 
    f = {strcat('CAM1-', num2str(i), '_cleaned.csv'), strcat('CAM2-', num2str(i), '_cleaned.csv'), strcat('CAM3-', num2str(i), '_cleaned.csv')};
    res = triangulate_fn(f, R1, t1, K1, R2, t2, K2, R3, t3, K3);
    disp(res);
    
    % Plot trajectory scatter plot
    p = fullfile(results_path, strcat('3dpts_', num2str(i), '.csv'));
    csvwrite(p, res);
    scatter3(res(:, 1), res(:, 2), res(:, 3));
    hold on;
    
    % Draw line through the plot - TODO: should fit a smooth curve
    plot3(res(:, 1), res(:, 2), res(:, 3));
    hold on;
    smooth = smoothdata(res, 1, 'sgolay', 5);
    plot3(smooth(:, 1), smooth(:, 2), smooth(:, 3));
    hold on;
    
    % Plot the table 
    [x y] = meshgrid(-2:0.1:2);
    tableHeight = 0.09;
    s = surf(x, y, tableHeight + zeros(size(x)));
    
    % Set axes limits
    xlim([-1 2])
    ylim([-2.5 2.5])
    zlim([-0.5 1.5])
    
    % Store trajectory
    p = fullfile(results_path, strcat('traj_', num2str(i), '.jpg'));
    print(figH, '-djpeg', p);
end

% Implement triangulation
% Precondition: size(data1, 1) = size(data2, 1) = size(data3, 1)
function points3D = triangulate_fn(f, R1, t1, K1, R2, t2, K2, R3, t3, K3)
    % Read data from csv
    data_path = fullfile(pwd, 'Clean Data');  
    p = fullfile(data_path, f{1});
    points_1 = csvread(p, 1, 4);
    p = fullfile(data_path, f{2});
    points_2 = csvread(p, 1, 4);
    p = fullfile(data_path, f{3});
    points_3 = csvread(p, 1, 4);
    
    % Prepare the 2D points
    points_1 = prepare_2d_pos(points_1);
    points_2 = prepare_2d_pos(points_2);
    points_3 = prepare_2d_pos(points_3);
    
    % Triangulate for each point
    npts = size(points_1, 1);
    points3D = zeros(npts, 3);
    
    % For each point
    for i = 1 : npts
        pt_cam1 = points_1(i, :);
        pt_cam2 = points_2(i, :);
        pt_cam3 = points_3(i, :);
        
        [q1, k1] = construct_mat(pt_cam1, R1, t1, K1);
        [q2, k2] = construct_mat(pt_cam2, R2, t2, K2);
        [q3, k3] = construct_mat(pt_cam3, R3, t3, K3);
        
        Q = [q1; q2; q3];
        
        % Solving Q * res = zeros(6, 1), we get the solution
        disp(Q);
        x = inv(transpose(Q) * Q) * transpose(Q) * [k1; k2; k3];
        disp("LEAST SQUARES OVERDETERMINED");
        disp(x);
        
        disp("MATLAB LINEAR LS");
        x = lsqlin(Q, [k1; k2; k3]);
        disp(x);
        
        disp("Q\c");
        disp(Q\[k1; k2; k3]);
        
        disp("SVD");
        Q = [q1 -k1; q2 -k2; q3 -k3];
        [~, S, V] = svd(Q);
        disp(S);
        res = V(:, size(V, 2));
        res = res / res(4);
        res = res(1 : 3);
        
        points3D(i, :) = res;
    end
end

% Construct equation for each point
function [mat, k1k2] = construct_mat(pt, R, t, K)
    fx = K(1, 1); % scalar
    fy = K(2, 2); % scalar
    If = R(1, :); % i row vector 
    Jf = R(2, :); % j row vector
    Kf = R(3, :); % k row vector
    
    x0 = K(1, 3) - 960; % scalar offset x
    y0 = K(2, 3) - 540; % scalar offset y
    
    x = pt(1); % scalar
    y = pt(2); % scalar
    
    A = fx * If - (x - x0) * Kf; % equation for x 
    B = fy * Jf - (y - y0) * Kf; % equation for y
    
    k1k2 = [dot(A, t); dot(B, t)]; 
    mat = [A; B];
end

% Prepares the 2D co-ordinates by adding a z column with value 1
function points2D = prepare_2d_pos(p)
    [r, ~] = size(p);
    points2D = [p(:, 1) - 960 p(:, 2) - 540 ones(r, 1)];
end