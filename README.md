# Generation 3D Trajectory of Table Tennis ball

This project aims to create a 3D visualisation of the trajectory of a table tennis ball that is captured by three syncronised cameras from different angles. 

## Tracking the table tennis ball

### `ball_tracking.m`
Run `ball_tracking.m` to get the results for ball tracking.
It processes the video files in the `Videos/CAM1`, `Videos/CAM2` and `Videos/CAM3` directories.
The ball tracking results obtained for a video are saved in the same directory as the video file. The saved files are: 
- background of the image (png file)
- coordinates of the ball for different frame (csv file)

The csv filenames are just the video filenames suffixed with `.csv`. Eg. Result of `video.mp4` is saved as `video.mp4.csv`.
The png filenames are just the video filenames suffixed with `background.png`. Eg. Result of `video.mp4` is saved as `video.mp4background.png`.

### `remove_tracking_results.py`
Execute `remove_tracking_results.py` to remove the generated result files.

### `tracking_error.py`
Execute `tracking_error.py` to see the accuracies of the generated x and y positions for the table tennis ball in the videos. The resultant csv files from `Videos/CAMx/` are compared to the truth files of the corresponding videos in `Actual/`.

## Triangulating and visualising the 3D position of the ball

