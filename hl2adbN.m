function [y,x,varargout]=hl2adbN(CurrentShot,CurrentChannel,varargin)
%This program is developed by Dr. Song Xianming and tested by advanced
%software engineer Luo Cuiwen.
%Southwestern Institute of Physic, Chengdu,China. All right reserved.
%No part of the software can be copied or used without the official
%approval. Thank you for your cooperation.
%The way to call
%[vecY,vecT,strSys,strUnit]=hl2adb(iCurrentShot,strCurrentChannel,iTstart,iTend,iInterpPeriod,strCurrentSysName,strCurrentDataFile,structCurrentDasInf);
%str mean string, i mean integer, vec mean vector

%The dependent function
%1 getDriver
%2 GetShotPath
%3 GetChannelIndex
%4 logindlg
%5 GetMyInfoN
%6 GetMyCurveN

%   EXAMPLE1:  for more channels in the same file
%   iCurrentShot=9863;
%   myCurrentChannel={'NBLF_I3VAcc' 'NBLF_I4VAcc' 'NBLF_I3IDec' 'NBLF_I4IDec'};
%   [y,t]=hl2adb(CurrentShot,myCurrentChannel,'','','','IF3'); y is two dimensional matrix


%   EXAMPLE2: for more curves in one system by regular expressions
%   iCurrentShot=20000;
%   strCurrentChannel='/sx8[1-5]/';
%   strSys='SX3';
%   [y,t] = hl2adb(iCurrentShot,strCurrentChannel,strSys);
%



%sxDriver=getDriver(CurrentShot);
global  MyPicStruct Tstart Tend InterpPeriod


%initialization for shortcut
CurrentSysName=[];
CurrentDataFile=[];
CurrentDasInf=[];
%assign for the related variable

if nargin>=3
    if ~isempty(varargin{1}) && (ischar(varargin{1}) || iscell(varargin{1})) %
        CurrentSysName=varargin{1};
        if isempty(CurrentSysName)
            CurrentSysName=getappdata(0,'SubSystem');
        end
    end
end


if nargin>=4
    Tstart1=varargin{1};
    Tend1=varargin{2};
    if  ~isempty(Tstart1) && ~isempty(Tend1)
        if Tstart1<=Tend1
            Tstart=Tstart1;
            Tend=Tend1;
        elseif Tstart>Tend
            Tstart=Tend1;
            Tend=Tstart1;
        end
    end
end

if nargin>=5
    InterpPeriod1=floor(varargin{3});
    if InterpPeriod1>=1
        InterpPeriod=InterpPeriod1;
    end
end

if nargin>=6
    CurrentSysName=varargin{4};
    if isempty(CurrentSysName)
        CurrentSysName=getappdata(0,'SubSystem');
    end
end

if nargin>=8
    CurrentDataFile=varargin{5};
    CurrentDasInf=varargin{6};
end %nargin>=4








%-------------------------------------------------------------------
%initialization for out

x=[];
y=[];
Unit='au';
isOK=0;




if iscell(CurrentChannel) && iscell(CurrentSysName)  % more channel in more sys
    n=length(CurrentChannel);
    newCurrentSysName=cell(1,n);
    Unit=cell(1,n);
    MyChanLists=cell(1,n);
    x=cell(1,n);
    y=cell(1,n);
    zMatrix=cell(1,n);
    for i=1:n
        if isempty(CurrentSysName)
            [y1,x1,CurrentSysName1,Unit1,Chs1,z1]=hl2adb(CurrentShot,CurrentChannel{i});
        else
            if iscell(CurrentSysName)
                [y1,x1,CurrentSysName1,Unit1,Chs1,z1]=hl2adb(CurrentShot,CurrentChannel{i},CurrentSysName{i});
            else
                [y1,x1,CurrentSysName1,Unit1,Chs1,z1]=hl2adb(CurrentShot,CurrentChannel{i},CurrentSysName);
            end
        end
        y(i)={y1};
        x(i)={x1};
        newCurrentSysName(i)={CurrentSysName1};
        Unit(i)=Unit1;
        MyChanLists(i)=Chs1;
        zMatrix(i)={z1};
    end
    CurrentSysName=newCurrentSysName;
