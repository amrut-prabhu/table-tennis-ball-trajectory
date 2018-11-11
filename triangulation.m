% Triangulate 3D positions using Linear Least Squares Method
clear all;

f = {'data1.csv', 'data2.csv', 'data3.csv'};
res = triangulate_positions(f, R1, t1, R2, t2, R3, t3);
disp(res);

% Implement triangulation
% Precondition: size(data1, 1) = size(data2, 1) = size(data3, 1)
function points3D = triangulate_positions(f, R1, t1, R2, t2, R3, t3)
    % Get camera matrices
    P1 = get_camera_pose(R1, t1);
    P2 = get_camera_pose(R2, t2);
    P3 = get_camera_pose(R3, t3);
    
    % Read data from csv
    points_1 = csvread(f{1}, 0, 3);
    points_2 = csvread(f{2}, 0, 3);
    points_3 = csvread(f{3}, 0, 3);
    
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
        
        Q = [q1; q2; a3];
        
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
    P = [R t];
end