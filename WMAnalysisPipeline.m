%% Water Maze Analysis Pipeline
clear
path = 'C:\MyFolder\MyWaterMazeData';

%% 1-Get dataset Info
infoWM = getDataSetWM(path);

%% 2-Get dataset Properties
pathTemplate = [path filesep infoWM.IDs{1} '.mp4'];

vidObj = VideoReader(pathTemplate);
idx=1;
while hasFrame(vidObj)
    Video(:,:,idx) = rgb2gray(readFrame(vidObj));
    idx=idx+1;
end
infoWM.Props = getPropsWM(Video);

%% 3-Compute quadrants and average distance
close all
clear accResult
for i = 1:length(infoWM.IDs)
    vidObj = VideoReader([path '\' infoWM.IDs{i} '.mp4']);
    idx=1;
    while hasFrame(vidObj)
        Video(:,:,idx) = rgb2gray(readFrame(vidObj));
        idx=idx+1;
    end
    actualRes = calcDataWM(Video,infoWM);
    IDs{i,1} = {infoWM.IDs{i}(1:end-3)};
    title(IDs{i,1})
    accResult(i,:) = actualRes;
    clear Video
end
Result = [table(IDs) accResult];