elseif iscell(CurrentChannel) && isempty(CurrentSysName)  % more channel in more sys but omited
    n=length(CurrentChannel);
    newCurrentSysName=cell(1,n);
    Unit=cell(1,n);
    MyChanLists=cell(1,n);
    x=cell(1,n);
    y=cell(1,n);
    zMatrix=cell(1,n);
    for i=1:n
        if isempty(CurrentSysName)
            SysName=getSystemName(CurrentChannel{i});
            [y1,x1,CurrentSysName1,Unit1,Chs1,z1]=hl2adb(CurrentShot,CurrentChannel{i},SysName);
        end
        y(i)={y1};
        x(i)={x1};
        newCurrentSysName(i)={CurrentSysName1};
        if iscell(Unit1) && length(Unit1)>1
            Unit(i)={Unit1};
        else
            Unit(i)=Unit1;
        end
        
        if iscell(Chs1) && length(Chs1)>1
            MyChanLists(i)={Chs1};
        else
            MyChanLists(i)=Chs1;
        end
        zMatrix(i)={z1};
    end
    CurrentSysName=newCurrentSysName;
    
else
    MyChanLists=[];
    if isempty(CurrentSysName)
%         setSystemName(CurrentShot,1);
        CurrentSysNames=getSystemName(CurrentChannel);
    else
        CurrentSysNames=CurrentSysName;
    end
    
    if iscell(CurrentSysNames)
        
        n=length(CurrentSysNames);
        newCurrentSysName=cell(1,n);
        Unit=cell(1,n);
        newMyChanLists=cell(1,n);
        x=cell(1,n);
        y=cell(1,n);
        zMatrix=cell(1,n);
        
        
        
        for i=1:length(CurrentSysNames)
            CurrentSysName=CurrentSysNames{i};
            if ~isempty(CurrentSysName) && length(CurrentSysName)==3
                CurrentInfoFile = getInfFileName(CurrentShot,CurrentSysName);
                [MyPath, MyFile, ext] = fileparts(CurrentInfoFile);
                
                [DasInfo,n]=GetMyInfoN(CurrentInfoFile);
                
                MyChanList={DasInfo(1:n).ChnlName};
                MyChanList=ChannelsConditionning(MyChanList);
                patternname=['^' CurrentChannel '$'];
                s = regexpi(MyChanList, patternname, 'start');
                Indexs=cellfun('isempty',s);
                ChannelIndexs=find(~Indexs);
                if ~isempty(ChannelIndexs)
                    MyChanLists=MyChanList(ChannelIndexs);
                else
                end
            else
                
                
            end %~isempty(CurrentSysName) && length(CurrentSysName)==3
            
            
            
            if isempty(MyChanLists)
                [sMyShot,MyPath,MyFiles] = GetShotPath(CurrentShot);
                [~,filenumber]=size(MyFiles);
                
                
                for i=1:filenumber
                    MyChanList=[];
                    MyFile=MyFiles{i};
                    CurrentSysName=MyFile(6:8);
                    if strcmpi(MyFile(6:8),'vec')
                        continue
                    end
                    
                    
                    CurrentInfoFile=fullfile(MyPath,MyFile);
                    [DasInfo,n]=GetMyInfoN(CurrentInfoFile);
                    
                    MyChanList={DasInfo(1:n).ChnlName};
                    MyChanList=ChannelsConditionning(MyChanList);
                    patternname=['^' CurrentChannel '$'];
                    s = regexpi(MyChanList, patternname, 'start');
                    Indexs=cellfun('isempty',s);
                    ChannelIndexs=find(~Indexs);
                    
                    if ~isempty(ChannelIndexs)
                        MyChanLists=MyChanList(ChannelIndexs);
                        break
                    end
                end%for i=
            end
            
            if isempty(MyChanLists)
            else
                %                 [y,x,CurrentSysName,Unit,CurrentChannel]=hl2adb(CurrentShot,MyChanLists,CurrentSysName);
                [y1,x1,CurrentSysName1,Unit1,Chs1,z1]=hl2adb(CurrentShot,MyChanLists,CurrentSysName);
            end
            
            
            
            y(i)={y1};
            x(i)={x1};
            newCurrentSysName(i)={CurrentSysName1};
            if iscell(Unit1) && length(Unit1)>1
                Unit(i)={Unit1};
            else
                Unit(i)=Unit1;
            end
            
            if iscell(Chs1) && length(Chs1)>1
                newMyChanLists(i)={Chs1};
            else
                newMyChanLists(i)=Chs1;
            end
            zMatrix(i)={z1};
        end %for i=1:length(CurrentSysNames)
        CurrentSysName=newCurrentSysName;
        MyChanLists=newMyChanLists;
    else
        CurrentSysName=CurrentSysNames;
        if ~isempty(CurrentSysName) && length(CurrentSysName)==3
            CurrentInfoFile = getInfFileName(CurrentShot,CurrentSysName);
            [MyPath, MyFile, ext] = fileparts(CurrentInfoFile);
            
            [DasInfo,n]=GetMyInfoN(CurrentInfoFile);
            
            MyChanList={DasInfo(1:n).ChnlName};
            MyChanList=ChannelsConditionning(MyChanList);
            patternname=['^' CurrentChannel '$'];
            s = regexpi(MyChanList, patternname, 'start');
            Indexs=cellfun('isempty',s);
            ChannelIndexs=find(~Indexs);
            if ~isempty(ChannelIndexs)
                MyChanLists=MyChanList(ChannelIndexs);
            else
            end
        else
            
            
        end %~isempty(CurrentSysName) && length(CurrentSysName)==3
        
        
        
        if isempty(MyChanLists)
            [sMyShot,MyPath,MyFiles] = GetShotPath(CurrentShot);
            [~,filenumber]=size(MyFiles);
            
            
            for i=1:filenumber
                MyChanList=[];
                MyFile=MyFiles{i};
                CurrentSysName=MyFile(6:8);
                if strcmpi(MyFile(6:8),'vec')
                    continue
                end
                
                
                CurrentInfoFile=fullfile(MyPath,MyFile);
                [DasInfo,n]=GetMyInfoN(CurrentInfoFile);
                
                MyChanList={DasInfo(1:n).ChnlName};
                MyChanList=ChannelsConditionning(MyChanList);
                patternname=['^' CurrentChannel '$'];
                s = regexpi(MyChanList, patternname, 'start');
                Indexs=cellfun('isempty',s);
                ChannelIndexs=find(~Indexs);
                
                if ~isempty(ChannelIndexs)
                    MyChanLists=MyChanList(ChannelIndexs);
                    break
                end
            end%for i=
        end
        
        if isempty(MyChanLists)
            x=0;
            y=0;
            setSystemName(CurrentShot,1);
            
        else
            [y,x,CurrentSysName,Unit,CurrentChannel]=hl2adb(CurrentShot,MyChanLists,CurrentSysName);
        end
    end
end




if nargout>=3
    if isempty(CurrentSysName)
        n=length(CurrentDataFile);
        if n>7
            varargout{1}=CurrentDataFile(n-6:n-4);
        else
            varargout{1}=CurrentSysName;
        end
    else
        varargout{1}=CurrentSysName;
    end
end %nargout>=3
if nargout>=4
    if ~iscell(Unit)
        varargout{2}={Unit};
    else
        varargout{2}=Unit;
    end
end
if nargout>=5
    if isempty(MyChanLists)
        if ~iscell(CurrentChannel)
            varargout{3}={channelFinded};
        else
            varargout{3}=channelFinded;
        end
    else
        if ~iscell(MyChanLists)
            varargout{3}={MyChanLists};
        else
            varargout{3}=MyChanLists;
        end
    end
end

if nargout>=6
    varargout{4}=zMatrix;
end


return