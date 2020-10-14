function modifyChannelsInFile(hObject, eventdata, handles)
%% get channels

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

[originalDasInfos,n]=GetMyInfoN(CurrentInfoFile);%get all information
[MyChanList,ChannelNums]=GetMyInfoN(CurrentInfoFile,0);
currentAddress=originalDasInfos(n).Addr+originalDasInfos(n).Len*originalDasInfos(n).DatWth;


% MyChanList=ChannelsConditionning(MyChanList);
% MyChanList=lower(MyChanList);


%%
sT0=get(handles.xLeft,'String');
if iscell(sT0)
    T0=str2num(sT0{get(handles.xLeft,'Value')});
else
    T0=str2num(sT0);
end


sT1=get(handles.xRight,'String');
if iscell(sT1)
    T1=str2num(sT1{get(handles.xRight,'Value')});
else
    T1=str2num(sT1);
end
[m,n]=size(MyCurves);



% for i=1:n
%     CurrentChannel=strtok(MyCurves(i).ChnlName,'%');
%     CurrentChannel=deblank(lower(CurrentChannel));
%     ChannelIndex = strcmp(CurrentChannel,MyChanList);
%     DasInfo=originalDasInfos(ChannelIndex);
%     %  signal modify
%     
%     t=MyCurves(i).x;
%     z=MyCurves(i).y;
%     
%     
%     t0=find(t>=T0,1);
%     t1=find(t<=T1,1, 'last');
%     x=t(t0:t1);
%     CurrentLength=t1-t0+1;
%     
%     if CurrentLength<1
%         break
%     end
%     y=z(t0:t1);
%     
%     iStep = 1000 / DasInfo.Freq;
%     iStartTime=DasInfo.Dly+(DasInfo.Post+1-DasInfo.Len)*iStep;  %+1 for there is a point at zero
%     iEnd=iStartTime+iStep*(DasInfo.Len-1);
%     dataLen=DasInfo.Len;
%     
%     if dataLen>=CurrentLength && x(1)>=iStartTime && x(end)<=iEnd
%         myAddress=DasInfo.Addr+(x(1)-iStartTime)/iStep;
%         w=modifyMyData(CurrentDataFile,DasInfo,y,myAddress);
%     else
%         disp('can not modify because data is wrong')
%         return
%     end
% end



newDasInfos(n)=SetMyInfo;
for i=1:n
    newDasInfos(i)=SetMyInfo;
    CurrentChannel=strtok(MyCurves(i).ChnlName,'%');
    CurrentChannel=deblank((CurrentChannel));
    ChannelIndex = strcmp(CurrentChannel,MyChanList);
    DasInfo=originalDasInfos(ChannelIndex); % old DasInfo
    %  signal modify
    t=MyCurves(i).x;
    z=MyCurves(i).y;
    
    
    t0=find(t>=T0,1);
    t1=find(t<=T1,1, 'last');
    x=t(t0:t1);
    CurrentLength=t1-t0+1;
    
    if CurrentLength<1
        break
    end
    y=z(t0:t1);
    
    newDasInfos(i).FileType='swip_das01';        %10 
    ChnlId=getId4Name(CurrentChannel);
    if isempty(ChnlId)
        msgbox(['ChnlName=' CurrentChannel ' is not valid, Please check!'])
        return
    end
    
    
    newDasInfos(i).ChnlId=ChnlId;         %2  
    %mystr=zeros(1,12);
    
    newDasInfos(i).ChnlName(1:length(CurrentChannel))=CurrentChannel;       %12 
    newDasInfos(i).Addr=int32(currentAddress);           %4  
    newDasInfos(i).Freq=single(1000*(CurrentLength-1)/(t(t1)-t(t0)));     %4
    newDasInfos(i).Len=int32(CurrentLength);            %4
    
    
    if t(t0)>=0
        newDasInfos(i).Dly=t(t0);          %4  
        newDasInfos(i).Post=newDasInfos(i).Len;           %4
    else
        newDasInfos(i).Dly=0;          %4  
        newDasInfos(i).Post=int32(t(t1)*(CurrentLength-1)/(t(t1)-t(t0)))+1;           %4  
    end
    
    newDasInfos(i).MaxDat=0;         %2  
    newDasInfos(i).LowRang=0;      %4  
    newDasInfos(i).HighRang=0;     %4  
    newDasInfos(i).Factor=1;       %4  
    newDasInfos(i).Offset=0;       %4  
    Unit=MyCurves(i).Unit;
    if iscell(Unit)
        Unit=Unit{1};
        newDasInfos(i).Unit(1:length(Unit))=Unit;
    else
        newDasInfos(i).Unit(1:length(Unit))=Unit;
    end%8
    
    newDasInfos(i).AttribDt=int16(3);       %2  
    newDasInfos(i).DatWth=int32(4);         %2  
    %Sum=74
    %sparing for later use
    %newDasInfos(i).SparI1=0;         %2  
    %newDasInfos(i).SparI2=0;         %2  
    %newDasInfos(i).SparI3=0;         %2  
    %newDasInfos(i).SparF1=0;       %4  
    %newDasInfos(i).SparF2=0;       %4  
    %mystr=zeros(1,8);
    %newDasInfos(i).SparC1=char(mystr);         %8  
    %newDasInfos(i).SparC2='Developed by SXM';         %16 
    %mystr=zeros(1,10);
    %newDasInfos(i).SparC3=char(mystr);         %10 3 
    %Total  Sum=122
    %begin to save das
    if isempty(DasInfo)
        w=SaveMyInfo(CurrentInfoFile,newDasInfos(i));
        w=SaveMyData(CurrentDataFile,newDasInfos(i),y,'a');
        currentAddress=currentAddress+newDasInfos(i).Len*newDasInfos(i).DatWth;
    else
        iStep = 1000 / DasInfo.Freq;
        iStartTime=DasInfo.Dly+(DasInfo.Post-DasInfo.Len)*iStep;  %+1 for there is a point at zero
        iEnd=iStartTime+iStep*(DasInfo.Len-1);
        dataLen=DasInfo.Len;
        if dataLen>=CurrentLength && x(1)>=iStartTime && x(end)<=iEnd
            myAddress=DasInfo.Addr+((x(1)-iStartTime)/iStep)*DasInfo.DatWth;  % addr=len*width
            w=modifyMyData(CurrentDataFile,DasInfo,y,myAddress);
        else
            disp('data is wrong')
        end
    end
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


