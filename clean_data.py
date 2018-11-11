import pandas as pd

fnames = ['cam1.csv', 'cam2.csv', 'cam3.csv']

df1 = pd.read_csv(fnames[0])
df1 = df1.dropna()
df2 = pd.read_csv(fnames[1])
df2 = df2.dropna()
df3 = pd.read_csv(fnames[2])
df3 = df3.dropna()

f2 = df2['frame']
f3 = df3['frame']
commonFrames = []

print (f2)

for index, row in df1.iterrows():
    frameNum = row['frame']
    if frameNum in f2 and frameNum in f3:
        commonFrames.append(frameNum)

print (len(commonFrames))

df1 = df1.query('frame in @commonFrames')
df2 = df2.query('frame in @commonFrames')
df3 = df3.query('frame in @commonFrames')

df1.to_csv('df1_cleaned.csv')
df2.to_csv('df2_cleaned.csv')
df3.to_csv('df3_cleaned.csv')
