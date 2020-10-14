function  [CurrentInfoFile,ChannelIndex,ChanLists]=GetChannelIndex(MyPath,MyFile,CurrentChannel)
CurrentInfoFile=fullfile(MyPath,MyFile);
ChannelIndex=[];
ChanLists=[]; %here are the output channel names for finding in MyFile

[MyChanList,ChannelNums]=GetMyInfoN(CurrentInfoFile,0);
if isempty(MyChanList)
%     warnstr=strcat('no channel  found in ',CurrentInfoFile);%promt the need to update configuration
%     warndlg(warnstr)
    return
end

MyChanList=ChannelsConditionning(MyChanList);
MyChanList=lower(MyChanList);
CurrentChannel=deblank(lower(CurrentChannel));

if iscell(CurrentChannel)
    channelNumber=1;
    for i=1:length(CurrentChannel)
        if isempty(strmatch(lower(CurrentChannel{i}),MyChanList,'exact'))
            Channels=CurrentChannel{i};
            
            if ~iscell(Channels)
                Channels=channelTransfer(Channels);
            end
            
            
            if ~iscell(Channels) && (strcmp(Channels(1),'_') && strcmp(Channels(end),'_'))
                MyChanList=ChannelsConditionning(MyChanList);
                patternname=['^' Channels(2:end-1) '$'];
                s = regexpi(MyChanList, patternname, 'start');
                Indexs=cellfun('isempty',s);
                
                ChannelIndex=[ChannelIndex; find(~Indexs)];
                if ~isempty(ChannelIndex)
                    ChanLists=MyChanList(ChannelIndex);
                end
            else
                if isempty(strmatch(lower(Channels),MyChanList,'exact'))
                    setappdata(0,'MyErr',strcat('No this channel/',Channels));
                    return
                else
                    ChannelIndex(channelNumber) = strmatch(lower(Channels),MyChanList,'exact');
                    ChanLists{channelNumber}=CurrentChannel{i};
                    channelNumber=channelNumber+1;
                end
            end
        else
            %% should 
            ChannelIndex(channelNumber) = strmatch(lower(CurrentChannel{i}),MyChanList,'exact');% should index the channel
            ChanLists{channelNumber}=CurrentChannel{i};
            channelNumber=channelNumber+1;
        end
    end
    
else
    ChannelIndex = strmatch(lower(CurrentChannel),MyChanList,'exact');
    if length(ChannelIndex)>1
        warnstr=strcat('more channel  found in ',MyFile);%promt the need to update configuration
        warndlg(warnstr)
    end
end

