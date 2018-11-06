% Returns the x and y coordinates of the table tennis ball in the given
% frame. Returns (-1, -1) if ball is not detected.
% Input:
%   frame (uint8): An image frame of the moving table tennis ball video.
% Output:
%   ballX (double): x coordinate of the table tennis ball in the frame wrt 
%   to top left corner
%   ballY (double): y coordinate of the table tennis ball in the frame wrt 
%   to top left corner (positive axis is downwards)
function[ballX, ballY] = getBallPosition(frame)
% fprintf("In function getBallPosition()\n");

% ================================Constants================================
% Threshold used to classify a window as containing the streak of the moving ball 
BALL_THRESHOLD = 40; 

% Threshold used to classify a window as an empty window, i.e., no movement is captured in the window
EMPTY_THRESHOLD = 2; 

% Dimensions of the sliding window
WINDOW_WIDTH = 40;
WINDOW_HEIGHT = 25;

% Dimensions of the video frame
[FRAME_HEIGHT, FRAME_WIDTH] = size(frame);

% Coordinates from which to start searching for the ball
START_X = 525;
START_Y = 220;

% Logical value to decide whether the moving window should be displayed
IS_PROCESSING_SHOWN = false;

% ===========================Logic/Implementation==========================
if IS_PROCESSING_SHOWN
    diffFig = figure();
    movegui(diffFig,'northwest');
    % imshow(uint8(frame));
    imshow(uint8(frame),'InitialMagnification',200)
    drawnow;
end
        
% Represents coordinates of the table tennis ball
ballX = -1;
ballY = -1;

y = START_Y; 
while y < FRAME_HEIGHT-WINDOW_HEIGHT
    % TODO: FIND A WAY TO OPTIMISE INCREMENT OF ROW (similar to col = col + windowWidth)
    y = y + 1;
    x = START_X;
    while x < FRAME_WIDTH-WINDOW_WIDTH
        x = x + 1;
        window = frame(y:y+WINDOW_HEIGHT, x:x+WINDOW_WIDTH);
        avgPixelValue = mean2(window);
         
        if IS_PROCESSING_SHOWN
            % Turn off message warning: 'Image is too big to fit on screen; displaying at 67%'
            % [message, MSGID] = lastwarn();
            MSGID = 'images:initSize:adjustingMag';
            warning('off', MSGID);

            RGB = insertShape(uint8(frame),'Rectangle',[x y WINDOW_WIDTH WINDOW_HEIGHT],'LineWidth',3);
            % truesize([300 200]);
            % imshow(RGB,'InitialMagnification',200)
            imshow(RGB);
            drawnow;
        end
  
        if ~hasEmptyBorders(window)
            % fprintf("Invalid window\n"); % since borders are not black (empty)
            continue;
        end
        
        % fprintf("Window  at(%d,%d) avgVal=%3.2f\n", x, y, avgPixelValue);
        
        % TODO: Alternatively, we can reduce threshold, use a function to 
        % see if size of streak is large enough. If not, exit the function.
        % This way we can account for smaller streaks? Need to experiment a
        % bit.
        if (avgPixelValue > BALL_THRESHOLD)
            [ballX, ballY] = getCentreOfBallStreak(window, x, y);
            % fprintf("Ball = (%4f,%4f)\n", ballX, ballY);
            
            if IS_PROCESSING_SHOWN
                close(diffFig);
            end
            
            return;
        elseif (avgPixelValue < EMPTY_THRESHOLD)
            % Speed optimisation: Increment by a large amount
            x = x + WINDOW_WIDTH*0.75;
        end
        
    end
end
% fprintf("No ball found\n");

if IS_PROCESSING_SHOWN
    close(diffFig);
end

end