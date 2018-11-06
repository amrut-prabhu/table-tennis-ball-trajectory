% Processes the given file by tracking the moving table tennis ball in the
% video.
% Input:
%   videoFilename (char): Relative path to the video file.
% Output:
%   None, but writes csv file to disk containing coordinates of the ball
function processVideoFile(videoFilename)
fprintf("In function processVideoFile()\n");


videoObj = VideoReader(videoFilename);

% ================================Constants================================
NUM_FRAMES = videoObj.NumberOfFrames;
%CSV File Particulars
FILENAME = strcat(videoFilename, '.csv');;
DELIMITER = ',';
HEADER1 = 'frame';
HEADER2 = 'x';
HEADER3 = "y";

% ===========================Logic/Implementation==========================
csvFileObj = fopen(FILENAME,'w');

% Write headers to csv file
headersCsvEntry = strcat(HEADER1, DELIMITER, HEADER2, DELIMITER, HEADER3, '\n');
fprintf(csvFileObj,headersCsvEntry);

% Load/generate background of video
backgroundFile = strcat(videoFilename, 'background.png');
if ~exist(backgroundFile, 'file')
    videoBackground = getBackgroundImage(videoObj, NUM_FRAMES);
	imwrite(videoBackground, backgroundFile, 'png');
else
    fprintf("Loading background from disk\n");
    videoBackground = imread(backgroundFile); 
end

for frameNum = 1 : NUM_FRAMES
    % Read video frame and convert to image
    vidFrame = read(videoObj, frameNum);
    
    % Get moving objects in this frame
    movingObjects = vidFrame - videoBackground;
    % diff = uint8(movingObjects);
    movingObjectsGrayscale = rgb2gray(movingObjects);

    [x, y] = getBallPosition(movingObjectsGrayscale);
    
    if frameNum > 50 && x == -1 && y == -1
        break;
    end
    
    x = sprintf('%4.1f',x);
    y = sprintf('%4.1f',y);
    % fprintf("Frame %d, ball = (%f,%f)\n", frameNum, x, y);
    
    % Write ball position to csv file
    posCsvEntry = strcat(int2str(frameNum-1), DELIMITER, x, DELIMITER, y, '\n');
    fprintf(posCsvEntry);
    fprintf(csvFileObj,posCsvEntry);
    
    
    % TODO: Stop tracking after ball bounces
end

end