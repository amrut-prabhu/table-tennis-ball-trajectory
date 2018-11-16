% Function to om.
% Input:
%   window (uint8): Submatrix of the video frame containing the streak of the moving ball.
% Output:
%   areBordersEmpty (logical): Boolean representing whether the window
%   completely encompasses the streak of the moving ball i.e. whether the
%   borders of the window are black and have no traces of white (moving ball).
function [areBordersEmpty] = hasEmptyBorders(window)
% fprintf("In function hasEmptyBorders()\n");

% ================================Constants================================
BLACK_THRESHOLD = 10;
[NUM_ROWS, NUM_COLS] = size(window);

% ===========================Logic/Implementation==========================
areBordersEmpty = false;

avgFirstRowValue = mean2(window(1,:));
avgLastRowValue = mean2(window(NUM_ROWS,:));

avgFirstColValue = mean2(window(:,1));
avgLastColValue = mean2(window(:, NUM_COLS));

% fprintf("%3.2f,%3.2f %3.2f,%3.2f\n",avgFirstRowValue,avgLastRowValue,avgFirstColValue,avgLastColValue);
% isBordersEmpty = isBordersEmpty && avgFirstRowValue;
% isBordersEmpty = isBordersEmpty && avgLastRowValue;
% isBordersEmpty = isBordersEmpty && avgFirstColValue;
% isBordersEmpty = isBordersEmpty && avgLastColValue;

if avgFirstRowValue < BLACK_THRESHOLD && avgLastRowValue < BLACK_THRESHOLD && avgFirstColValue < BLACK_THRESHOLD && avgLastColValue < BLACK_THRESHOLD
    % It is a valid window
    areBordersEmpty = true;
end

end
