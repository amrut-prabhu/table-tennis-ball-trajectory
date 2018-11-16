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

workingDir = tempname;
mkdir(workingDir)
mkdir(workingDir,'images')

for frameNum = 1 : size(trackedCsv)
    % Do not show warnings
    MSGID = 'images:initSize:adjustingMag';
    warning('off', MSGID);
            
    % Read video frame and convert to image
    vidFrame = read(videoObj, frameNum);
    imshow(vidFrame);
    
    x = xPositions(frameNum);
    y = yPositions(frameNum);
    
    frameWithMarker = vidFrame;
    if x > 0 && y > 0
        frameWithMarker = insertShape(uint8(vidFrame),'circle',[x y 6.5],'LineWidth',3,'Color','green');
        imshow(frameWithMarker);
        drawnow;
    end
    drawnow;
    
    filename = [sprintf('%03d',frameNum) '.jpg'];
    fullname = fullfile(workingDir,'images',filename);
    imwrite(frameWithMarker,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
end


% Generate and save the video file with the marker to disk
imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';

baseName = pathToFile(1:find(pathToFile=='.')-1);
outputVideo = VideoWriter(strcat(baseName,'_tracked'), 'MPEG-4');
outputVideo.FrameRate = videoObj.FrameRate;
open(outputVideo)

for i = 1:length(imageNames)
   img = imread(fullfile(workingDir,'images',imageNames{i}));
   writeVideo(outputVideo,img)
end

close(outputVideo)

end