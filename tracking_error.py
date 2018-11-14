import math
import pandas
import os

def calculate_tracking_error(truthFile, resultFile, videoId):
    truthDf = pandas.read_csv(truthFile)
    resultDf = pandas.read_csv(resultFile)

    numFrames = min(len(truthDf), len(resultDf));

    numXErrors = 0;
    numYErrors = 0;
    avgXError = 0.0;
    avgYError = 0.0;

    for i in range(numFrames):
        # print(truthFile, " ", i, " ", truthDf.x[i] - resultDf.x[i], " ", truthDf.y[i] - resultDf.y[i]);

        xError = truthDf.x[i] - resultDf.x[i];
        yError = truthDf.y[i] - resultDf.y[i];

        if not math.isnan(xError) or not math.isnan(yError):
            # print(i, " ", xError, " ", yError);
            print;

        # Calculate average value of the errors
        numXErrors += 1;
        numYErrors += 1;

        if not math.isnan(xError):
            avgXError = get_updated_error(numXErrors, xError, avgXError)

        if not math.isnan(yError):
            avgYError = get_updated_error(numYErrors, yError, avgYError)

    print(videoId, ": Average x error = %.2f, Average y error = %.2f \n" % (avgXError, avgYError));


def get_updated_error(numErrors, error, avgError):
    if numErrors == 1:
        avgError = math.abs(error);
    else:
        avgError = (((numErrors-1)/numErrors) * avgError) + ((1/numErrors) * error);

    return avgError;


numProcessedFiles = 0;
truthDir = ".\\Truth";

for camNum in [1, 2, 3]:
    resultDir = ".\\Videos\\CAM" + str(camNum);
    for file in os.listdir(resultDir):
        if file.endswith(".csv"):
            pathToResultFile = os.path.join(resultDir, file);

            videoId = file.split(".")[0];
            pathToTruthFile = os.path.join(truthDir, videoId + ".csv");

            calculate_tracking_error(pathToTruthFile, pathToResultFile, videoId);
            numProcessedFiles += 1;

print("Processed ", numProcessedFiles, "files");