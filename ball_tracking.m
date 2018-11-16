close all;
clear all;

% for cam = 3:3
%     dirPath = sprintf('Videos/CAM%d/', cam);
%     fileType = '*.mp4';
%     dirName = sprintf('%s', dirPath, fileType);
%     dInfo = dir(dirName);
%     fprintf("\n");
%     for k = 1 : length(dInfo)
%         filename = dInfo(k).name;
%         pathToFile = strcat(dirPath, filename);
%         fprintf('Processing file %d#%d, "%s"\n', cam, k, pathToFile);
% 
%         [xPositions, yPositions] = processVideoFile(pathToFile, cam);
%         showTrackedBall(pathToFile, xPositions, yPositions);
%     end
% end

cam = 2;
xPositions = [];
yPositions = [];
pathToFile = 'Videos/CAM2/CAM2-GOPR0289-26776.mp4';
[xPositions, yPositions] =  processVideoFile(pathToFile, cam);


[xPositions, yPositions] =  processVideoFile(pathToFile);
%Read coordinates from csv file and show tracking
showTrackedBall(pathToFile, xPositions, yPositions);
