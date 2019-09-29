import math
import pandas
import os
import numpy as np

def calculate_tracking_error(truthFile, resultFile, videoId):
    truthDf = pandas.read_csv(truthFile)
    resultDf = pandas.read_csv(resultFile)

    numFrames = min(len(truthDf), len(resultDf));

    xErrors = [];
    yErrors = [];

    for i in range(numFrames):
        # print(truthFile, " ", i, " ", truthDf.x[i] - resultDf.x[i], " ", truthDf.y[i] - resultDf.y[i]);

        xError = truthDf.x[i] - resultDf.x[i];
        yError = truthDf.y[i] - resultDf.y[i];

        if not math.isnan(xError) or not math.isnan(yError):
            # print(i, " ", xError, " ", yError);
            pass;

        if (not math.isnan(xError)) and (not math.isnan(yError)):
            xErrors.append(abs(xError));
            yErrors.append(abs(yError));

    print(videoId, ": Average x error = %.2f, Average y error = %.2f \n" % (np.mean(xErrors), np.mean(yErrors)));


numProcessedFiles = 0;

for camNum in [1, 2, 3]:
    resultDir = os.path.join('.', 'Videos', 'CAM' + str(camNum));
    for file in os.listdir(resultDir):
        if file.endswith(".csv"):
            pathToResultFile = os.path.join(resultDir, file);

            videoId = file.split(".")[0];
            pathToTruthFile = os.path.join('.', 'Actual', 'CAM' + str(camNum), videoId + ".csv");

            calculate_tracking_error(pathToTruthFile, pathToResultFile, videoId);
            numProcessedFiles += 1;

print("Processed ", numProcessedFiles, "files");
