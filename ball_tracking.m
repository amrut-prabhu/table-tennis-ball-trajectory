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

cam = 1;
xPositions = [];
yPositions = [];
pathToFile = 'Videos/CAM1/CAM1-GOPR0334-26813.mp4';
files = {'Videos/CAM3/CAM3-GOPR0343-26692.mp4'; 'Videos/CAM1/CAM1-GOPR0333-21157.mp4'; 'Videos/CAM2/CAM2-GOPR0288-21180.mp4'; 'Videos/CAM3/CAM3-GOPR0342-21108.mp4';  'Videos/CAM1/CAM1-GOPR0333-25390.mp4'; 'Videos/CAM2/CAM2-GOPR0288-25413.mp4'; 'Videos/CAM3/CAM3-GOPR0342-25341.mp4';'Videos/CAM1/CAM1-GOPR0334-6600.mp4'; 'Videos/CAM2/CAM2-GOPR0289-6563.mp4'; 'Videos/CAM3/CAM3-GOPR0343-6479.mp4'; 'Videos/CAM1/CAM1-GOPR0334-14238.mp4'; 'Videos/CAM2/CAM2-GOPR0289-14201.mp4'; 'Videos/CAM3/CAM3-GOPR0343-14117.mp4'};
%[xPositions, yPositions] =  processVideoFile(pathToFile, cam);

%Read coordinates from csv file and show tracking
n = size(files);

for i = 1:1:13
    pathToFile = files{i, 1};
    showTrackedBall(pathToFile, xPositions, yPositions);
end
%showTrackedBall(pathToFile, xPositions, yPositions);
