% Processes the given file by tracking the moving table tennis ball in the
% video.
% Input:
%   videoFilename (char): Relative path to the video file.
% Output:
%   xPositions ():
%   yPositions ():
%   Writes csv file to disk containing coordinates of the ball
function [xPositions, yPositions] = processVideoFile(videoFilename, cam)
fprintf("In function processVideoFile()\n");


videoObj = VideoReader(videoFilename);
xPositions = [];
yPositions = [];

% ================================Constants================================
NUM_FRAMES = videoObj.NumberOfFrames;

%CSV File Particulars
FILENAME = strcat(videoFilename, '.csv');
DELIMITER = ',';
HEADER1 = 'frame';
HEADER2 = 'x';
HEADER3 = "y";

NOT_FOUND = -1.0;
PREV_Y = -2.0;

% ===========================Logic/Implementation==========================
csvFileObj = fopen(FILENAME,'w');

% Write headers to csv file
headersCsvEntry = strcat(HEADER1, DELIMITER, HEADER2, DELIMITER, HEADER3, '\n');
fprintf(csvFileObj,headersCsvEntry);

% Load/generate background of video
backgroundFile = strcat(videoFilename, 'background.png');
if ~exist(backgroundFile, 'file')
    videoBackground = getBackgroundImage(videoObj, NUM_FRAMES);
	imwrite(uint8(videoBackground), backgroundFile, 'png');
else
    fprintf("Loading background from disk\n");
    videoBackground = double(imread(backgroundFile)); 
end

xPositions = zeros(NUM_FRAMES);
yPositions = zeros(NUM_FRAMES);
for frameNum = 1 : 100
    % Read video frame and convert to image
    vidFrame = double(read(videoObj, frameNum));
    
    % Get moving objects in this frame
    movingObjects = abs(vidFrame - videoBackground);
    % diff = uint8(movingObjects);
    movingObjectsGrayscale = rgb2gray(uint8(movingObjects));

    [x, y] = getBallPosition(movingObjectsGrayscale, cam);
    
    xPositions(frameNum) = x;
    yPositions(frameNum) = y;

    x = sprintf('%4.1f',x);
    y = sprintf('%4.1f',y);

    if strcmp(x, sprintf('%4.1f',NOT_FOUND)) && strcmp(y, sprintf('%4.1f',NOT_FOUND))
        posCsvEntry = strcat(int2str(frameNum-1), DELIMITER, DELIMITER, '\n');
    else
        posCsvEntry = strcat(int2str(frameNum-1), DELIMITER, x, DELIMITER, y, '\n');
    end
    
    fprintf(posCsvEntry);
    fprintf(csvFileObj,posCsvEntry);
    
    % TODO: Stop tracking after ball is out of table
end

end