function [y,x,varargout]=hl2adb(CurrentShot,CurrentChannel,varargin)


%   This is copylefted free software,
%   but services is not free. Thank you for your cooperation.
%   Once your feedback is accepted, you can get free service two times.
%
%
%HL2ADB data download program
%
%[vecY,vecT,strSys,strUnit]=hl2adb(iCurrentShot,strCurrentChannel,iTstart/strCurrentSysName,
%iTend/strInfFilePath,iInterpPeriod/strFrequency,strCurrentSysName,strCurrentDataFile,structCurrentDasInf,strInfFilePath);
%
% option=1 means the item is necessary, option=0 means the item is optional
% input
% option  VarName             DataType           Meaning
% 1      iCurrentShot:       int                shot number
% 1      strCurrentChannel:  char/cell array     channel name(s)
% 0      iTstart/strSys:     int/char         starting time/system
% 0      iTend:              int/double         ending time
% 0      iInterpPeriod:      int/double         interpolation time
% 0      strFrequency:     char              frequency in Hz
% 0      strCurrentSysName:  char        system name which the channel belongs to
% 0      strCurrentDataFile: char        data file name where the channel's data is stored
% 0      strCurrentDasInf:   char        information file name corresponding to the data file
% 0      strInfFilePath:     char        path for the information file other than HL-2A database, such as your local file
%
% output:
% option    VarName             DataType        Meaning
% 1         VecY                double array    output y
% 1         VecT                double array    output t
% 0         strSys              char            system name
% 0         strUnit             char            unit name
% 0         strChannels         char            Channel name
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
%
% Most of the defaults inherit the lastest values you used, you can change them by inputting the values explicitly.
%   EXAMPLE1: general call format
%   iCurrentShot=9863;
%   strCurrentChannel='@ip'; @ mean combination channels defined in GetCurveByFormula
%   [Ip,t] = hl2adb(iCurrentShot,strCurrentChannel,'','','','VX1');
%
%
%   EXAMPLE2: for sampling signal
%   if you want to use a specific frequency to sample to signal
%   iCurrentShot=9863;
%   strCurrentChannel='it';
%   strFrequency='100hz';
%   [It,t] = hl2adb(iCurrentShot,strCurrentChannel,'','',strFrequency,'mmc');
%
%   EXAMPLE3: for file in local drive
%   if you want to read the file from you local drive
%   iCurrentShot=9863;
%   strCurrentChannel='it';
%   strInfFilePath='D:\inf'; the data file can in 'D:\data' or in 'D:\inf', both is OK
%   [It,t] = hl2adb(iCurrentShot,strCurrentChannel,'mmc',strInfFilePath);
%
%   EXAMPLE4: for file in local drive
%   if you want to read the file from you local drive
%   iCurrentShot=9863;
%   strCurrentChannel='it';
%   strInfFilePath='D:\inf'; the data file can in 'D:\data' or in 'D:\inf', both is OK
%   [It,t] = hl2adb(iCurrentShot,strCurrentChannel,'','','','mmc','','',strInfFilePath);
%




%   Author(s): SONG Xianming
%   Tested by advanced software engineer LUO Cuiwen. Southwestern Institute of Physic, Chengdu, China.



global  Tstart Tend InterpPeriodFreq bFullOrFast
if isempty(bFullOrFast)
    bFullOrFast=1;
end


%initialization for shortcut
channelFinded=CurrentChannel;
CurrentSysName=[];
CurrentDataFile=[];
CurrentDasInf=[];
InfFilePath=[];
MyChanLists=CurrentChannel;




zMatrix=[];


%     InterpPeriod=[];  %initialize, not interfered by last call
%  assign for the related variable
%% 2016.7.11  InterpPeriodFreq is a new var, not change by last call



