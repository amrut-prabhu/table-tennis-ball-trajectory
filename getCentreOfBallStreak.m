% Function to from.
% Input:
%   window (uint8): Submatrix of the video frame containing the streak of the moving ball.
%   startX (double): x coordinate at which the window starts in the frame.
%   startY (double): y coordinate at which the window starts in the frame.
% Output:
%   x (double): x coordinate of the center of the ball streak in the frame.
%   y (double): y coordinate of the center of the ball streak in the frame.
function [x, y] = getCentreOfBallStreak(window, startX, startY)
% fprintf("In function getCentreOfBallStreak()\n");

% ================================Constants================================
% Threshold used to classify a pixel as belonging to the streak of the ball
BALL_PIXEL_THRESHOLD = 10;

% Dimensions of window
[HEIGHT, WIDTH] = size(window);

% ===========================Logic/Implementation==========================
% Get max value of each row and each column of the window
maxOfRows = max(window,[],2);
maxOfCols = max(window,[],1);

% Represnets the min and max coordinates of the ball streak in the window
minX = find(maxOfCols > BALL_PIXEL_THRESHOLD, 1, 'first');
maxX = find(maxOfCols > BALL_PIXEL_THRESHOLD, 1, 'last');

minY = find(maxOfRows > BALL_PIXEL_THRESHOLD, 1, 'first');
maxY = find(maxOfRows > BALL_PIXEL_THRESHOLD, 1, 'last');

% fprintf("x=%d,%d y=%d,%d\n",minX,maxX,minY,maxY);

% x = (startX + (startX + WIDTH-1)) / 2;
% y = (startY + (startY + HEIGHT-1)) / 2;
x = startX + ((minX + maxX) / 2);
y = startY + ((minY + maxY) / 2);

end