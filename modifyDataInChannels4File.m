function modifyDataInChannels4File(hObject, eventdata, handles)

%% the file is ready, we just change some data of several channels and keep others the same
% make sure do not change the channel name.
global   MyCurves PicDescription
if isempty(MyCurves)
    MyCurves=get(handles.lbCurves,'UserData');
end

%%

%% local dir
rootDP=p2a;
temp=[rootDP filesep 'temp'];
cd(temp);


%% open ftp
user='acq';
psw='acqget';
% mw=ftp('www.swip.ac.cn',user,psw);

sxDriver='192.168.10.11';
try
    ccs=ftp(sxDriver,user,psw);
catch err
    msgbox(['hl is not available!' err.identifier])
    return
end

% come to the 2mdas folder
cd(ccs,'..\2MDAS');

subFolders={'INF','DATA'};


%% we need shot information
MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end

CurrentInfoFile=[MyShot,'sim.inf'];
CurrentDataFile=[MyShot,'sim.dat'];

getFile={CurrentInfoFile,CurrentDataFile};
%% default plus one
CurrentShot=str2num(MyShot);
myDir = GetDir(CurrentShot); %Folder for the shot
cd(ccs,myDir);
cd(ccs,'INF'); % no practical use but for FOR cycle.
%% source file


%% get File
for i=1:length(subFolders)
    cd(ccs,['..' filesep subFolders{i}]);
    mget(ccs,getFile{i});
end
%%

[originalDasInfos,n]=GetMyInfoN(CurrentInfoFile);%get all information
[MyChanList,ChannelNums]=GetMyInfoN(CurrentInfoFile,0);
[~,n]=size(MyCurves);
% n is the number of editing channels
for i=1:n
    % find the channel in original file, and change it.
    
    myChannelName=MyCurves(i).ChnlName;
    
    % 	Index=find(strcmp(MyChanList, myChannelName));
    %   the best way to find the index
    DasInfo=originalDasInfos(strcmp(MyChanList, myChannelName));
    
    % the t in data file
    iStep = 1000 / DasInfo.Freq;
    iStartTime=DasInfo.Dly+(DasInfo.Post-DasInfo.Len)*iStep;  %+1 for there is a point at zero
    iEnd=iStartTime+iStep*(DasInfo.Len-1);
    %   the original time axis
    t=iStartTime:iStep:iEnd;
    
    
    %  the time axis in figure(view)
    tv=MyCurves(i).x;
    % the data in figure
    zv=MyCurves(i).y;
    
    
    T0=tv(1);
    T1=tv(end);
    
    % find the index of the modifying data
    it0=find(t>=T0,1,'first');
    it1=find(t<=T1,1, 'last');
    if isempty(it0) || isempty(it1)
        msgbox('the data window is out of range')
        return
    end
    
    x=tv;
    CurrentLength=it1-it0+1;
    
    if CurrentLength<1
        break
    end
    y=zv;
    dataLen=DasInfo.Len;
    if dataLen<CurrentLength
        msgbox('the data window is wrong')
    end
    myAddress=DasInfo.Addr+(it0-1)*DasInfo.DatWth;  % addr=len*width
    w=modifyMyData(CurrentDataFile,DasInfo,y,myAddress);
end





% mget(mw,c(1).name,'D:\')
%% put File, target file, save file
putFile=getFile;
%% only modify data file
for i=1:length(subFolders);
    cd(ccs,['..' filesep subFolders{i}]);
    dirStruct=dir(ccs);
    myFile=putFile{i};
    if isFTP_FileExist(dirStruct,myFile)
        delete(ccs,myFile)
    end
    mput(ccs,myFile);
    delete(myFile)
end

%% close FTP
close(ccs)
cd(p2a)