if nargin>=3
    if ~isempty(varargin{1}) && (ischar(varargin{1}) || iscell(varargin{1})) %
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
            msgbox('wrong local path: Tstart may be string?');
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
        InterpPeriodFreq=sInterpPeriod;
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
if nargin==9
    InfFilePath=varargin{7};
    if exist(InfFilePath,'dir')~=7
        msgbox('wrong local path: Your path may be with file name.');
        return
    end
end




if ~isempty(CurrentSysName) || ~iscell(CurrentSysName)
    if iscell(CurrentChannel)
        nChannel=length(CurrentChannel);
        Unit=cell(1,nChannel);
        x=0;
        y=zeros(1,nChannel);
    else
        Unit=[];
        x=0;
        y=0;
    end
else
        Unit=[];
        x=0;
        y=0;
end





%build a bridge to transfer the client channel to database one
if ~iscell(CurrentChannel)
    CurrentChannel=channelTransfer(CurrentChannel);
end




%------------------------------------------------------------------------
if ~iscell(CurrentChannel) && lower(CurrentChannel(1))=='@' %{'ip','dh','dv'}
    [y,x,CurrentSysName,Unit]=GetCurveByFormula(CurrentShot,CurrentChannel);
elseif ~iscell(CurrentChannel) && strcmp(CurrentChannel(1),'#') %for vec curve
    
    CurrentInfoFile = getInfFileName(CurrentShot,'VEC');
    [VECInfo,n]=GetVECInfoN(CurrentInfoFile);
    MyChanList={VECInfo(1:n).ChannelName};
    CurrentSelectNum = strmatch(lower(CurrentChannel),lower(MyChanList),'exact');
    
    CurrentDataFile=regexprep(CurrentInfoFile, '(?<!\.)([iI][nN][fF])', 'data','preservecase');
    CurrentDataFile=regexprep(CurrentDataFile, '(\.[iI][nN][fF])', '\.dat','preservecase');
    
    
    CurrentVecInf=VECInfo(CurrentSelectNum);
    [y,x,CurrentSysName,Unit]=hl2avec(CurrentShot,CurrentChannel,CurrentDataFile,CurrentVecInf);
    
    
    
elseif  ~iscell(CurrentChannel) && (strcmp(CurrentChannel(1),'_') && ~strcmp(CurrentChannel(end),'_')) %FFT
    [y,x,CurrentSysName,Unit]=hl2adb(CurrentShot,CurrentChannel(2:end),'','',1);  %should get all data for fft
    %get the fft parameter from debug windows
    %     myParam=get(handles.Debug1,'String');
    myParam=[];
    if isempty(myParam) || length(myParam)<10
        nfft=2048;
        shift=128;
        base=-60;%the base of spectrum,above of which,the spectrum values
        % are nomalized between 0 and 1,and below of which,they are replaced by
        % the base value.
        colortype=1;% colormap label,if colortype is equal to 1,the colormap
        % is hot,else it is gray.
        label_signal=0;
        %         myParamString=[num2str(nfft) ':' num2str(shift) ':' num2str(base) ':' num2str(colortype) ':' num2str(label_signal)];
        %         set(handles.Debug1,'String',myParamString);
    else  % parameter from the view
        [nfft, myParam] = strtok(myParam, ':');
        [shift, myParam] = strtok(myParam, ':');
        [base, myParam] = strtok(myParam, ':');
        [colortype, myParam] = strtok(myParam, ':');
        label_signal =myParam(2:end);
        
        
        nfft=str2double(nfft);
        shift =str2double(shift);
        base= str2double(base);
        colortype= str2double(colortype);
        label_signal =str2double(label_signal);
    end
    [tout,f,C]=autopower_t_f(y,x,nfft,shift,base,colortype,label_signal);
    
    if nargout==6
        x=reshape(tout,[numel(tout),1]);
        y=reshape(f,[numel(f),1]);
        zMatrix=C;
        Unit='kHz';
        Chs=CurrentChannel;
    end
