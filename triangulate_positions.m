% Triangulate 3D positions using Linear Least Squares Method
clear all;
close all;

% camera 1
R1 = [9.6428667991264605e-01 -2.6484969138677328e-01 -2.4165916859785336e-03;
    -8.9795446022112396e-02 -3.1832382771611223e-01 -9.4371961862719200e-01;
    2.4917459103354755e-01 9.1023325674273947e-01 -3.3073772313234923e-01];

t1 = [1.3305621037591506e-01;
    -2.5319578738559911e-01;
    2.2444637695699150e+00];

% camera 2
R2 = [9.4962278945631540e-01 3.1338395965783683e-01 -2.6554800661627576e-03; 
    1.1546856489995427e-01 -3.5774736713426591e-01 -9.2665194751235791e-01; 
    -2.9134784753821596e-01 8.7966318277945221e-01 -3.7591104878304971e-01];

t2 = [-4.2633372670025989e-02; 
    -3.5441906393933242e-01; 
    2.2750378317324982e+00];

% camera 3
R3 = [-9.9541881789113029e-01 3.8473906154401757e-02 -8.7527912881817604e-02;
    9.1201836523849486e-02 6.5687400820094410e-01 -7.4846426926387233e-01;
    2.8698466908561492e-02 -7.5301812454631367e-01 -6.5737363964632056e-01];

t3 = [-6.0451734755080713e-02; 
    -3.9533167111966377e-01; 
    2.2979640654841407e+00];

% camera pose for all three cameras
% M1 = [R1 t1];
% M2 = [R2 t2];
% M3 = [R3 t3];

f = {'data1.csv', 'data2.csv', 'data3.csv'};
res = triangulate_fn(f, R1, t1, R2, t2, R3, t3);
disp(res);

% csvwrite('results.csv', res);
scatter3(res(:, 1), res(:, 2), res(:, 3));

% Implement triangulation
% Precondition: size(data1, 1) = size(data2, 1) = size(data3, 1)
function points3D = triangulate_fn(f, R1, t1, R2, t2, R3, t3)
    % Get camera pose(s)
    P1 = get_camera_pose(R1, t1);
    P2 = get_camera_pose(R2, t2);
    P3 = get_camera_pose(R3, t3);
    
    % Read data from csv
    points_1 = csvread(f{1}, 1, 3);
    points_2 = csvread(f{2}, 1, 3);
    points_3 = csvread(f{3}, 1, 3);
    
    % Prepare the 2D points
    points_1 = prepare_2d_pos(points_1);
    points_2 = prepare_2d_pos(points_2);
    points_3 = prepare_2d_pos(points_3);
    
    % Triagulate for each point
    npts = size(points_1, 1);
    points3D = zeros(npts, 3);
    
    % For each point
    for i = 1 : npts
        pt_cam1 = points_1(i, :);
        pt_cam2 = points_2(i, :);
        pt_cam3 = points_3(i, :);
        
        q1 = construct_mat(pt_cam1, P1);
        q2 = construct_mat(pt_cam2, P2);
        q3 = construct_mat(pt_cam3, P3);
        
        Q = [q1; q2; q3];
        
        % Solving Q * res = zeros(6, 1), we get the solution
        % Not sure if I am doing this part right
        [A B V] = svd(Q);
        res = V(:, size(V, 2));
        res = res / res(4);
        res = res(1 : 3);
        
        points3D(i, :) = res;
    end
end

% Contruct matrix for given point
function mat = construct_mat(pt, cam_mat)
    mat = [0 pt(3) -pt(2); -pt(3) 0 pt(1); pt(2) -pt(1) 0;] * cam_mat;
end

% Prepares the 2D co-ordinates by adding a z column with value 1
function points2D = prepare_2d_pos(p)
    [r c] = size(p);
    points2D = [p ones(r, 1)];
end

% Returns the camera pose for given values
function P = get_camera_pose(R, t)
    t = -inv(R) * t;
    P = [R t];
end