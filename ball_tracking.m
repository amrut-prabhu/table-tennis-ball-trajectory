close all;
clear all;

for cam = 1:3
    dirPath = sprintf('Videos/CAM%d/', cam);
    fileType = '*.mp4';
    dirName = sprintf('%s', dirPath, fileType);
    dInfo = dir(dirName);
    fprintf("\n");
    for k = 1 : length(dInfo)
        filename = dInfo(k).name;
        pathToFile = strcat(dirPath, filename);
        fprintf('Processing file %d#%d, "%s"\n', cam, k, pathToFile);

        processVideoFile(pathToFile);
    end
end
