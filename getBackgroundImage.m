% Function to extract the background from the video using averaging
% technique.
% Input:
%   videoObj (VideoReader): The moving table tennis ball video.
%   numberOfFrames (double): Total number of frames in the video.
% Output:
%   background (uint8): The static background image of the video.
function background = getBackgroundImage(videoObj, numberOfFrames)
fprintf("In function getBackgroundImage()\n");

% TODO: Consider using the first frame of the video as the background since
% it usually does not contain the moving table tennis ball i.e. HARDCODING!
for frameNum = 1 : numberOfFrames
    vidFrame = double(read(videoObj, frameNum));
    image(vidFrame);
    
    if frameNum == 1
        background = vidFrame;
    else
        background = (frameNum - 1) / frameNum * background + 1 / frameNum * vidFrame;
    end
end

end