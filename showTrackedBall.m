function showTrackedBall(pathToFile, xPositions, yPositions)
videoObj = VideoReader(pathToFile);
NUM_FRAMES = videoObj.NumberOfFrames;
fig = figure;

for frameNum = 1 : 100
    % Read video frame and convert to image
    vidFrame = read(videoObj, frameNum);
    imshow(vidFrame);
    %rectangle('Position', [xPositions(frameNum), yPositions(frameNum), 13, 13], 'Curvature', [1,1], 'EdgeColor', 'g', 'LineWidth',3);
    circle(xPositions(frameNum), yPositions(frameNum), 13/2.0);
    drawnow;
end

end

function h = circle(x,y,r)
d = r*2;
px = x-r;
py = y-r;
h = rectangle('Position',[px py d d],'Curvature',[1,1],'EdgeColor', 'g', 'LineWidth',2);
daspect([1,1,1])
end