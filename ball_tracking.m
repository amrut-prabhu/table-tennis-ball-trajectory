close all;
clear all;

for cam = 1:1
    dirPath = sprintf('Videos/CAM%d/', cam);
    fileType = '*.mp4';
    dirName = sprintf('%s', dirPath, fileType);
    dInfo = dir(dirName);
    fprintf("\n");
    for k = 1 : length(dInfo)
        filename = dInfo(k).name;
        pathToFile = strcat(dirPath, filename);
        fprintf('Processing file %d#%d, "%s"\n', cam, k, pathToFile);

        [xPositions, yPositions] = processVideoFile(pathToFile);
        showTrackedBall(pathToFile, xPositions, yPositions);
    end
end



% processVideoFile('Videos/CAM1/CAM1-GOPR0333-21157.mp4');
