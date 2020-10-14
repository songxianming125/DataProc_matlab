function [y,x,varargout]=hl2amat(CurrentShot,CurrentChannel,varargin)
%
%
%[vecY,vecT,t,strSys,strUnit]=hl2amat(dCurrentShot,strCurrentChannel,dTstart/strCurrentSysName,
%dTend/strInfFilePath,dFrequency,strCurrentSysName,dWidth,dOffset,strInfFilePath);
%
% option=1 means the item is necessary, option=0 means the item is optional
% input
% option  VarName             DataType           Meaning/default
% 1      dCurrentShot:       double                shot number
% 1      strCurrentChannel:  char     channel name(s)
% 0      dTstart/strSys:     int/char         starting time in ms\natural/system
% 0      dTend/strInfFilePath:  double         ending time in ms\natural/path
% 0      dFrequency:           double              frequency in Hz\1k
% 0      strCurrentSysName:  char        system name which the channel belongs to
% 0      dWidth: double        data width in us\20
% 0      dOffset:   double     data offset in us\0
% 0      strInfFilePath:     char        path for the information file other than HL-2A database, such as your local file
%
% output:
% option    VarName             DataType        Meaning
% 1         VecY                double array    output y
% 1         VecT                double array    output x (unsuccesive)
% 0         t                   double array         output t (succesive)
% 0         strSys              char            system name
% 0         strUnit             char            unit name
%
%       The dependent function
%       1   getDriver
%       2   GetShotPath
%       3   GetChannelIndex
%       4   GetCurveByFormula
%       5   GetMyInfoN
%       6   GetMyCurve
%
%
%   for the combination channels defined in GetCurveByFormula, use prifix @ at the channel name
%   strCurrentSysName is used to accelerate the subroutine, if omitted or with a wrong name, the subroutine will scan all system
%   if you omit some optional item, use ('') to jump the position
%
% [y,x,t,strSys,strUnit]=hl2amat(16617,'mchcn4',0,1200,100,'hcn',20,5,'c:\das');
% [y,x,t,strSys,strUnit]=hl2amat(16617,'mece_14',0,1200,100,'ecg',20,5);
%
%
%   Author(s): SONG Xianming 2009\01\06
%   Tested by advanced software engineer LUO Cuiwen.
%   All right reserved. Southwestern Institute of Physic, Chengdu, China.
%   No part of the software can be copied or used without the official approval. Thank you for your cooperation.
global  Tstart Tend dFrequency dWidth dOffset

%initialization for shortcut
CurrentSysName=[];
InfFilePath=[];
dFrequency=1000;
dWidth=20;
dOffset=0;

%     InterpPeriod=[];  %initialize, not interfered by last call
%assign for the related variable
if nargin>=3
    if ~isempty(varargin{1}) && ischar(varargin{1}) %
        CurrentSysName=varargin{1};
        if isempty(CurrentSysName)
            CurrentSysName=getappdata(0,'SubSystem');
        end
    end
end

if nargin>=4
    if ~isempty(varargin{2}) && ischar(varargin{2}) %
        InfFilePath=varargin{2};
        if exist(InfFilePath,'dir')~=7
            msgbox('wrong local path');
            return
        end
    elseif isnumeric(varargin{1})
        Tstart1=varargin{1};
        Tend1=varargin{2};
        if  ~isempty(Tstart1) && ~isempty(Tend1)
            if Tstart1<=Tend1
                Tstart=Tstart1;
                Tend=Tend1;
            elseif Tstart1>Tend1
                Tstart=Tend1;
                Tend=Tstart1;
            end
        end
    end
end


if nargin>=5
    sInterpPeriod=varargin{3};
    if ~isempty(sInterpPeriod)
        dFrequency=sInterpPeriod;
    end
end

if nargin>=6
    CurrentSysName=varargin{4};
    if isempty(CurrentSysName)
        CurrentSysName=getappdata(0,'SubSystem');
    end
end

if nargin>=8
    dWidth=varargin{5};
    dOffset=varargin{6};
