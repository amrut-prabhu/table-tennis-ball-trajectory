function showTrackedBall(pathToFile, xPositions, yPositions)
videoObj = VideoReader(pathToFile);
NUM_FRAMES = videoObj.NumberOfFrames;
fig = figure;

% Read coordinates from csv file, if exists
csvFile = strcat(pathToFile, '.csv');
if exist(csvFile, 'file')
    trackedCsv = csvread(csvFile,1,0);
    xPositions = trackedCsv(:, 2);
    yPositions = trackedCsv(:, 3);
end

for frameNum = 1 : size(xPositions)
    % Do not show warnings
    MSGID = 'images:initSize:adjustingMag';
    warning('off', MSGID);
            
    % Read video frame and convert to image
    vidFrame = read(videoObj, frameNum);
    imshow(vidFrame);
    
    x = xPositions(frameNum);
    y = yPositions(frameNum);
    
    if x > 0 && y > 0
        rectangle('Position', [x, y, 13, 13], 'Curvature', [1,1], 'EdgeColor', 'g', 'LineWidth',3);
    end
    drawnow;
end

end