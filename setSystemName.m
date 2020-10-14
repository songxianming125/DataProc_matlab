function y=setSystemName(varargin)    
global MyChanLists
y=0;
MyChanLists=[];
bForceUpdate=0;
CurrentShot=GetLastestShot-1;

if nargin>=1
    if ~isempty(varargin{1}) && isnumeric(varargin{1}) %
        CurrentShot=varargin{1};
    end
end

if nargin>=2
    if ~isempty(varargin{2}) && isnumeric(varargin{2}) %
        bForceUpdate=varargin{2};
    end
end




[~,MyPath,Mylist] = GetShotPath(CurrentShot);
n=length(Mylist);
for i=1:n
    %if we use function the performance will reduce.
    MyFile=Mylist{i};
    if length(MyFile)>15; continue; end
    systemName=MyFile(6:8);
    if strcmpi(systemName,'vec'); continue; end

    CurrentInfoFile=fullfile(MyPath,MyFile);
    [MyChanList,ChannelNums]=GetMyInfoN(CurrentInfoFile,0);
%     MyChanList=ChannelsConditionning(MyChanList);
    MyChanList=strcat(MyChanList,{[':' systemName char(13) char(10)]});  %strcat removes the whitespace
    MyChanLists=vertcat(MyChanLists,MyChanList);
end%for





MyPath = which('DP');
dataFile='infChannelSystem.mat';
infChannelSystemFile=[MyPath(1:end-4) 'configurations' filesep dataFile];

%%
MyChanLists=horzcat(MyChanLists{:});
MyChanLists=horzcat([char(13) char(10)],MyChanLists);


%old one
if bForceUpdate
    oldMyChanLists =[];
else
    fid = fopen(infChannelSystemFile,'r');
    oldMyChanLists = fread(fid, '*char')';
    status = fclose(fid);
end

delete(infChannelSystemFile);
totalChanLists=[oldMyChanLists MyChanLists];
channelPattern=['(?<=\xD\xA)[\S]*(?=\xD\xA)'];
SystemName=regexpi(totalChanLists,channelPattern,'match');
SystemChannels=unique(SystemName);


SystemChannels=strcat(SystemChannels,{[char(13) char(10)]});  %strcat removes the whitespace

MyChanLists=horzcat(SystemChannels{:});
MyChanLists=horzcat([char(13) char(10)],MyChanLists);
%%

fid = fopen(infChannelSystemFile,'w');
fwrite(fid,MyChanLists, 'char');
status = fclose(fid);
y=1;
