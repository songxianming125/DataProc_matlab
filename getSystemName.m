function y=getSystemName(CurrentChannel,varargin)    
global MyChanLists
%isForce 
CurrentShot=20000;

if nargin>=2
    if ~isempty(varargin{1}) && isnumeric(varargin{1}) %
        CurrentShot=varargin{1}
        isForce=varargin{2};
    else
        isForce=0;
    end
else
    isForce=0;
end

if isempty(MyChanLists)
    MyPath = which('DP');

    dataFile='infChannelSystem.mat';
    infChannelSystemFile=[MyPath(1:end-4) 'configurations' filesep dataFile];
    fid = fopen(infChannelSystemFile,'r');
    MyChanLists = fread(fid, '*char')';
    status = fclose(fid);
end

%% split CurrentChannel

CurrentChannels=regexp(CurrentChannel,'\|','split');
n=length(CurrentChannels);
y=[];

for i=1:n
    CurrentChannel=CurrentChannels{i};
    % one more character is needed, such as ! _ @
    systemPattern=['(?<=\xD\xA[\W]{0,1}_{0,1}' CurrentChannel '\x3A)\w{3}(?=\xD\xA)'];
    %   systemPattern=['(?<=\xD\n' CurrentChannel '\x3A)\w{3}(?=\xD\xA)'];
    %  systemPattern=['(?<=\xD\W' CurrentChannel '\x3A)\w{3}(?=\xD\xA)'];
    %  systemPattern=['(?<=\xD\s' CurrentChannel '\x3A)\w{3}(?=\xD\xA)'];
    % systemPattern=['(?<=\xD\xA)' CurrentChannel '\x3A\w{3}(?=\xD\xA)'];
    % systemPattern=['(?<=' char(13) char(10) CurrentChannel '\x3A)\w{3}(?=\xD\xA)'];
    
    
    % SystemName=regexpi(MyChanLists,systemPattern,'match','once');
    SystemName=regexpi(MyChanLists,systemPattern,'match');
    y=[y unique(SystemName)];
end
y=unique(y);

% y=[char(13) char(164) SystemName char(13) char(10)];
% systemPattern=['(?<=\xD' char(164) CurrentChannel '\x3A)\w{3}(?=\xD\xA)'];
% SystemName=regexpi(y,systemPattern,'match','once');


if isForce==1
    [~,MyPath,Mylist] = GetShotPath(CurrentShot);
    if ~isempty(Mylist)
        if isempty(SystemName) %find the systemName from the CurrentChannel
            for i=1:length(Mylist)
                MyFile=Mylist{i};
                [CurrentInfoFile,ChannelIndex,DasInfos]=GetChannelIndex(MyPath,MyFile,CurrentChannel);
                if ~isempty(ChannelIndex)%ok then break
                    systemPattern=['(?<=\d{3,})\w{3}(?=\x2E)'];
                    
                    SystemName=regexp(CurrentInfoFile,systemPattern,'match','once');
                    y=SystemName;
                    
%                     SystemName=regexpi(MyChanLists,systemPattern,'match');
%                     y=unique(SystemName);
%                     
                    
                    
                    break;
                end
            end
        else
            systemPattern=['(?<=\d{3,})' SystemName '(?=\x2E)'];
            ys=regexp(Mylist,systemPattern,'match','once');
            TF=cellfun(@isempty,ys);
            y=ys{~TF};
        end %isempty(SystemName)
    end %~isempty(Mylist)
end