end %nargin>=4
if nargin==9
    InfFilePath=varargin{7};
    if exist(InfFilePath,'dir')~=7
        msgbox('wrong local path');
        return
    end
end



%-------------------------------------------------------------------
%initialization for out

x=[];
y=[];
isOK=0;

if  nargout>=3
    varargout{1}=[];
end
if nargout>=4
    varargout{2}=[];
end
if nargout>=5
    varargout{3}=[];
end




if ~isOK %getting the channel
    isChannelOK=0;
    if isempty(InfFilePath)
        [sMyShot,MyPath,Mylist] = GetShotPath(CurrentShot);
    else
        [sMyShot,MyPath,Mylist] = GetShotPath(CurrentShot,InfFilePath);
    end
    
    if isempty(Mylist)
        setappdata(0,'MyErr',strcat('No/',num2str(CurrentShot),'/',CurrentChannel));
        return
    end%isempty(Mylist)
    
    %CurrentSys is search first, if not found then search all Sys
    if length(CurrentSysName)==3
        MyFile=Mylist{1};
        if length(MyFile)>8
            s=MyFile(6:8);
            MyFile=strrep(MyFile,s,CurrentSysName);%the prefered filename
            
            %special for multiple channels
            [CurrentInfoFile,ChannelIndex,DasInfos]=GetChannelIndex(MyPath,MyFile,CurrentChannel);
            if ~isempty(ChannelIndex)%not ok, then search all file for the channel
                isChannelOK=1;
            end %channel found or return
        end%length(MyFile)>8
    end%length(CurrentSysName)==3
    
    
    %----------------------------------------------------------------------
    if ~isChannelOK%getting the channel
        [m,n]=size(Mylist);
        for i=1:n
            %if we use function the performance will reduce.
            MyFile=Mylist{i};
            [CurrentInfoFile,ChannelIndex,DasInfos]=GetChannelIndex(MyPath,MyFile,CurrentChannel);
            if ~isempty(ChannelIndex)%ok then break
                isChannelOK=1;
                break
            elseif i==n
                warnstr=strcat(CurrentChannel,'Channel not found in Shot /',sMyShot);%promt the need to update configuration
                setappdata(0,'MyErr',warnstr);
                %                     warndlg(warnstr)
                return
            end
        end%for
    end%~isChannelOK
    
    if ~isOK && isChannelOK %getting the curve
        CurrentDataFile=regexprep(CurrentInfoFile, '(?<!\.)([iI][nN][fF])', 'data','preservecase');
        CurrentDataFile=regexprep(CurrentDataFile, '(\.[iI][nN][fF])', '\.dat','preservecase');
        % refreshing the DasInfos
        [DasInfos,ChannelNums]=GetMyInfoN(CurrentInfoFile,ChannelIndex);
        CurrentDasInf=DasInfos(ChannelIndex);
        
        [x,y]=GetMyMatrix(CurrentDataFile,CurrentDasInf);
        if isempty(y)%still not ok return
            warnstr1=getappdata(0,'MyErr');
            warnstr2=strcat('Channel found in Shot /',sMyShot,' but no curve');
            %                 warnstr=strvcat(warnstr,'Check the data windows, the curve may be out ROI');%promt the need to update configuration
            warnstr={warnstr1,warnstr2,'Check the data windows, the curve may be out ROI'};%promt the need to update configuration
            setappdata(0,'MyErr',warnstr);
            return
        else
            isOK=1;
        end
    end%~isChannelOK
end%~isOK

if isOK %output
    if nargout>=3
        t=0:size(y,1)-1;
        varargout{1}=t*1000 / CurrentDasInf(1).Freq;
        if nargout>4
            n=length(CurrentDataFile);
            if n>7
                varargout{2}=CurrentDataFile(n-6:n-4);
            else
                varargout{2}='';
            end
        end
        if nargout==5
            varargout{3}=CurrentDasInf(1).Unit;
        end
    end %nargout>=3
end %isOK
end