elseif ~iscell(CurrentChannel) && strcmp(CurrentChannel(1),'!') %for formula
    
    [z,x,CurrentSysName,Unit]=hl2adb(CurrentShot,CurrentChannel(2:length(CurrentChannel)),CurrentSysName);
    zd=hl2azd(CurrentShot,CurrentChannel(2:length(CurrentChannel)),CurrentSysName);
    y=z-zd;
    
elseif ~iscell(CurrentChannel) && strcmp(CurrentChannel(1),'=') %for formula
    [Expression,Dependence]=GetFormula(CurrentChannel);
    [y,x]=Formula(CurrentShot,Expression,Dependence);
    % check whether there is any inf
    index=find(isinf(y));
    y(index)=1./max(abs(y));
    
    
elseif iscell(CurrentChannel) && strcmp(CurrentChannel{1}(1),'!') %for array
    CurrentChannel=regexprep(CurrentChannel,'!','');
    [z,x,CurrentSysName,Unit]=hl2adb(CurrentShot,CurrentChannel,CurrentSysName);
    zd=hl2azd(CurrentShot,CurrentChannel,CurrentSysName);
    for i=1:length(CurrentChannel)
        y(:,i)=z(:,i)-zd(i);
    end
    
    % elseif iscell(CurrentChannel) && size(CurrentChannel,1)>1

else
    % cell CurrentChannel for more channels
    %-------------------------------------------------------------------
    %TRY TO FIND THE CurrentSysName
    if isempty(CurrentSysName)
        if iscell(CurrentChannel)
            CurrentSysName=getSystemName(CurrentChannel{1});
        else
            CurrentSysName=getSystemName(CurrentChannel);  % may output empty
        end
    end
    
    if iscell(CurrentSysName) && ~isempty(CurrentSysName)
        CurrentSysName=CurrentSysName{1};
    end
