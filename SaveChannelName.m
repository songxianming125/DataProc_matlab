function SaveChannelName
%% this function save the special channel name for the picture


global MyCurves PicDescription
n=length(MyCurves);
for i=1:n
    MyCurves(i).Unit=PicDescription(i).Unit;
    MyCurves(i).ChnlName=PicDescription(i).ChnlName;
end



