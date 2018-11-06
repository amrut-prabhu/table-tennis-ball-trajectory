import pandas as pd

actual_df = pd.read_csv('./Actual/CAM1-GOPR0333-21157.csv')
tracking_df = pd.read_csv('./Videos/CAM1/CAM1-GOPR0333-21157.mp4.csv')

print(actual_df.head())
print(tracking_df.head())

