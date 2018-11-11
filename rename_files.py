from os import listdir, rename
from os.path import isfile, join
import pandas as pd

mypath = 'C:/Users/cksas/Desktop/Annotation'
folders = ['CAM1', 'CAM2', 'CAM3']
fl = pd.read_csv((mypath + '/FileList.csv'), names = folders)

for folder in folders:
    for i in range(10):
        name = fl[folder][i].split('.')[0]
        name = name + '.csv'
        newname = folder + '-' + str(i) + '.csv'
        print (name)
        print (newname)
        rename(join(mypath, name), newname)

# Clean the data files
n1 = 'CAM1-'
n2 = 'CAM2-'
n3 = 'CAM3-'

for i in range(10):
    fnames = [n1 + str(i) + '.csv', n2 + str(i) + '.csv', n3 + str(i) + '.csv']
    df1 = pd.read_csv(fnames[0])
    df1 = df1.dropna()
    df2 = pd.read_csv(fnames[1])
    df2 = df2.dropna()
    df3 = pd.read_csv(fnames[2])
    df3 = df3.dropna()

    f2 = df2['frame']
    f3 = df3['frame']
    commonFrames = []

    for index, row in df1.iterrows():
        frameNum = row['frame']
        if frameNum in f2 and frameNum in f3:
            commonFrames.append(frameNum)

    print (len(commonFrames))

    df1 = df1.query('frame in @commonFrames')
    df2 = df2.query('frame in @commonFrames')
    df3 = df3.query('frame in @commonFrames')

    df1.to_csv(fnames[0].split('.')[0] + '_cleaned.csv')
    df2.to_csv(fnames[1].split('.')[0] + '_cleaned.csv')
    df3.to_csv(fnames[2].split('.')[0] + '_cleaned.csv')
    
    