function infoWM = getDataSetWM(path)

files = dir([path '\*.mp4']);

for i = 1:length(files)
    infoWM.IDs{i}=files(i).name(1:end-4);
end
