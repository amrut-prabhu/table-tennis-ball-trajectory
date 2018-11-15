function showTrackedBall(pathToFile, xPositions, yPositions)
videoObj = VideoReader(pathToFile);
NUM_FRAMES = videoObj.NumberOfFrames;
fig = figure;

for frameNum = 1 : 100
    % Read video frame and convert to image
    vidFrame = read(videoObj, frameNum);
    imshow(vidFrame);
    rectangle('Position', [xPositions(frameNum), yPositions(frameNum), 13, 13], 'Curvature', [1,1], 'EdgeColor', 'g', 'LineWidth',3);

    drawnow;
end

end