%     if iscell(CurrentSysName) 
%         CurrentSysName=CurrentSysName{1};
%     end
    %-------------------------------------------------------------------
    %initialization for out
    
    
    isOK=0;
    
    %     if  nargout>=3
    %         varargout{1}=[];
    %     end
    %
    %     if nargout>=4
    %         varargout{2}=[];
    %     end
    %
    
    %shortcut when got the dat file and inf file
    if isempty(CurrentDataFile) || isempty(CurrentDasInf)
    else
        [x,y]=GetMyCurveN(CurrentDataFile,CurrentDasInf);
        
        
        Unit={CurrentDasInf(:).Unit};
        MyChanLists={CurrentDasInf(:).ChnlName};
        Unit = regexp(Unit, '^[^\s\o0]*','match','once');  %begin not space not null
        MyChanLists = regexp(MyChanLists, '^[^\s\o0]*','match','once');  %begin not space not null
        
        %         myPattern='\w*';
        %         Unit=regexp(Unit, myPattern, 'match','once');
    end
    
    if length(x)>1%if not ok search further
        isOK=1;
    end
    
    
    
    
    
    if ~isOK %getting the channel
        isChannelOK=0;
        %%
        if ~isempty(CurrentSysName) && length(CurrentSysName)==3
            CurrentInfoFile = getInfFileName(CurrentShot,CurrentSysName);
            % if the sysName is wrong, try to find the right sysName and go ahead.
            if ~exist(CurrentInfoFile,'file') 
                if iscell(CurrentChannel)
                    CurrentSysName=getSystemName(CurrentChannel{1});
                else
                    CurrentSysName=getSystemName(CurrentChannel);  % may output empty
                end
                if iscell(CurrentSysName) && ~isempty(CurrentSysName)
                    CurrentSysName=CurrentSysName{1};
                    CurrentInfoFile = getInfFileName(CurrentShot,CurrentSysName);
                else
                    CurrentInfoFile ='';
                end

            end
            
            
            if ~exist(CurrentInfoFile,'file')
                 isChannelOK=1;
                 setappdata(0,'MyErr',strcat('No/',num2str(CurrentShot),'/',CurrentChannel));
            else
                [MyPath, MyFile, ext] = fileparts(CurrentInfoFile);
                [CurrentInfoFile,ChannelIndex,channelFinded]=GetChannelIndex(MyPath,[MyFile ext],CurrentChannel);
                if ~isempty(ChannelIndex)%not ok, then search all file for the channel
                    isChannelOK=1;
                end %channel found or return
            end
        end %~isempty(CurrentSysName) && length(CurrentSysName)==3
        
        %%
        
        %----------------------------------------------------------------------
        if ~isChannelOK%getting the channel
            
            if isempty(InfFilePath)
                [sMyShot,MyPath,Mylist] = GetShotPath(CurrentShot);
            else
                [sMyShot,MyPath,Mylist] = GetShotPath(CurrentShot,InfFilePath);
            end
            
            if isempty(Mylist)
                setappdata(0,'MyErr',strcat('No/',num2str(CurrentShot),'/',CurrentChannel));
                return
            end%isempty(Mylist)
            
            
            
            [m,n]=size(Mylist);
            for i=1:n
                %if we use function the performance will reduce.
                MyFile=Mylist{i};
                [CurrentInfoFile,ChannelIndex,channelFinded]=GetChannelIndex(MyPath,MyFile,CurrentChannel);
                if ~isempty(ChannelIndex)%ok then break
                    isChannelOK=1;
                    break
                elseif i==n
                    warnstr=strcat(CurrentChannel,'Channel not found in Shot /',sMyShot);%promt the need to update configuration
                    setappdata(0,'MyErr',warnstr);
                    %                     warndlg(warnstr)
                    %                     return
                end
            end%for
        end%~isChannelOK
        
        if ~isOK && isChannelOK %getting the curve
            if ~exist(CurrentInfoFile,'file')
                warnstr=strcat(CurrentInfoFile,'file not found in Shot /');%promt the need to update configuration
                setappdata(0,'MyErr',warnstr);
            else
                %      from information file to data file
                CurrentDataFile=regexprep(CurrentInfoFile, '(?<!\.)([iI][nN][fF])', 'data','preservecase');
                CurrentDataFile=regexprep(CurrentDataFile, '(\.[iI][nN][fF])', '\.dat','preservecase');
                % refreshing the DasInfos
                [DasInfos,ChannelNums]=GetMyInfoN(CurrentInfoFile,ChannelIndex);
                CurrentDasInf=DasInfos(ChannelIndex);
                [x,y]=GetMyCurveN(CurrentDataFile,CurrentDasInf);
                if isempty(y)%still not ok return
                    warnstr1=getappdata(0,'MyErr');
                    warnstr2=strcat('Channel found in this Shot /',' but no curve');
                    %                 warnstr=strvcat(warnstr,'Check the data windows, the curve may be out ROI');%promt the need to update configuration
                    warnstr={warnstr1,warnstr2,'Check the data windows, the curve may be out ROI'};%promt the need to update configuration
                    setappdata(0,'MyErr',warnstr);
                else
                    isOK=1;
                    Unit={CurrentDasInf(:).Unit};
                    MyChanLists={CurrentDasInf(:).ChnlName};
                    Unit = regexp(Unit, '^[^\s\o0]*','match','once');  %begin not space not null
                    MyChanLists = regexp(MyChanLists, '^[^\s\o0]*','match','once');  %begin not space not null
                end
            end
        end%~isChannelOK
    end%~isOK
end

%% 
verbose=getappdata(0,'verbose');
if isempty(verbose)
    verbose=0;
end
if verbose==1
    if length(x)>1
        if isnumeric(x)
            
            
            figure
            plot(x,y)
            if ~iscell(MyChanLists)
                title(MyChanLists)
            else
                mystr=[];
                for i=1:length(MyChanLists)
                  mystr=[mystr,' ', MyChanLists{i}];  
                end
                title(mystr)
            end

        else
            msgbox('wrong when getting data')
        end
    else
        setappdata(0,'MyErr','db, wrong when get data');
    end
end

%%

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
