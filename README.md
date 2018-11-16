# Generating the 3D Trajectory of a Table Tennis Ball

This project aims to create a 3D visualisation of the trajectory of a table tennis ball that is captured by three synchronized cameras from different angles. 

## Tracking the Table Tennis Ball

### `ball_tracking.m`
Run `ball_tracking.m` to get the results for ball tracking.
It processes the video files in the `Videos/CAM1`, `Videos/CAM2` and `Videos/CAM3` directories.
The ball tracking results obtained for a video are saved in the same directory as the video file. The saved files are: 

- background of the image (png file)
- coordinates of the ball for different frame (csv file)

The csv filenames are just the video filenames suffixed with `.csv`. Eg. Result of `video.mp4` is saved as `video.mp4.csv`.
The png filenames are just the video filenames suffixed with `background.png`. 

E.g. Result of `video.mp4` is saved as `video.mp4background.png`.

### `remove_tracking_results.py`
Execute `remove_tracking_results.py` to remove the generated result files.

### `tracking_error.py`
Execute `tracking_error.py` to see the accuracies of the generated x and y positions for the table tennis ball in the videos. The resultant csv files from `Videos/CAMx/` are compared to the truth files of the corresponding videos in `Actual/`.

## Triangulating and Visualizing the 3D Trajectory of the Ball

### `clean_annotation_files.py`

The original annotation `.csv` file for each camera has 2D (x, y) points corresponding to each frame in the video taken by that camera. All three cameras are not guaranteed to be able to view the ball in each frame, so we need to make sure we triangulate the positions of the ball in a frame only when it can be viewed from all three cameras. 

The `clean_annotation_files.py` script will create `CAMx-seqNum_cleaned.csv` files in `CleanData/`. These cleaned files will have only those 2D points corresponding to a frame that has (x, y) coordinates in all the three original `.csv` files.

### `triangulate_positions.m`

Run `triangulate_positions.m` to get the triangulated 3D positions using the following data:

- camera calibration matrix of each camera
- 2D points of ball on image planes of each camera (from `CleanData/CAMx-seqNum_cleaned.csv`)

3D positions of the ball are calculated using _Perspective Projection_ equations. The `.csv` files containing the 3D (x, y, z) coordinates for each sequence will be written to `results/3dpts_seqNum.csv`.

Based on the calculated 3D positions, the trajectory of the table tennis ball is displayed, along with the location and orientation of each camera and the table. This will be saved to `results/traj_seqNum.jpg` for each sequence.

For error analysis, the 3D position data is smoothed using the _Savitzky-Golay_ filter and the standard deviation between the original 3D positions and smoothed 3D positions is calculated and displayed. The results will be saved to `results/error_visualization_seqNum.jpg` for each sequence.