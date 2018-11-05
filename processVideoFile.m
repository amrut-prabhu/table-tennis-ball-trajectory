% Processes the given file by tracking the moving table tennis ball in the
% video.
% Input:
%   videoFilename (char): Relative path to the video file.
% Output:
%   None, but writes csv file to disk containing coordinates of the ball
function processVideoFile(videoFilename)
fprintf("In function processVideoFile()\n");

% TODO: Process all frames

videoObj = VideoReader(videoFilename);
numberOfFrames = videoObj.NumberOfFrames;

% Load/generate background of video
backgroundFile = strcat(videoFilename, 'background.png');
if ~exist(backgroundFile, 'file')
    videoBackground = getBackgroundImage(videoObj, numberOfFrames);
	imwrite(videoBackground, backgroundFile, 'png');
else
    fprintf("Loading background from disk\n");
    videoBackground = imread(backgroundFile); 
end
 
firstFrame = read(videoObj, 5);

newBackGround = firstFrame - videoBackground;
frameArray = uint8(newBackGround);
frameArray = rgb2gray(frameArray);
[x, y] = getBallPosition(frameArray);
fprintf("\n");

% TODO: Write to CSV
end