function varargout = DP(varargin)
%This program is developed by Dr. Song Xianming and tested by advanced
%software engineer Luo Cuiwen.
%Southwestern Institute of Physic, PO. Box 432#, Chengdu, China. All right reserved.
%No part of the software can be copied or used without the official
%approval. Thank you for your cooperation.
% coauthor of this program from 2013:
% Dr. Tao Lan from CAS Key Laboratory of Basic Plasma Physics, USTC 1958-2012
% Dr. Zhong Wulv from Southwestern Institute of Physic, Chengdu,China.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DP_OpeningFcn, ...
    'gui_OutputFcn',  @DP_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
elseif nargin && isnumeric(varargin{1})
    switch varargin{1}
        case 0
            setappdata(0,'machine','hl2a');
        case 1
            setappdata(0,'machine','localdas');
        case 2
            setappdata(0,'machine','east');
        case 3
            setappdata(0,'machine','exl50');
            
        case 4
            setappdata(0,'machine','hl2m');
    end
else
    
    machine=getappdata(0,'machine');
    if isempty(machine)
        machine=getOptionParameter('machine');
        changeDriver(machine);
    end
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% if ~isempty(getappdata(0,'DPready')) && getappdata(0,'DPready')
%
%     ShowWarning(1,[],handles)
% end


%----------------------------------------------------------------------
function DP_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
setappdata(handles.DP,'SavedVisible','off');
set(handles.DP,'DeleteFcn',{@myExit,handles});
%%
function myExit(hObject, eventdata, handles)

clear all
function varargout = DP_OutputFcn(hObject, eventdata, handles)
global MyPicStruct  InterpPeriod SmoothStatus bFullOrFast bSortMode bFacMode
%% multichildren function
% initializing the global var
%% set machine
global iCurrentFigure iTotalFigNum bFigStatus bFigActive PageAxisNumbers
setCTRLStyle(handles)
% setappdata(0,'machine','exl50');

% setappdata(0,'machine','east');

machine=getOptionParameter('machine');
if strcmpi(machine,'localdas')
    LastestShot=80020;
else
   LastestShot=GetLastestShot; 
end


set(handles.ShotNumber,'String',num2str(LastestShot));
set(handles.lbWarning,'String',['machine is ' machine])

setappdata(0,'clickConfigMode','chnlConfig');

%% set path


PageAxisNumbers=20;
iCurrentFigure=0;
iTotalFigNum=10;
% bFigStatus=zeros(1,iTotalFigNum);
% bFigActive=zeros(1,iTotalFigNum);

%%


% sxDriver=getDriver;
ShowWarning(1,[],handles)
varargout{1} = handles.output;
%initialization
MyPicStruct=MyPicInit;%init by file data
Struct2View(handles);

InterpPeriod=[];
set(handles.InterpPeriod,'String','nan');


v=0;
set(handles.tChannels,'BackgroundColor','m');
set(handles.tChannels,'UserData',v);
set(handles.tChannels,'String','Browser');




set(handles.DataMode,'BackgroundColor','m');
set(handles.DataMode,'value',1);
set(handles.LayoutMode,'value',1);%defining the mode from 0 to 7
set(handles.AccessMode,'UserData',0)
SmoothStatus=0;

bFullOrFast=0;
set(handles.AccessSpeed,'BackgroundColor','m');
set(handles.AccessSpeed,'String','FAST');

%for calibration
bFacMode=0;
% set(handles.SortMode,'BackgroundColor','m');
% set(handles.SortMode,'String','FacMode=auto');

bSortMode=0;
set(handles.SortMode,'BackgroundColor','m');
set(handles.SortMode,'String','nosorting');


ResizeDataProc(handles);
set(handles.UpdateShot,'String',['Update|',MyPicStruct.version])
set(handles.AddCurve,'KeyPressFcn',{@KeyPress_Function,handles});

setappdata(0,'handles',handles);
SetTheHandles;


if iscell(get(handles.xRight,'String'))
    R1_Callback([], [], handles)
end
subplot(handles.aBrowser)
% [X, map]=imread('russian.jpg');
[X, map]=imread('Harvard.jpg');
image(X)
colormap(map)
axis image
axis off
set(handles.DP,'visible','on')

% initialization(handles) % custom function

%#######################---------------------------------------------------
% --- Executes during object creation, after setting all properties.

function KeyPress_Function(h,eventdata,handles)
key = get(handles.DP,'currentkey');
switch key
    case {'backspace','delete'}
        return
end

function AddCurve_Callback(hObject, eventdata, handles)
%when remember the curve name, you can load it by its name
global Astring
global MyChanLists

machine=getappdata(0,'machine');
switch machine
    case {'exl50','east'}
        
        channelPattern=get(handles.AddCurve,'string');
        channels = getChannelsFromPattern( channelPattern);
        
        set(handles.lbChannels,'Value',1);
        set(handles.lbChannels,'String',channels);%
        set(handles.lbChannels,'UserData',[]); %del UserData
        
        
    case {'hl2a', 'localdas', 'hl2m'}
        
        if isempty(MyChanLists)
            sShots=get(handles.ShotNumber,'String');
            if iscell(sShots)
                CurrentShot=str2num(sShots{get(handles.ShotNumber,'value')});
            else
                CurrentShot=str2num(sShots);
            end
            y=setSystemName(CurrentShot,1);
        end
        
        ChanLists=get(handles.lbChannels,'String');
        addcurvename=get(handles.AddCurve,'string');
        if iscell(addcurvename)
            addcurvename=addcurvename{get(handles.AddCurve,'value')};
        end
        
        if (addcurvename(1)=='@') || (addcurvename(1)=='_');%formula
            ChanLists=[ChanLists; {addcurvename}];
            set(handles.lbChannels,'String',ChanLists);
            set(handles.lbChannels,'UserData',[])
            set(handles.lbChannels,'Value',length(ChanLists));
            %     set(handles.lbChannels,'Value',1);
            lbChannels_Callback(handles.lbChannels, eventdata, handles)
        else% first string
            if ~isempty(Astring) && iscell(Astring)
                Astring(end+1)={addcurvename};  %for hint
            else
                Astring={addcurvename}
            end
            
            %%
            
            if isempty(MyChanLists)
                MyPath = which('DP');
                MyPath=[MyPath(1:end-4) 'configurations'];
                dataFile='infChannelSystem.mat';
                infChannelSystemFile=[MyPath filesep dataFile];
                fid = fopen(infChannelSystemFile,'r');
                MyChanLists = fread(fid, '*char')';
                status = fclose(fid);
            end
            % change .* to \w* for Any alphabetic, numeric, or underscore character
            addcurvename=regexprep(addcurvename,'\.','\\w');
            
            %     channelPattern=['(?<=\xD\xA)[^\x3A]*' addcurvename '[^\x3A]*(?=\x3A)'];
            %     \x3a=':'  \x5C='\'
            channelPattern=['(?<=\xD\xA)[^\x3A]*' addcurvename '[^\x3A]*\x3A[a-zA-Z0-9]{3}(?=\xD\xA)'];
            ChanLists=regexpi(MyChanLists,channelPattern,'match');
            ChanLists=regexprep(ChanLists,'\x3A','\x5C');
            
            
            %%
            
            %add the curves from GetCurveByFormula
            CurveNames=GetCurveNames;
            patternname=['.\w*',addcurvename, '.*'];
            %     sNames=cellfun(@regexpi,CurveNames,patternname,'match','once');
            
            sNames = regexpi(CurveNames, patternname, 'match','once');
            index=~cellfun(@isempty,sNames);
            Names=sNames(index);
            
            ChanLists=[ChanLists'; Names];
            
            
            
            
            set(handles.lbChannels,'String',ChanLists);
            set(handles.lbChannels,'Value',length(ChanLists));
            set(handles.lbChannels,'UserData',[]); %del UserData
            
        end
end









function ShotNumber_CreateFcn(hObject, eventdata, handles)
function ShotNumber_Callback(hObject, eventdata, handles)
uicontrol(handles.ShotOK) % get focus
% do nothing
%-----------------------------------------------------------------------
function ShotOK_Callback(hObject, eventdata, handles)
global strShotDate newServer  % for hl2a and hl2m

MyShot1=get(handles.ShotNumber,'String');
if iscell(MyShot1)
    MyShot1=MyShot1{get(handles.ShotNumber,'value')};
end

if ~isempty(str2num(MyShot1))
    CurrentShot=str2num(MyShot1);
else
    CurrentShot=MyShot1;
end
ShowDefaultChannel(CurrentShot,handles)% global MyShot
machine=getappdata(0,'machine');
switch machine
    case {'exl50','east'}
        myDateMessage = getDateTime(CurrentShot,getappdata(0,'defaultChannel'));
        ShowWarning(0,['shot ' num2str(CurrentShot) ' time stamp :' myDateMessage],handles)

        
        % sct(machine,CurrentShot)
        
        % dir_struct = dir(getDProot('Channels'));
        % [n,m]=size(dir_struct);
        % [sorted_names,sorted_index] = sortrows({dir_struct.name}');
        % Mylist={dir_struct.name};
        % set(handles.lbConfiguration,'Value',1);
        % pattern=[machine '.mat'];
        % Mylist=regexp(Mylist,pattern,'match','once');
        
        set(handles.lbConfiguration,'value',1);
        set(handles.lbConfiguration,'String',[machine '.mat']);
        setappdata(0,'clickConfigMode','chnlShow');
    case {'hl2a','localdas', 'hl2m'}
        
        isLocal=get(handles.AccessMode,'UserData');%
        % isLocal=0;
        %isLocal % 0=database automatic, 1=local, user defined,
        %'0=\\hl\2adas,1=Local short name,2=Tore Supra,', '3=Local long name,4=VEC'
        
        % prepare shot involved variable
        % set(handles.AccessMode,'UserData',isLocal);%
        set(handles.lbConfiguration,'String',[]);%clear
        
        
        
        if isLocal==1
            [sMyShot,MyPath,Mylist] = GetShotPath(CurrentShot); %,newServer);
        elseif isLocal==10
            [sMyShot,MyPath,Mylist] = GetShotPath(CurrentShot,newServer,'inftim');% long name for temp
        else
            [sMyShot,MyPath,Mylist] = GetShotPath(CurrentShot);
        end
        
        set(handles.ShotNumber,'UserData',MyPath);
        set(handles.lbConfiguration,'Value',1);
        set(handles.lbConfiguration,'String',Mylist);
        set(handles.lbChannels,'String',[]);%clear
        set(handles.lbChannels,'UserData',[]);
        
        if isempty(Mylist)
            if iscell(get(handles.ShotNumber,'String'))
                myShotNumber=get(handles.ShotNumber,'String');
                if get(handles.ShotNumber,'value')==length(get(handles.ShotNumber,'String'))
                    set(handles.ShotNumber,'value',get(handles.ShotNumber,'value')-1)
                elseif get(handles.ShotNumber,'value')==1
                    myShotNumber(1)=[];
                    set(handles.ShotNumber,'String',myShotNumber);
                end
            else
                myShotNumber=get(handles.ShotNumber,'String');
                set(handles.ShotNumber,'String',myShotNumber);
            end
        end
        ShowWarning(0,strShotDate,handles)
        
        %% for local file, no default channel to show
        if  isempty(strfind(newServer, ':'))   % windows local disk data
            ShowDefaultChannel(CurrentShot,handles)
        end
        setappdata(0,'clickConfigMode','fileShow');
        
end


%-----------------------------------------------------------------------
function ShotNumber_ButtonDownFcn(hObject, eventdata, handles)


%%------------------------------------------------------
function lbCurves_Callback(hObject, eventdata, handles)
global   PicDescription

MyCurveLists=get(handles.lbCurves,'String');
mySelectionType=get(gcf,'SelectionType');
k=get(handles.DP,'currentkey');
if strmatch(k,'f6','exact')
    if ~isempty(MyCurveLists)
        n=get(handles.lbCurves,'value');
        MyCurveList=MyCurveLists{n};
        if length(MyCurveList)>5
            % extract the shot number
            MyExtractShot=regexp(MyCurveList,'^\d*','match','once');
            
            if ~isempty(MyExtractShot)
                if isnumeric(str2double(MyExtractShot))
                    set(handles.ShotNumber,'string',MyExtractShot);
                end
            end
        end
        
        
        dlg_title = 'Modify the Channel Name';
        prompt = {'Input the Channel Name', 'replace=0, add=1,default=2,[]=3'};
        def   = {MyCurveList,'0'};
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        addmode=answer{2};
        if strmatch(addmode,'0','exact')
            MyCurveLists(n)=answer(1);
            PicDescription=[];%modify the label
            set(handles.lbCurves,'ForegroundColor','r');
        elseif strmatch(addmode,'1','exact')
            for i=length(MyCurveLists)+1:-1:n+1
                MyCurveLists(i)=MyCurveLists(i-1);
            end
            MyCurveLists(n)=answer(1);
        elseif strmatch(addmode,'2','exact')
            defaultChannel=answer{1};
            setappdata(0,'defaultChannel',defaultChannel);
        elseif strmatch(addmode,'3','exact')
            defaultChannel=[];
            setappdata(0,'defaultChannel',defaultChannel);
        end
    end
end


%clear lbChannels
if isempty(MyCurveLists)
    switch mySelectionType
        case 'normal'
            set(handles.lbChannels,'String',[]);%
        case 'extend'
        case 'alternate'
    end
else
    
    
    set(handles.lbCurves,'String',MyCurveLists);
    
    
    
end





%####################################################################33
% --- Executes on button press in ClearIt.
function ClearOne_Callback(hObject, eventdata, handles)
global PicDescription MyCurves

MyCurveList=get(handles.lbCurves,'String');%
%MyCurves=get(handles.lbCurves,'UserData');%
CurrentCurveNum=get(handles.lbCurves,'Value');%
n=length(MyCurveList);%
for i=1 : n
    if i>CurrentCurveNum
        MyCurveList(i-1)=MyCurveList(i);%one step backward
        MyCurves(i-1)=MyCurves(i);%one step backward
        if length(PicDescription)>i-1
            PicDescription(i-1)=PicDescription(i);
        end
    end
end


MyCurveList(n)=[];%clear one
if ~isempty(MyCurves)
    MyCurves(n)=[];%clear one
end

if ~isempty(PicDescription) && length(PicDescription)>=n
    PicDescription(n)=[];%clear one
end


if CurrentCurveNum==n && n>1
    set(handles.lbCurves,'Value',CurrentCurveNum-1);% 
else
    set(handles.lbCurves,'Value',CurrentCurveNum);% 
end




%set(handles.lbCurves,'UserData',MyCurves);%
set(handles.lbCurves,'String',MyCurveList);%
%###################################################################3
% function c=AddNewCurve(x,y,MyShot,CurrentChannel,Unit)
% yMax=max(y);
% yMin=min(y);
% if yMax*yMin<0
%     c.GridOnYZero=true;
% else
%     c.GridOnYZero=false;
% end
% c.x=x;
% c.y=y;
%
% c.yMax=yMax;
% c.yMin=yMin;
%
% xMax=max(x);
% xMin=min(x);
% c.xMax=xMax;
% c.xMin=xMin;
% c.Shot=MyShot;
% c.ChnlName=CurrentChannel;
% c.Unit=Unit;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in NumUp.
function NumUp_Callback(hObject, eventdata, handles)
global MyShot
MyShot=get(handles.ShotNumber,'String');

if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end

CurrentShot=str2num(MyShot);
CurrentShot=CurrentShot+1;
if iscell(get(handles.ShotNumber,'String'))
    if get(handles.ShotNumber,'value')==1
        myShotNumber=get(handles.ShotNumber,'String');
        myShotNumber(2:end+1)=myShotNumber(1:end);
        myShotNumber{1}=num2str(CurrentShot);
        set(handles.ShotNumber,'String',myShotNumber);
    else
        set(handles.ShotNumber,'value',get(handles.ShotNumber,'value')-1)
    end
else
    set(handles.ShotNumber,'String',num2str(CurrentShot));
end

ShotOK_Callback(handles.ShotNumber, eventdata, handles)

% --- Executes on button press in NumDown.
function NumDown_Callback(hObject, eventdata, handles)
MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end
CurrentShot=str2num(MyShot);
CurrentShot=CurrentShot-1;

if iscell(get(handles.ShotNumber,'String'))
    if get(handles.ShotNumber,'value')==length(get(handles.ShotNumber,'String'))
        myShotNumber=get(handles.ShotNumber,'String');
        myShotNumber{end+1}=num2str(CurrentShot);
        set(handles.ShotNumber,'String',myShotNumber);
    end
    set(handles.ShotNumber,'value',get(handles.ShotNumber,'value')+1)
else
    set(handles.ShotNumber,'String',num2str(CurrentShot));
end

ShotOK_Callback(handles.ShotNumber, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function lbConfiguration_CreateFcn(hObject, eventdata, handles)
MyPath = which('DP');
%you can change its init value
MyPath=[MyPath(1:end-4) 'configuration'];
dir_struct = dir(MyPath);
[n,m]=size(dir_struct);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');

Mylist={dir_struct.name};
set(hObject,'Value',1);
set(hObject,'String',Mylist);


function lbConfiguration_Callback(hObject, eventdata, handles)
global MyPicStruct PicDescription SubSystem bSortMode newServer hfig MyCurves moveMouseEvent

clickConfigMode=getappdata(0,'clickConfigMode');

cfglists=get(hObject,'String');
if iscell(cfglists)
    FileName=cfglists{get(hObject,'Value')};
else
    FileName=cfglists;
end

switch clickConfigMode
    case 'chnlConfig'
        cfgFile=fullfile(getDProot('configuration'),FileName);
        load(cfgFile);
        % update struct
        Struct2View(handles)
        
        MyCurveList=regexp(MyCurveList,'\w*$','match','once');
        MyCurveList=DrawConfigurationChannel(MyCurveList,handles);
        
        if ~isempty(MyCurveList)
            if iscell(MyCurveList)
                set(handles.lbCurves,'Value',length(MyCurveList));
            else
                set(handles.lbCurves,'Value',1);
            end
            set(handles.lbCurves,'String',MyCurveList);
            set(handles.lbCurves,'ForegroundColor','r');
            set(handles.UpdateShot,'Enable','on');
        end
    case 'chnlShow'   % select machine
        machinePattern='^\w*';
        machine=regexp(FileName,machinePattern,'match','once');
        setappdata(0,'machine',machine)
        
        if strcmpi(machine,'exl50')  % set currentshot
            [IpAddress,strTreeName] = getIpTree4Machine(machine);
            mdsconnect(IpAddress);
            LastestShot=mdsvalue(['current_shot("exl50")']);
            set(handles.ShotNumber,'String',num2str(LastestShot));
            mdsdisconnect
            set(handles.lbWarning,'String','machine is exl50')
        elseif strcmpi(machine,'east')  % set currentshot
            [IpAddress,strTreeName] = getIpTree4Machine(machine);
            mdsconnect(IpAddress);
            LastestShot=mdsvalue(['current_shot("pcs_east")']);
            set(handles.ShotNumber,'String',num2str(LastestShot));
            mdsdisconnect
            set(handles.lbWarning,'String','machine is east')
        end
        set(handles.lbWarning,'value',1);
        cfgFile=fullfile(getDProot('Channels'),FileName);
        load(cfgFile);
        chnlList=myChnlString;
        pattern='(?<=;)\w*(?=;)';
        cmd=['MyCurveList =regexpi(chnlList,pattern,''match'');'];
        eval(cmd)
        if ~isempty(MyCurveList)
            set(handles.lbChannels,'Value',length(MyCurveList));
            set(handles.lbChannels,'String',MyCurveList);
            set(handles.UpdateShot,'Enable','on');
        end
    case 'fileShow'   % select machine
        
        cfglists=get(hObject,'String');
        FileName=cfglists{get(hObject,'Value')};
        [m,n]=size(FileName);
        FileExt=lower(FileName(n-3:n));
        
        if length(FileName)==12
            SubSystem=FileName(6:8);
            setappdata(0,'SubSystem',SubSystem);
        end
        
        if strcmp(FileExt,'.inf')%for HL2A file
            MyPath=get(handles.ShotNumber,'UserData');
            MyFiles=get(hObject,'String');
            MyFile=MyFiles{get(hObject,'Value')};
            MyShot=MyFile(1:5);
            
            if  strmatch(MyShot(1),'0','exact')
                MyShot=MyShot(2:5);
            end
            
            if ~isempty(str2num(MyShot))
                set(handles.ShotNumber,'String',MyShot);
            end
            
            
            %set(handles.ShotNumber,'String',MyShot);%display the shot number especially for local data
            if strfind(lower(FileName),'vec.inf')%for HL2A file
                DataFlag=4;  %for vec mode
                set(handles.AccessMode,'UserData',DataFlag);%
                
                CurrentInfoFile=fullfile(MyPath,MyFile);
                [VECInfo,n]=GetVECInfoN(CurrentInfoFile);
                
                
                %      from information file to data file
                CurrentDataFile=regexprep(CurrentInfoFile, '(?<!\.)([iI][nN][fF])', 'data','preservecase');
                CurrentDataFile=regexprep(CurrentDataFile, '(\.[iI][nN][fF])', '\.dat','preservecase');
                
                if exist(CurrentDataFile)==2
                else
                    ShowWarning(0,['no data file for :' CurrentInfoFile],handles)
                    return
                end
                
                MyChannels.File=CurrentDataFile;
                MyChannels.VecInf=VECInfo;
                MyChannels.Shot=MyShot;
                set(handles.lbChannels,'UserData',MyChannels);
                MyChanList={VECInfo(1:n).ChannelName};
                set(handles.lbChannels,'String',MyChanList);
                if bSortMode==1
                    MyChanList=sort(MyChanList);
                elseif bSortMode==2
                    MyChanList=sort(lower(MyChanList));
                end
                set(handles.lbChannels,'Value',length(MyChanList));
            else
                if strfind(lower(FileName),'.inf')%for HL2A file
                    if  strfind(newServer,':')
                        DataFlag=1;  %for das mode
                        set(handles.AccessMode,'UserData',DataFlag);%
                    else
                        DataFlag=0;  %for das mode
                        set(handles.AccessMode,'UserData',DataFlag);%
                    end
                end
                
                
                CurrentInfoFile=fullfile(MyPath,MyFile);
                
                dir_struct=dir(CurrentInfoFile);
                strShotDate=[dir_struct(1).name ':' dir_struct(1).date];
                ShowWarning(0,strShotDate,handles)
                
                [DasInfo,n]=GetMyInfoN(CurrentInfoFile);%get all information
                if isempty(DasInfo) || isempty(n)
                    ShowWarning(1,[],handles)
                    return
                end
                
                %      from information file to data file
                CurrentDataFile=regexprep(CurrentInfoFile, '(?<!\.)([iI][nN][fF])', 'data','preservecase');
                CurrentDataFile=regexprep(CurrentDataFile, '(\.[iI][nN][fF])', '\.dat','preservecase');
                
                if exist(CurrentDataFile)==2
                else
                    ShowWarning(0,['no data file for :' CurrentInfoFile],handles)
                    return
                end
                
                MyChannels.File=CurrentDataFile;
                MyChannels.DasInf=DasInfo;
                MyChannels.Shot=MyShot;
                set(handles.lbChannels,'UserData',MyChannels);
                
                MyChanList=char(DasInfo(1:n).ChnlName);
                MyChanList=mat2cell(MyChanList,ones(1,size(MyChanList,1)),size(MyChanList,2));
                
                
                MyChanList=ChannelsConditionning(MyChanList);
                if bSortMode==1
                    MyChanList=sort(MyChanList);
                elseif bSortMode==2
                    MyChanList=sort(lower(MyChanList));
                end
                set(handles.lbChannels,'String',MyChanList);
                set(handles.lbChannels,'Value',length(MyChanList));
            end
            %     set(handles.AccessMode,'UserData',DataFlag);
        elseif FileName(1:2)=='Ch'
            cfgFile=fullfile(getDProot('Channels'),FileName);
            load(cfgFile);
            %     k=get(handles.DP,'currentkey');
            %     switch k
            %         case 'shift'
            hwait=waitbar(0,'please wait ...');
            
            moveMouseEvent=0;
            MyCurves=[];
            PicDescription=[];
            sShots=get(handles.ShotNumber,'String');
            if iscell(sShots)
                CurrentShot=str2num(sShots{get(handles.ShotNumber,'value')})-1;
            else
                CurrentShot=str2num(sShots)-1;
            end
            
            defaultChannel=getappdata(0,'defaultChannel');
            if isempty(defaultChannel)
                defaultChannel='IP';
                setappdata(0,'defaultChannel',defaultChannel);
            end
            [CurrentSysName, remMyChannels] = strtok(defaultChannel,'\');
            defaultChannel=strrep(remMyChannels,'\','');
            CurrentChannels=defaultChannel;
            if isempty(CurrentSysName)
                [y,x,CurrentSysName,Unit,Chs,z]=hl2adb(CurrentShot,CurrentChannels);
            else
                [y,x,CurrentSysName,Unit,Chs,z]=hl2adb(CurrentShot,CurrentChannels,CurrentSysName);
            end
            
            CurrentChannel=CurrentChannels;
            NickName=CurrentChannel;
            if   isempty(CurrentSysName)
                CurrentSysName='';
            elseif iscell(CurrentSysName)
                CurrentSysName=CurrentSysName{1};
            end
            CurrentChannelNum=1;
            sMyCurveList(CurrentChannelNum)={strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel)};
            c=AddNewCurve(x(:,1),y(:,1),num2str(CurrentShot),NickName,Unit{1},z);
            
            if isempty(MyCurves)
                MyCurves=c;  %initial
                MyCurves(CurrentChannelNum)=c;
            else
                MyCurves(CurrentChannelNum)=c;
            end
            DrawCurves_Callback(handles.DrawCurves, [], handles)
            set(hfig,'visible','off')
            loadConfiguration([], [], handles,cfgFile)
            set(hfig,'visible','on')
            waitbar(1);
            close(hwait)
            %         otherwise
            %             set(handles.lbChannels,'Value',1);
            %             MyChannels={PicDescription.ChnlName}';
            %             set(handles.lbChannels,'String',MyChannels);%
            %     end
        else
            cfgFile=fullfile(getDProot('configuration'),FileName);
            load(cfgFile);
            
            if ~isempty(MyCurveList)
                set(handles.lbCurves,'Value',length(MyCurveList));
                set(handles.lbCurves,'String',MyCurveList);
                set(handles.lbCurves,'ForegroundColor','r');
                set(handles.UpdateShot,'Enable','on');
            end
            
            %version compatible
            
            if ~isempty(MyPicStruct)
                sfield=fieldnames(MyPicStruct);
                if ~isfield(MyPicStruct, 'ColumnNumber')
                    PicStruct.ColumnNumber=1; %
                end
                
                if ~isfield(MyPicStruct, 'RowNumber')
                    PicStruct.RowNumber=1; %
                end
                
                
                MyPicStruct1=MyPicInit;%init by file data
                
                sfield1=fieldnames(MyPicStruct1);
                if length(sfield)==length(sfield1) %0320%test if there is new version code
                    %update some parameter
                    Struct2View(handles);
                else
                    MyPicStruct=MyPicStruct1;
                    PicDescription=[];
                end
            end
            
        end
end
% --------------------------------------------------------------------
function SaveChannels_Callback(hObject, eventdata, handles)
global  PicDescription
MyPath= which('DP');
MyPath= [MyPath(1:end-4) 'Channels'];

MyChannels=get(handles.lbCurves,'String');
[token, remMyChannels] = strtok(MyChannels,'\');
MyChannels=strrep(remMyChannels,'\','');



[FileName,PathName,FilterIndex]=uiputfile({'*.mat','2A channels(*.mat)'},'Save the Channels file!',strcat(MyPath,filesep,'Ch.mat'));


cfgFile=strcat(PathName,FileName);
save(cfgFile, 'MyChannels','PicDescription')
dir_struct = dir(MyPath);
[n,m]=size(dir_struct);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');

Mylist={dir_struct.name};
% --------------------------------------------------------------------
function SaveCfg_Callback(hObject, eventdata, handles)
global  MyPicStruct PicDescription HeightNumber WidthNumber
MyPath= which('DP');

MyCurveList=get(handles.lbCurves,'String');

% [FileName,PathName,FilterIndex]=uiputfile({'*.mat','2A configuration(*.mat)'},'Save the configuration file!',strcat(MyPath,'a.mat'));
cd([MyPath(1:end-4) 'configuration'])
[FileName,PathName,FilterIndex]=uiputfile('*.mat');
% [FileName,PathName,FilterIndex]=uiputfile(strcat(MyPath,'a.mat'));


cfgFile=strcat(PathName,FileName);
save(cfgFile, 'MyCurveList','MyPicStruct','PicDescription','HeightNumber','WidthNumber')
% save(cfgFile, 'MyCurveList',)
%display at the same time
% dir_struct = dir([MyPath(1:end-4) 'configuration']);
% [n,m]=size(dir_struct);
% [sorted_names,sorted_index] = sortrows({dir_struct.date}');
%
% Mylist={dir_struct.name};
% set(handles.lbConfiguration,'Value',1);
% set(handles.lbConfiguration,'String',Mylist);

cd(getDProot)
% --- Executes on button press in SaveData.
function SaveData_Callback(hObject, eventdata, handles)
global  MyPicStruct PicDescription MyCurves
MyPath= which('DP');
MyPath= [MyPath(1:end-4) 'data'];
%store 5 information
MyCurveList=get(handles.lbCurves,'String');
% MyCurves=get(handles.lbCurves,'UserData');
%we need shot information
MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end

CurrentShot=str2num(MyShot);

if ispc
    dataFile=strcat(MyPath,'\d',MyShot,'.mat');
elseif isunix
    dataFile=strcat(MyPath,'/d',MyShot,'.mat');
end

[FileName,PathName,FilterIndex]=uiputfile({'*.mat','matlab data(*.mat)'},'Save the data file!',dataFile);
dataFile=strcat(PathName,FileName);
save(dataFile, 'MyCurveList','MyCurves','PicDescription','MyPicStruct','CurrentShot')

% --------------------------------------------------------------------
function LoadData_Callback(hObject, eventdata, handles)
global MyPicStruct PicDescription
global   MyCurves

cd(getDProot('data'))
[FileName,PathName]=uigetfile('*.mat',getDProot('data'),'Load the data file');
dataFile=strcat(PathName,FileName);
load(dataFile);
cd(getDProot)

%set(handles.ShotNumber,'String',num2str(CurrentShot));
s=SetMyCurves(MyCurveList);

%version compatible

if ~isempty(MyPicStruct)
    MyPicStruct1=MyPicInit;%init by file data
    sfield=fieldnames(MyPicStruct);
    sfield1=fieldnames(MyPicStruct1);
    
    if length(sfield)==length(sfield1)
    else
        MyPicStruct=MyPicStruct1;
    end
end

Struct2View(handles);
%DrawCurves_Callback(handles.DrawCurves, eventdata, handles)

% --------------------------------------------------------------------
function Data_Callback(hObject, eventdata, handles)
function Configure_Callback(hObject, eventdata, handles)
function NextNum_CreateFcn(hObject, eventdata, handles)
function NextNum_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function NUp_Callback(hObject, eventdata, handles)
MyShot=get(handles.NextNum,'String');
CurrentShot=str2num(MyShot);
CurrentShot=CurrentShot+1;
set(handles.NextNum,'String',num2str(CurrentShot));
% --------------------------------------------------------------------
function NDown_Callback(hObject, eventdata, handles)
MyShot=get(handles.NextNum,'String');
CurrentShot=str2num(MyShot);
CurrentShot=CurrentShot-1;
set(handles.NextNum,'String',num2str(CurrentShot));

% --- Executes on button press in MoveUP.
function MoveUp_Callback(hObject, eventdata, handles)
global   MyCurves PicDescription

MyCurveList=get(handles.lbCurves,'String');
% MyCurves=get(handles.lbCurves,'UserData');
CurrentCurve=get(handles.lbCurves,'Value');
if CurrentCurve>1
    tempList=MyCurveList(CurrentCurve-1);
    tempCurve=MyCurves(CurrentCurve-1);
    MyCurveList(CurrentCurve-1)=MyCurveList(CurrentCurve);
    MyCurves(CurrentCurve-1)=MyCurves(CurrentCurve);
    MyCurveList(CurrentCurve)=tempList;
    MyCurves(CurrentCurve)=tempCurve;
    set(handles.lbCurves,'Value',CurrentCurve-1);
end
set(handles.lbCurves,'String',MyCurveList);
PicDescription=[];
% set(handles.lbCurves,'UserData',MyCurves);

% --- Executes on button press in MoveDown.
function MoveDown_Callback(hObject, eventdata, handles)
global   MyCurves PicDescription
MyCurveList=get(handles.lbCurves,'String');
% MyCurves=get(handles.lbCurves,'UserData');
CurrentCurve=get(handles.lbCurves,'Value');
[m,n]=size(MyCurves);
if CurrentCurve<n
    tempList=MyCurveList(CurrentCurve+1);
    tempCurve=MyCurves(CurrentCurve+1);
    MyCurveList(CurrentCurve+1)=MyCurveList(CurrentCurve);
    MyCurves(CurrentCurve+1)=MyCurves(CurrentCurve);
    MyCurveList(CurrentCurve)=tempList;
    MyCurves(CurrentCurve)=tempCurve;
    set(handles.lbCurves,'Value',CurrentCurve+1);
end
set(handles.lbCurves,'String',MyCurveList);
PicDescription=[];

% set(handles.lbCurves,'UserData',MyCurves);

% --------------------------------------------------------------------
function AccessSpeed_Callback(hObject, eventdata, handles)
global InterpPeriod bFullOrFast
if strmatch(get(handles.AccessSpeed,'String'),'FULL')
    bFullOrFast=0;
    set(handles.AccessSpeed,'BackgroundColor','m');
    set(handles.AccessSpeed,'String','FAST');
    set(handles.InterpPeriod,'String','nan');
    
elseif strmatch(get(handles.AccessSpeed,'String'),'FAST')
    bFullOrFast=1;
    set(handles.AccessSpeed,'BackgroundColor','g');
    set(handles.AccessSpeed,'String','FULL');
    set(handles.InterpPeriod,'String','1');
end

% --------------------------------------------------------------------
function Mode_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function DefaultXLimit_Callback(hObject, eventdata, handles)
global  MyPicStruct
if MyPicStruct.XLimitMode==0; %0=fixed limit or 1=natural limit
    MyPicStruct.XLimitMode=1;
    set(hObject,'Label','XLimitNatural')
elseif MyPicStruct.XLimitMode==1;
    MyPicStruct.XLimitMode=0;
    set(hObject,'Label','XLimitFixed')
end
%###################################################################----------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------
%%
function lbChannels_Callback(hObject, eventdata, handles)
global  MyPicStruct SmoothStatus isVIP
global MyCurves  %something wrong

MyPicStruct=View2Struct(handles);
MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end
CurrentShot=str2num(MyShot);
CurrentChannels=get(hObject,'String');
CurrentSelectNum=get(hObject,'Value');
%selectch
%get the control parameter




setappdata(0,'MyErr',[])
%%for just browse or add curve
z=[]; % [x,y,z] for compatible back
v=get(handles.tChannels,'UserData');
if isempty(v)
    set(handles.tChannels,'BackgroundColor','m');
    v=0;
elseif v==2
    return
end

try
    machine=getappdata(0,'machine');
    switch machine
        case {'exl50','east'}
            %selectch
            %get the control parameter
            %             setappdata(0,'MyErr',[])
            %             %%for just browse or add curve
            %             z=[]; % [x,y,z] for compatible back
            %             v=get(handles.tChannels,'UserData');
            dataStep=get(handles.InterpPeriod,'string');
            
            %% s is the default time unit s -> s 1/1
            if isnumeric(str2double(dataStep)) &&  str2double(dataStep)>0
                timeContext=[num2str(str2double(get(handles.xLeft,'String'))/1) ':' num2str(str2double(get(handles.xRight,'String'))/1) ':' num2str(str2double(get(handles.InterpPeriod,'String'))/1)];
            else
                %% 1000Hz is the default frequency
                timeContext=[num2str(str2double(get(handles.xLeft,'String'))/1) ':' num2str(str2double(get(handles.xRight,'String'))/1) ':nan'];
            end
            
            %             if isempty(v)
            %                 set(handles.tChannels,'BackgroundColor','m');
            %                 v=0;
            %             elseif v==2
            %                 return
            %             end
            
            %             MyPicStruct=View2Struct(handles);
            %             MyShot=get(handles.ShotNumber,'String');
            %             if iscell(MyShot)
            %                 MyShot=MyShot{get(handles.ShotNumber,'value')};
            %             end
            %             CurrentShot=str2num(MyShot);
            %
            %             CurrentChannels=get(hObject,'String');
            %             CurrentSelectNum=get(hObject,'Value');
            
            
            if isempty(CurrentChannels) %click lbChannels by chance
                return
            end
            
            CurrentChannels=deblank(CurrentChannels{CurrentSelectNum});
            CurrentChannel=CurrentChannels;
            
            ChannelIndex=0;
            
            if ~isempty(SmoothStatus)
                if SmoothStatus==1
                    CurrentChannels=strcat('@',CurrentChannels); %smooth
                elseif SmoothStatus==2
                    CurrentChannels=strcat('!',CurrentChannels); %null drift
                elseif SmoothStatus==3
                    CurrentChannels=strcat('-',CurrentChannels); %baseline
                elseif SmoothStatus==4
                    
                    delX=MyPicStruct.xright-MyPicStruct.xStep;
                    if delX>300
                        button = questdlg('ARE YOU sure FFT?','title','Yes');
                        if strcmp(button,'Yes')
                        elseif strcmp(button,'No')
                            global  bFullOrFast
                            SmoothStatus=0;
                            bFullOrFast=0;
                            set(handles.AccessSpeed,'BackgroundColor','m');
                            set(handles.AccessSpeed,'String','FAST');
                            set(handles.InterpPeriod,'String','nan');
                            set(handles.DataMode,'value',1);
                            return
                        elseif strcmp(button,'Cancel')
                            return
                        end
                    else
                    end
                    
                    
                    CurrentChannels=strcat('_',CurrentChannels); %fft
                    
                    
                end
            end
            
            
            hwait=waitbar(0,'please wait for Loading DATA...');
            [CurrentChannel,NickName,IndexStart,IndexEnd,MyIndex,CurrentSysName]=ParseChannelName(CurrentChannels);
            
            %% read east data
            %     x = mdsvalue('size(\pcpf1)');
            %     CurrentChannel='pcpf1';
            switch machine
                
                case 'exl50'
                    [y,x,Unit,z]=exl50db(CurrentShot,CurrentChannel,timeContext);
                case 'east'
                    [y,x,Unit,z]=eastdb(CurrentShot,CurrentChannel,timeContext);
            end
            
            
            %% time unit is s
            if strcmp(MyPicStruct.timeUnit,'ms')
                x=x*1000;
            elseif strcmp(MyPicStruct.timeUnit,'s')
            end
            %     [y,x,Unit,strTreeName,CurrentChannel,z]=dbs(machine,CurrentShot,CurrentChannel,timeContext);
            
            
            if length(CurrentChannel)==1
                if iscell(CurrentChannel)
                    CurrentChannel=CurrentChannel{1};
                end
            end
            if length(CurrentChannel)==1
                if iscell(CurrentChannel)
                    CurrentChannel=CurrentChannel{1};
                end
            end
            
            %     if isempty(strTreeName)
            %         ShowWarning(0,['no data for :' CurrentChannel ' in this shot'],handles)
            %         close(hwait)
            %         return
            %     end
            %
            
            
            IndexStart=1;
            IndexEnd=1;
            
            if ischar(x)
                close(hwait);
                ShowWarning(1,[],handles);
                return
            end
            [m1,n1]=size(y);
            if isempty(IndexStart)
                IndexStart=1;
            end
            if isempty(IndexEnd)
                IndexEnd=1;
            end
            if n1>1 & IndexStart==0
                IndexStart=1;
                IndexEnd=n1;
            end
            %--------------------------------------------------------------------------
            % get the curve number
            MyCurveList=get(handles.lbCurves,'String');
            if isempty(MyCurveList)
                MyCurves=[];
            end
            [m,n]=size(MyCurves);%
            CurrentChannelNum=n;
            
            
            
            CurrentSysName=[];
            
            
            
            for CurrentIndex=IndexStart:IndexEnd
                if isempty(y)
                    ShowWarning(CurrentShot,NickName,handles)
                    continue
                end
                if isempty(Unit)
                    Unit='au';
                end
                NickName=CurrentChannel;
                if IndexStart==IndexEnd
                    if CurrentChannel(1)=='$'
                        nMyCurveList=strcat('00000',CurrentSysName,'\',CurrentChannel);
                    else
                        nMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel);
                    end
                    %if lower(CurrentChannel(1:2))=='da'
                    %c=AddNewCurve(x(:,1),y(:,MyIndex),num2str(CurrentShot),NickName,Unit);
                    %else
                    %c=AddNewCurve(x(:,1),y(:,1),num2str(CurrentShot),NickName,Unit);
                    %end
                    if lower(CurrentChannel(1))=='d'
                        c=AddNewCurve(x(:,1),y(:,MyIndex),num2str(CurrentShot),NickName,Unit,z);
                    else
                        c=AddNewCurve(x(:,1),y(:,1),num2str(CurrentShot),NickName,Unit,z);
                    end
                else %more channels
                    
                    if length(CurrentChannels)>1
                        CurrentChannel=CurrentChannels(CurrentIndex);
                    else
                        CurrentChannel=CurrentChannels;
                    end
                    
                    if iscell(CurrentChannel)
                        CurrentChannel=CurrentChannel{1};
                    end
                    
                    if CurrentChannel(1)=='$'
                        nMyCurveList=strcat('00000',CurrentSysName,'\',CurrentChannel);
                    else
                        nMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel);
                    end
                    
                    if length(Unit)>1
                        currentUnit=Unit(CurrentIndex);
                    else
                        currentUnit=Unit;
                    end
                    
                    %             if iscell(currentUnit)
                    %                 currentUnit=currentUnit{1};
                    %             end
                    %             c=AddNewCurve(x(:,1),y(:,CurrentIndex),num2str(CurrentShot),strcat(CurrentChannel,'%',num2str(CurrentIndex)),currentUnit);
                    c=AddNewCurve(x(:,1),y(:,CurrentIndex),num2str(CurrentShot),CurrentChannel,currentUnit,z);
                end
                
                CurrentChannelNum=CurrentChannelNum+1;
                
                if v==1 %for add curve
                    if CurrentChannelNum>1
                        if ~isempty(MyCurveList)
                            MyCurves(CurrentChannelNum)=c;
                            MyCurveList(CurrentChannelNum)={nMyCurveList};
                        end
                    else
                        MyCurves=c;
                        MyCurveList={nMyCurveList};
                    end
                end
                
                waitbar((CurrentIndex-IndexStart+0.5)/(IndexEnd-IndexStart+1));
            end%CurrentIndex
            close(hwait)
            
            
            
            %%
            
            if v==1 %for just browse or add curve
                %PicDescription=[];%init
                s=SetMyCurves(MyCurveList);
                set(handles.tChannels,'BackgroundColor','g');
            else
                set(handles.tChannels,'BackgroundColor','m');
            end
            %%
            
            
            if isempty(x) || isempty(y)
                return
            end
            
            
            
            
            if ~isempty(z)
                %         axes(handles.aBrowser)
                %         cla(handles.aBrowser,'reset')
                %         image(x,y,z)
                %         set(handles.aBrowser,'YDir','normal')
                %         lBrowser1=pcolor(handles.aBrowser,'XData',x,'YData',y,'ZData',z);%shading (handles.aBrowser,'interp');
                %         set(handles.aBrowser,'XLim',[min(x) max(x)]);
                %         set(handles.aBrowser,'YLim',[min(y) max(y)]);
            else
                lBrowser=plot(handles.aBrowser,x,y,'Color','b');
                setappdata(handles.aBrowser,'lBrowser',lBrowser)
                
                set(handles.aBrowser,'XColor','g','YColor','g','XGrid','on','YGrid','on');
                set(handles.aBrowser,'XLim',[min(x) max(x)]);
                
                if c.yMax==1 && c.yMin==0
                    set(handles.aBrowser,'YLim',[-0.25 1.25]);
                end
                
                
                
                %     setappdata(0,'t',x)
                %     setappdata(0,'y',y)
                %     setappdata(0,'name',CurrentChannel)
                r1=GetMyPower(max(x)-min(x));
                pr=realpow(10,r1);
                myxLeft=floor(min(x)/pr)*pr;
                myxRight=ceil(max(x)/pr)*pr;
                myxStep=floor((max(x)-min(x))/pr)*pr/5;
                
                set(handles.aBrowser,'XTick',[myxLeft:myxStep:myxRight],'TickDir', 'in','XTickLabelMode','auto');
                if MyPicStruct.YLimitAuto==0;
                    global Ylimit4Browser
                    if isempty(Ylimit4Browser)
                        Ylimit4Browser=[-6,6];
                    end
                    set(handles.aBrowser,'YLim',Ylimit4Browser)
                    %        MyYTick(handles.aBrowser,MyPicStruct.YTickNum,r1);% r is the power
                else
                    %         MyYTick(handles.aBrowser,MyPicStruct.YTickNum,r1);% r is the power
                end
                myYLim=get(handles.aBrowser,'YLim');
                setappdata(handles.aBrowser,'myYLim',myYLim)
                myXLim=get(handles.aBrowser,'XLim');
                setappdata(handles.aBrowser,'myXLim',myXLim)
                myFun=get(handles.aBrowser,'ButtonDownFcn');
                if isempty(myFun)
                    set(handles.aBrowser,'ButtonDownFcn',{@myButtonDownFcn,handles});
                end
            end
        otherwise
            %get the control parameter
            %%for just browse or add curve
            %             z=[]; % for compatible back
            %             v=get(handles.tChannels,'UserData');
            %             if isempty(v)
            %                 set(handles.tChannels,'BackgroundColor','m');
            %                 v=0;
            %             elseif v==2
            %                 return
            %             end
            %             MyPicStruct=View2Struct(handles);
            %             MyShot=get(handles.ShotNumber,'String');
            %             if iscell(MyShot)
            %                 MyShot=MyShot{get(handles.ShotNumber,'value')};
            %             end
            %             CurrentShot=str2num(MyShot);
            %
            %             CurrentChannels=get(hObject,'String');
            %             CurrentSelectNum=get(hObject,'Value');
            
            
            if isempty(CurrentChannels) %click lbChannels by chance
                return
            end
            
            CurrentChannels=deblank(CurrentChannels{CurrentSelectNum});
            CurrentChannel=CurrentChannels;
            
            ChannelIndex=0;
            
            MyChannels=get(handles.lbChannels,'UserData');
            
            if ~isempty(MyChannels) && isfield(MyChannels,'DasInf')
                CurrentDasInfs=MyChannels.DasInf;
                ChannelNums=length(CurrentDasInfs);
                MyChanList=char(CurrentDasInfs(1:ChannelNums).ChnlName);
                MyChanList=mat2cell(MyChanList,ones(1,size(MyChanList,1)),size(MyChanList,2));
                MyChanList=ChannelsConditionning(MyChanList);
                
                
                set(hObject,'String',MyChanList)
                MyChanList=get(hObject,'String');
                
                CurrentChannel=deblank(CurrentChannel);
                %     ChannelIndex = strmatch(CurrentChannel,MyChanList,'exact');
                ChannelIndex = strmatch(CurrentChannel,MyChanList,'exact');
                
            elseif  ~isempty(MyChannels) && isfield(MyChannels,'VecInf')
                CurrentInfs=MyChannels.VecInf;
                ChannelNums=length(CurrentInfs);
                MyChanList(1:ChannelNums,1)={CurrentInfs(1:ChannelNums).ChannelName};
                CurrentChannel=deblank(CurrentChannel);
                ChannelIndex = strmatch(CurrentChannel,MyChanList,'exact');
            end
            
            
            k=get(handles.DP,'currentkey');
            if ~strcmp(k,'shift')
                channelInformation=[];
                DataFlag=GetDataFlag(handles);
                
                if ~isempty(SmoothStatus)
                    if SmoothStatus==1
                        CurrentChannels=strcat('@',CurrentChannels); %smooth
                    elseif SmoothStatus==2
                        CurrentChannels=strcat('!',CurrentChannels); %null drift
                    elseif SmoothStatus==3
                        CurrentChannels=strcat('-',CurrentChannels); %baseline
                    elseif SmoothStatus==4
                        
                        delX=MyPicStruct.xright-MyPicStruct.xStep;
                        if delX>300
                            button = questdlg('ARE YOU sure FFT?','title','Yes');
                            if strcmp(button,'Yes')
                            elseif strcmp(button,'No')
                                global  bFullOrFast
                                SmoothStatus=0;
                                bFullOrFast=0;
                                set(handles.AccessSpeed,'BackgroundColor','m');
                                set(handles.AccessSpeed,'String','FAST');
                                set(handles.InterpPeriod,'String','nan');
                                set(handles.DataMode,'value',1);
                                return
                            elseif strcmp(button,'Cancel')
                                return
                            end
                        else
                        end
                        
                        
                        CurrentChannels=strcat('_',CurrentChannels); %fft
                        
                        
                    end
                end
                
                
                
                %     MyCurveList=get(handles.lbCurves,'String');
                %     if isempty(MyCurveList)
                %         MyCurves=[];
                %     end
                %     [m,n]=size(MyCurves);%
                %     CurrentChannelNum=n;
                CurrentSysName='';
                
                hwait=waitbar(0,'please wait for Loading DATA...');
                [CurrentChannel,NickName,IndexStart,IndexEnd,MyIndex,CurrentSysName]=ParseChannelName(CurrentChannels);
                switch DataFlag
                    case 0
                        if ChannelIndex
                            CurrentDataFile=MyChannels.File;%for if statement
                            CurrentDasInf=CurrentDasInfs(ChannelIndex);
                            [y,x,CurrentSysName,Unit,CurrentChannels,z]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag,CurrentDataFile,CurrentDasInf);
                            
                            iStep = 1000 / CurrentDasInf.Freq;
                            iStartTime=CurrentDasInf.Dly+(CurrentDasInf.Post-CurrentDasInf.Len)*iStep;
                            iEnd=iStartTime+iStep*(CurrentDasInf.Len-1);
                            
                            
                            
                            
                            %                 channelInformation={[deblank(CurrentDasInf.ChnlName) ': Freq=' num2str(CurrentDasInf.Freq) ', MaxDat=' num2str(CurrentDasInf.MaxDat) ', factor=' num2str(CurrentDasInf.Factor) ], ...
                            %                     ['    L/H=' num2str(CurrentDasInf.LowRang) '/' num2str(CurrentDasInf.HighRang) ', t=' num2str(iStartTime) '/' num2str(iEnd) ', AttribDt=' num2str(CurrentDasInf.AttribDt) ', DatWth=' num2str(CurrentDasInf.DatWth)]};
                            channelInformation={[deblank(CurrentDasInf.ChnlName) ': Freq=' num2str(CurrentDasInf.Freq) ]};
                        else
                            if ~isempty(CurrentSysName) && length(CurrentSysName)==3
                                [y,x,CurrentSysName,Unit,CurrentChannels,z]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag,[],[],CurrentSysName);
                            else
                                [y,x,CurrentSysName,Unit,CurrentChannels,z]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag);%for more channels
                            end
                        end
                    case {1,5}%local data
                        MyChannels=get(handles.lbChannels,'UserData');
                        CurrentDataFile=MyChannels.File;
                        [pathstr,CurrentSysName,ext] = fileparts(CurrentDataFile);
                        if length(CurrentSysName)==8
                            CurrentSysName=CurrentSysName(6:8);
                        end
                        CurrentDasInfs=MyChannels.DasInf;
                        CurrentDasInf=CurrentDasInfs(CurrentSelectNum);
                        %shotcut for curve
                        
                        
                        %             [x,y]=GetMyCurveN(CurrentDataFile,CurrentDasInf);%pay attention to the order of x, y
                        %             Unit=CurrentDasInf.Unit;
                        
                        [y,x,CurrentSysName,Unit]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag,CurrentDataFile,CurrentDasInf);
                        
                    case 2
                        [y,x]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag);
                    case 3
                        MyChannels=get(handles.lbChannels,'UserData');
                        CurrentDataFile=MyChannels.File;
                        [pathstr,CurrentSysName,ext] = fileparts(CurrentDataFile);
                        if length(CurrentSysName)>8
                            CurrentSysName=CurrentSysName(9:12);
                        end
                        CurrentDasInfs=MyChannels.DasInf;
                        CurrentDasInf=CurrentDasInfs(CurrentSelectNum);
                        %shotcut for curve
                        [x,y]=GetMyCurveN(CurrentDataFile,CurrentDasInf);%pay attention to the order of x, y
                        Unit=CurrentDasInf.Unit;
                    case 4%for VEC curve
                        %[y,x,CurrentSysName,Unit]=GetCurveFromVector(CurrentShot,CurrentChannel);
                        MyChannels=get(handles.lbChannels,'UserData');
                        if isempty(MyChannels)
                            return
                        end
                        CurrentDataFile=MyChannels.File;
                        [pathstr,CurrentSysName,ext] = fileparts(CurrentDataFile);
                        if length(CurrentSysName)==8
                            CurrentSysName=CurrentSysName(6:8);
                        end
                        CurrentVecInfs=MyChannels.VecInf;
                        CurrentVecInf=CurrentVecInfs(CurrentSelectNum);
                        [y,x,CurrentSysName,Unit]=hl2avec(CurrentShot,CurrentChannel,CurrentDataFile,CurrentVecInf);
                end
                
                %% here time unit is ms
                if strcmp(MyPicStruct.timeUnit,'ms')
                elseif strcmp(MyPicStruct.timeUnit,'s')
                    x=x/1000;
                end
                
                if size(x,2)>1
                    close(hwait);
                    return
                end
                [m1,n1]=size(y);
                if isempty(IndexStart)
                    IndexStart=1;
                end
                if isempty(IndexEnd)
                    IndexEnd=1;
                end
                if n1>1 & IndexStart==0
                    IndexStart=1;
                    IndexEnd=n1;
                end
                %--------------------------------------------------------------------------
                % get the curve number
                MyCurveList=get(handles.lbCurves,'String');
                if isempty(MyCurveList)
                    MyCurves=[];
                end
                [m,n]=size(MyCurves);%
                CurrentChannelNum=n;
                
                %     if strcmp(CurrentChannel(1),'_')
                %         CurrentChannel=CurrentChannel(2:end);
                %     end
                
                for CurrentIndex=IndexStart:IndexEnd
                    if isempty(y)
                        ShowWarning(CurrentShot,NickName,handles)
                        continue
                    end
                    if isempty(Unit)
                        Unit='au';
                    end
                    NickName=CurrentChannel;
                    if IndexStart==IndexEnd
                        if CurrentChannel(1)=='$'
                            nMyCurveList=strcat('00000',CurrentSysName,'\',CurrentChannel);
                        else
                            nMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel);
                        end
                        %if lower(CurrentChannel(1:2))=='da'
                        %c=AddNewCurve(x(:,1),y(:,MyIndex),num2str(CurrentShot),NickName,Unit);
                        %else
                        %c=AddNewCurve(x(:,1),y(:,1),num2str(CurrentShot),NickName,Unit);
                        %end
                        if lower(CurrentChannel(1))=='d'
                            c=AddNewCurve(x(:,1),y(:,MyIndex),num2str(CurrentShot),NickName,Unit,z);
                        else
                            c=AddNewCurve(x(:,1),y(:,1),num2str(CurrentShot),NickName,Unit,z);
                        end
                    else %more channels
                        
                        if length(CurrentChannels)>1
                            CurrentChannel=CurrentChannels(CurrentIndex);
                        else
                            CurrentChannel=CurrentChannels;
                        end
                        
                        if iscell(CurrentChannel)
                            CurrentChannel=CurrentChannel{1};
                        end
                        
                        if CurrentChannel(1)=='$'
                            nMyCurveList=strcat('00000',CurrentSysName,'\',CurrentChannel);
                        else
                            nMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel);
                        end
                        
                        if length(Unit)>1
                            currentUnit=Unit(CurrentIndex);
                        else
                            currentUnit=Unit;
                        end
                        
                        %             if iscell(currentUnit)
                        %                 currentUnit=currentUnit{1};
                        %             end
                        %             c=AddNewCurve(x(:,1),y(:,CurrentIndex),num2str(CurrentShot),strcat(CurrentChannel,'%',num2str(CurrentIndex)),currentUnit);
                        c=AddNewCurve(x(:,1),y(:,CurrentIndex),num2str(CurrentShot),CurrentChannel,currentUnit,z);
                    end
                    
                    CurrentChannelNum=CurrentChannelNum+1;
                    if iscell(nMyCurveList)
                        nMyCurveList=nMyCurveList{1};
                    end
                    if v==1 %for add curve
                        if CurrentChannelNum>1
                            if ~isempty(MyCurveList)
                                MyCurves(CurrentChannelNum)=c;
                                MyCurveList(CurrentChannelNum)={nMyCurveList};
                            end
                        else
                            MyCurves=c;
                            MyCurveList={nMyCurveList};
                        end
                    end
                    
                    waitbar((CurrentIndex-IndexStart+0.5)/(IndexEnd-IndexStart+1));
                end%CurrentIndex
                close(hwait)
                
                
                
                %%
                
                if v==1 %for just browse or add curve
                    %PicDescription=[];%init
                    s=SetMyCurves(MyCurveList);
                    set(handles.tChannels,'BackgroundColor','g');
                else
                    set(handles.tChannels,'BackgroundColor','m');
                end
                %%
                
                
                if length(x)<2
                    return
                end
                
                
                
                
                if ~isempty(z)
                    %         axes(handles.aBrowser)
                    %         cla(handles.aBrowser,'reset')
                    %         image(x,y,z)
                    %         set(handles.aBrowser,'YDir','normal')
                    %         lBrowser1=pcolor(handles.aBrowser,'XData',x,'YData',y,'ZData',z);%shading (handles.aBrowser,'interp');
                    %         set(handles.aBrowser,'XLim',[min(x) max(x)]);
                    %         set(handles.aBrowser,'YLim',[min(y) max(y)]);
                else
                    lBrowser=plot(handles.aBrowser,x,y,'Color','b');
                    setappdata(handles.aBrowser,'lBrowser',lBrowser)
                    
                    set(handles.aBrowser,'XColor','g','YColor','g','XGrid','on','YGrid','on');
                    set(handles.aBrowser,'XLim',[min(x) max(x)]);
                    
                    if c.yMax==1 && c.yMin==0
                        set(handles.aBrowser,'YLim',[-0.25 1.25]);
                    end
                    
                    
                    
                    %     setappdata(0,'t',x)
                    %     setappdata(0,'y',y)
                    %     setappdata(0,'name',CurrentChannel)
                    r1=GetMyPower(max(x)-min(x));
                    pr=realpow(10,r1);
                    myxLeft=floor(min(x)/pr)*pr;
                    myxRight=ceil(max(x)/pr)*pr;
                    myxStep=floor((max(x)-min(x))/pr)*pr/5;
                    
                    set(handles.aBrowser,'XTick',[myxLeft:myxStep:myxRight],'TickDir', 'in','XTickLabelMode','auto');
                    if MyPicStruct.YLimitAuto==0;
                        global Ylimit4Browser
                        if isempty(Ylimit4Browser)
                            Ylimit4Browser=[-6,6];
                        end
                        set(handles.aBrowser,'YLim',Ylimit4Browser)
                        %        MyYTick(handles.aBrowser,MyPicStruct.YTickNum,r1);% r is the power
                    else
                        %         MyYTick(handles.aBrowser,MyPicStruct.YTickNum,r1);% r is the power
                    end
                    myYLim=get(handles.aBrowser,'YLim');
                    setappdata(handles.aBrowser,'myYLim',myYLim)
                    myXLim=get(handles.aBrowser,'XLim');
                    setappdata(handles.aBrowser,'myXLim',myXLim)
                    myFun=get(handles.aBrowser,'ButtonDownFcn');
                    if isempty(myFun)
                        set(handles.aBrowser,'ButtonDownFcn',{@myButtonDownFcn,handles});
                    end
                end
                ShowWarning(0,channelInformation,handles)
                
            else %~strcmp(k,'shift')
                %display the channel information
                hInformation=figure('MenuBar','none','Tag','Information','Resize','off','HitTest','off');%,...
                %'KeyPressFcn',{@myKeyFunction,UD},...
                %'Resize', 'off','WindowButtonUpFcn',{@myButtonUp,UD});
                scrsz = get(0,'ScreenSize');
                scrsz=[10 40 (scrsz(3)-scrsz(1))*0.8 scrsz(4)-30];
                scrsz=scrsz*0.95;
                set(hInformation,'Units','pixels','Position',scrsz);
                Rows=1;
                Cols=4;
                wstep=scrsz(3)/Cols;
                hstep=scrsz(4)/Rows;
                w=wstep/2;
                h=0.6*(scrsz(4));
                b=scrsz(2)-26;
                l=6;
                FontSize=16;
                
                InfName = uicontrol('parent',                   hInformation,...
                    'Units',                    'points', ...
                    'String',                  'OK', ...
                    'Position',                 [l,b,w,h],...
                    'HorizontalAlignment',      'left', ...
                    'FontWeight',               'bold', ...
                    'FontSize',                 FontSize,...
                    'Style',                    'listbox', ...
                    'Enable',                   'on', ...
                    'callback',                 {@myInformation,hInformation},...
                    'Tooltipstring',            'channels OK');
                l=l+w;
                w=1.3*w;
                InfValue = uicontrol('parent',                   hInformation,...
                    'Units',                    'points', ...
                    'String',                  'OK', ...
                    'Position',                 [l,b,w,h],...
                    'HorizontalAlignment',      'left', ...
                    'FontWeight',               'bold', ...
                    'FontSize',                 FontSize,...
                    'Style',                    'listbox', ...
                    'Enable',                   'on', ...
                    'callback',                 {@myInformation,hInformation},...
                    'Tooltipstring',            'channels OK');
                l=l+w;
                InfHelp = uicontrol('parent',                   hInformation,...
                    'Units',                    'points', ...
                    'String',                  'OK', ...
                    'Position',                 [l,b,w*3.4,h],...
                    'HorizontalAlignment',      'left', ...
                    'FontWeight',               'bold', ...
                    'FontSize',                 FontSize,...
                    'Style',                    'listbox', ...
                    'Enable',                   'on', ...
                    'callback',                 {@myInformation,hInformation},...
                    'Tooltipstring',            'channels OK');
                
                MyChannels=get(handles.lbChannels,'UserData');
                if ~isempty(MyChannels) && isfield(MyChannels,'DasInf')
                    CurrentInfs=MyChannels.DasInf;
                    myHelp=SetMyInfoHelp;
                    myHelp=reshape(myHelp,length(myHelp),1);
                elseif isfield(MyChannels,'VecInf')
                    CurrentInfs=MyChannels.VecInf;
                end
                
                if ChannelIndex
                else
                    [CurrentChannel,NickName,IndexStart,IndexEnd,MyIndex,CurrentSysName]=ParseChannelName(CurrentChannels);
                    [sMyShot,MyPath,MyFiles] = GetShotPath(CurrentShot);
                    [m,filenumber]=size(MyFiles);
                    
                    if length(CurrentSysName)==3
                        MyFile=MyFiles{1};
                        if length(MyFile)>8
                            s=MyFile(6:8);
                            MyFile=strrep(MyFile,s,CurrentSysName);%the prefered filename
                            %special for multiple channels
                            [CurrentInfoFile,ChannelIndex,CurrentInfs]=GetChannelIndex(MyPath,MyFile,CurrentChannel);
                        end %channel found or return
                    end%length(MyFile)>8
                end%length(CurrentSysName)==3
                
                if ChannelIndex
                else
                    for i=1:filenumber
                        MyChanList=[];
                        MyFile=MyFiles{i};
                        %             if strcmpi(MyFile(6:8),'vec')
                        %                 break
                        %             end
                        [CurrentInfoFile,ChannelIndex,CurrentInfs]=GetChannelIndex(MyPath,MyFile,CurrentChannel);
                        if ChannelIndex
                            break;
                        end
                    end%for i=1:filenumber
                end
                
                if ChannelIndex
                    %display the channel information
                    CurrentInf=CurrentInfs(ChannelIndex);
                    names = fieldnames(CurrentInf);
                    
                    myValues = struct2cell(CurrentInf);
                    
                    %         n=length(names);
                    %         myValues(1:n)={''};
                    %         for i=1:n
                    %             myValue = getfield(CurrentInf,names{i});
                    %             if isnumeric(myValue)
                    %                 myValues(i)={num2str(myValue)};
                    %             else
                    %                 myValues(i)={myValue};
                    %             end
                    %         end
                    if isempty(isVIP)
                        isVIP=1;
                    end
                    
                    if isVIP && ispc
                        conn = myloginconnect('hl');
                        if isempty(conn.Message)
                            
                            FieldNames={'通道定义编号';'通道名称';'任务编号';'通道说明';'系数因子';'信号偏移量';'物理单位';'处理公式';'选点方式';'图形方式';'外部处理';'限幅下限';'限幅上限';'时区模式';'备用文本字段';'通道级别';'通道类别';'管理者';'通道分组';'临时'};
                            DBNames={'实验数据_中控参数';'实验数据';'通道定义'};
                            myFields=FieldNames{4};%通道说明
                            DBName=DBNames{3};%通道定义
                            
                            strCondition=[FieldNames{1} '=' num2str(myValues{2})];
                            
                            
                            
                            querystr=['SELECT ALL ' myFields ' FROM ' DBName ' WHERE ' strCondition];
                            conn = myloginconnect('hl');
                            curs = exec(conn,querystr);
                            curs = fetch(curs);
                            ansf = curs.Data;
                            close(conn)
                            if ~isempty(ansf)
                                myComment=ansf{1};
                                if length(myComment)>16
                                    myComment=myComment(1:16);
                                end
                                if ~isempty(myComment) && ~strcmp(myComment, 'NO Data')
                                    if ~isempty(MyChannels) && isfield(MyChannels,'DasInf')
                                        myHelp{length(myHelp)-1}=myComment;%通锟斤拷说锟斤拷
                                    end
                                    
                                end
                            end
                        end
                    end
                    
                    
                    
                    
                    set(InfName,'string',names);
                    set(InfValue,'string',myValues);
                    set(hInformation,'Name',['Information of Channel ' myValues{3}]);
                    if exist('myHelp','var');
                        set(InfHelp,'string',myHelp);
                    end
                    
                else
                    return
                end
            end %~strcmp(k,'shift')
            if ~isempty(getappdata(0,'MyErr'))
                ShowWarning(1,[],handles);
            end
            %%
            %CPSD
            hCPSD=getappdata(0,'hCPSD');
            if ~isempty(hCPSD)
                switch hCPSD.curveNum
                    case 0
                        hCPSD.data1=y;
                        hCPSD.t1=x;
                        hCPSD.name1=CurrentChannel;
                        hCPSD.curveNum=1;
                        ShowWarning(0,'first curve has been loaded!',handles)
                        setappdata(0,'hCPSD',hCPSD);
                    case 1
                        hCPSD.data2=y;
                        hCPSD.t2=x;
                        hCPSD.name2=CurrentChannel;
                        ShowWarning(0,'two curves have been loaded!',handles)
                        setappdata(0,'hCPSD',hCPSD);
                        uiresume(handles.DP)
                        return
                end
            end
            %%
            
            %%
            %TENE3
            hTENE3=getappdata(0,'hTENE3');
            if ~isempty(hTENE3)
                switch hTENE3.curveNum
                    case 0
                        hTENE3.data1=y;
                        hTENE3.t1=x;
                        hTENE3.name1=CurrentChannel;
                        hTENE3.curveNum=1;
                        ShowWarning(0,'first curve has been loaded!',handles)
                        setappdata(0,'hTENE3',hTENE3);
                    case 1
                        hTENE3.data2=y;
                        hTENE3.t2=x;
                        hTENE3.name2=CurrentChannel;
                        hTENE3.curveNum=2;
                        ShowWarning(0,'second curve has been loaded!',handles)
                        setappdata(0,'hTENE3',hTENE3);
                    case 2
                        hTENE3.data3=y;
                        hTENE3.t3=x;
                        hTENE3.name3=CurrentChannel;
                        ShowWarning(0,'three curves have been loaded!',handles)
                        setappdata(0,'hTENE3',hTENE3);
                        uiresume(handles.DP)
                        return
                end
            end
            %%
            %%
            %TENE4
            hTENE4=getappdata(0,'hTENE4');
            if ~isempty(hTENE4)
                switch hTENE4.curveNum
                    case 0
                        hTENE4.data1=y;
                        hTENE4.t1=x;
                        hTENE4.name1=CurrentChannel;
                        hTENE4.curveNum=1;
                        ShowWarning(0,'first curve has been loaded!',handles)
                        setappdata(0,'hTENE4',hTENE4);
                    case 1
                        hTENE4.data2=y;
                        hTENE4.t2=x;
                        hTENE4.name2=CurrentChannel;
                        hTENE4.curveNum=2;
                        ShowWarning(0,'second curve has been loaded!',handles)
                        setappdata(0,'hTENE4',hTENE4);
                    case 2
                        hTENE4.data3=y;
                        hTENE4.t3=x;
                        hTENE4.name3=CurrentChannel;
                        hTENE4.curveNum=3;
                        ShowWarning(0,'third curve has been loaded!',handles)
                        setappdata(0,'hTENE4',hTENE4);
                    case 3
                        hTENE4.data4=y;
                        hTENE4.t4=x;
                        hTENE4.name4=CurrentChannel;
                        ShowWarning(0,'four curves have been loaded!',handles)
                        setappdata(0,'hTENE4',hTENE4);
                        uiresume(handles.DP)
                        return
                end
            end
            
    end
catch
end
ShowWarning(1,[],handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ShotTogether_Callback(hObject, eventdata, handles)
global  MyPicStruct PicDescription MyCurves NumShot
%get the control parameter


machine=getappdata(0,'machine');
switch machine
    case {'exl50','east'}
        
        NumShot=1;%initialize
        DataFlag=GetDataFlag(handles);
        MyShot=get(handles.ShotNumber,'String');
        if iscell(MyShot)
            MyShot=MyShot{get(handles.ShotNumber,'value')};
        end
        
        nCurrentShot=str2num(MyShot);
        
        nMyCurveList=get(handles.lbCurves,'String');%for circulating use
        MyCurveList=get(handles.lbCurves,'String');
        % MyCurves=get(handles.lbCurves,'UserData');%
        [m,n]=size(MyCurves);%
        CurrentChannelNum=n;  %the
        %CurrentSysName='';
        
        
        
        
        dlg_title = 'Input total number of shots';
        prompt = {'Input total number of shots'};
        def   = {'1'};
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        sMyNum=answer{1};
        
        MyNum=str2num(sMyNum);
        if MyNum==0
            return
        elseif MyNum==1
            
            CurrentChannel=nMyCurveList{1};
            patternname='\w*$';
            CurrentChannel = regexpi(CurrentChannel, patternname, 'match','once');
            
            CurrentChannels=nMyCurveList;
            patternname='\w*$';
            CurrentChannels = regexpi(CurrentChannels, patternname, 'match','once');
            tf=strcmp(CurrentChannels,CurrentChannel);
            % nn=~cellfun('isempty',index);
            NumShot=sum(tf);
            n=n/NumShot;
            %     CurrentChannelNum=n;
        else
        end
        
        
        
        
        
        MyStep=MyNum/abs(MyNum);
        if n==0
            return;
        elseif n>5
            str=strcat('are you sure you will go');
            answer=inputdlg({str},'Make Sure',1,{'Yes'});
            if answer{1}=='Yes'
            else
                return
            end
        end
        
        machine=getappdata(0,'machine');
        [server,~] = getIpTree4Machine(machine);
        
        CurrentChannel=regexp(MyCurveList{1},'\w*$','match','once');
        
        strTreeName=getTreeName(machine,CurrentChannel); %
        
        strTreeName=strTreeName{1}; %
        
        % strTreeName='exl50'; %
        dataStep=get(handles.InterpPeriod,'string');
        
        %% s is the default time unit s -> s 1/1
        if isnumeric(str2double(dataStep)) &&  str2double(dataStep)>0
            timeContext=[num2str(str2double(get(handles.xLeft,'String'))/1) ':' num2str(str2double(get(handles.xRight,'String'))/1) ':' num2str(str2double(get(handles.InterpPeriod,'String'))/1)];
        else
            %% 1000Hz is the default frequency
            timeContext=[num2str(str2double(get(handles.xLeft,'String'))/1) ':' num2str(str2double(get(handles.xRight,'String'))/1) ':nan'];
        end
        
        hwait=waitbar(0,'please wait ...');
        
        for CurrentShot=nCurrentShot:MyStep:nCurrentShot+MyNum-MyStep%positive or negative
            initServerTree(server,strTreeName,CurrentShot)
            for i=1:n;
                
                
                CurrentChannel=nMyCurveList{i};
                patternname='\w*$';
                CurrentChannel = regexpi(CurrentChannel, patternname, 'match','once');
                
                [y,x,Unit]=db(channelTransfer(CurrentChannel),timeContext);
                z=[];
                
                if strcmp(MyPicStruct.timeUnit,'ms')
                    x=x*1000;
                elseif strcmp(MyPicStruct.timeUnit,'s')
                end
                
                NickName=CurrentChannel;
                
                
                %     CurrentChannels=nMyCurveList{i};
                %     j=strfind(CurrentChannels,'\');
                %     L=size(CurrentChannels,2);
                %     CurrentSysName=CurrentChannels(j-3:j-1);
                %     CurrentChannels=CurrentChannels(j+1:L);
                %
                %
                %
                %     [CurrentChannel,NickName,IndexStart,IndexEnd,MyIndex,CurrentSysName1]=ParseChannelName(CurrentChannels);
                %     if DataFlag==0
                %         [y,x,CurrentSysName,Unit]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag,'','',CurrentSysName);
                %     else
                %         [y,x]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag,'','',CurrentSysName);
                %     end
                %
                %
                
                
                
                if isempty(y)
                    if isempty(y)
                        x=0;
                        y=0;
                        ShowWarning(CurrentShot,NickName,handles)
                        %continue
                    end
                end
                
                
                
                
                CurrentChannelNum=CurrentChannelNum+1;
                tMyCurveList=strcat(num2str(CurrentShot),'\',CurrentChannel); %temporary variable
                if isempty(Unit)
                    Unit='au';
                end
                c=AddNewCurve(x,y,num2str(CurrentShot),NickName,Unit);
                
                if CurrentChannelNum>1
                    MyCurves(CurrentChannelNum)=c;
                    MyCurveList(CurrentChannelNum)={tMyCurveList};
                else
                    MyCurves=c;
                    MyCurveList={tMyCurveList};
                end
                
                waitbar((abs(CurrentShot-nCurrentShot)*n+i)/abs(n*MyNum));
            end%i=1:n
            %% close and disconnect
            initServerTree;
            
        end%iShot
        
        close(hwait)
        
        
        
        PicDescription=[];
        s=SetMyCurves(MyCurveList);
        %set(handles.ShotNumber,'String',num2str(CurrentShot));
        if isempty(MyPicStruct)
            MyPicStruct=MyPicInit;%init by file data
        end
        
        if abs(MyNum)==1
            if NumShot==1
                MyPicStruct.LayoutMode=4;
            else
                MyPicStruct.LayoutMode=10;
            end
        end
        if abs(MyNum)>1 && n==1
            MyPicStruct.LayoutMode=3;
        end
    otherwise
        
        NumShot=1;%initialize
        DataFlag=GetDataFlag(handles);
        MyShot=get(handles.ShotNumber,'String');
        if iscell(MyShot)
            MyShot=MyShot{get(handles.ShotNumber,'value')};
        end
        
        nCurrentShot=str2num(MyShot);
        
        nMyCurveList=get(handles.lbCurves,'String');%for circulating use
        MyCurveList=get(handles.lbCurves,'String');
        % MyCurves=get(handles.lbCurves,'UserData');%
        [m,n]=size(MyCurves);%
        CurrentChannelNum=n;  %the
        %CurrentSysName='';
        
        
        
        
        dlg_title = 'Input total number of shots';
        prompt = {'Input total number of shots'};
        def   = {'1'};
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        sMyNum=answer{1};
        
        MyNum=str2num(sMyNum);
        if MyNum==0
            return
        elseif MyNum==1
            CurrentChannel=regexp(MyCurveList{1},'\w*$','match','once');
            totalNumShot=0;
            for iCurveList=1:length(MyCurveList)
                CurrentChannelNew=regexp(MyCurveList{iCurveList},'\w*$','match','once');
                if strcmp(CurrentChannel,CurrentChannelNew)
                    totalNumShot=totalNumShot+1;
                end
            end
            NumShot=totalNumShot;
            n=n/NumShot;
            %     CurrentChannelNum=n;
        else
        end
        
        
        
        
        
        MyStep=MyNum/abs(MyNum);
        if n==0
            return;
        elseif n>5
            str=strcat('are you sure you will go');
            answer=inputdlg({str},'Make Sure',1,{'Yes'});
            if answer{1}=='Yes'
            else
                return
            end
        end
        hwait=waitbar(0,'please wait ...');
        
        for CurrentShot=nCurrentShot:MyStep:nCurrentShot+MyNum-MyStep%positive or negative
            for i=1:n;
                
                CurrentChannels=nMyCurveList{i};
                j=strfind(CurrentChannels,'\');
                L=size(CurrentChannels,2);
                CurrentSysName=CurrentChannels(j-3:j-1);
                CurrentChannels=CurrentChannels(j+1:L);
                [CurrentChannel,NickName,IndexStart,IndexEnd,MyIndex,CurrentSysName1]=ParseChannelName(CurrentChannels);
                if DataFlag==0
                    [y,x,CurrentSysName,Unit]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag,'','',CurrentSysName);
                else
                    [y,x,CurrentSysName,Unit]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag,'','',CurrentSysName);
                end
                if strcmp(MyPicStruct.timeUnit,'ms')
                elseif strcmp(MyPicStruct.timeUnit,'s')
                    x=x/1000;
                end
                
                if isempty(y)
                    if isempty(y)
                        x=0;
                        y=0;
                        ShowWarning(CurrentShot,NickName,handles)
                        %continue
                    end
                end
                CurrentChannelNum=CurrentChannelNum+1;
                tMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel); %temporary variable
                if isempty(Unit)
                    Unit='au';
                end
                c=AddNewCurve(x,y,num2str(CurrentShot),NickName,Unit);
                
                if CurrentChannelNum>1
                    MyCurves(CurrentChannelNum)=c;
                    MyCurveList(CurrentChannelNum)={tMyCurveList};
                else
                    MyCurves=c;
                    MyCurveList={tMyCurveList};
                end
                
                waitbar((abs(CurrentShot-nCurrentShot)*n+i)/abs(n*MyNum));
            end%i=1:n
        end%iShot
        
        close(hwait)
        PicDescription=[];
        s=SetMyCurves(MyCurveList);
        %set(handles.ShotNumber,'String',num2str(CurrentShot));
        if isempty(MyPicStruct)
            MyPicStruct=MyPicInit;%init by file data
        end
        
end

if abs(MyNum)==1
    if NumShot==1
        MyPicStruct.LayoutMode=4;
    else
        MyPicStruct.LayoutMode=10;
    end
end

if abs(MyNum)>1
    MyPicStruct.LayoutMode=10;
end


Struct2View(handles)
DrawCurves_Callback(handles.DrawCurves, eventdata, handles)

% --------------------------------------------------------------------
% --------------------------------------------------------------------
function LoadCurve_Callback(hObject, eventdata, handles)
%this subroutine input the curve in workspace into the curves for drawing
global   MyCurves
%global  MyPicStruct PicDescription
try
    CurrentShot=0;%for uniform
    CurrentChannels=get(hObject,'String'); %get the curve name from edittext
    CurrentChannel=deblank(CurrentChannels);
    
    MyCurveList=get(handles.lbCurves,'String');
    % MyCurves=get(handles.lbCurves,'UserData');%
    %     MyCurves=[];
    [m,n]=size(MyCurves);%
    CurrentChannelNum=n;
    
    j=strfind(CurrentChannel,':');
    %two way to input the curve
    if j %for two variable case
        MyX=CurrentChannel(1:j-1);
        x=evalin('base',MyX);
        MyY=CurrentChannel(j+1:length(CurrentChannel));
        y=evalin('base',MyY);
    else %for one variable case
        
        myVar=CurrentChannel;
        MyXY=evalin('base',myVar);
        x=MyXY(:,1);
        [m1,n1]=size(MyXY);
        y=MyXY(:,2:n1);
    end
    if isempty(y)
        ShowWarning(CurrentShot,strcat('no curve/', myVar),handles)
        return
    end
    
    [m1,n1]=size(y);
    IndexStart=1;
    if n1>1
        IndexEnd=n1;
    else
        IndexEnd=1;
    end
    
    CurrentSysName='bas';
    Unit='au';
    NickName=CurrentChannel;
    
    for CurrentIndex=IndexStart:IndexEnd
        if IndexStart==IndexEnd
            nMyCurveList=strcat('00000',CurrentSysName,'\$',CurrentChannel);
            %c=AddNewCurve(x(:,1),y(:,1),num2str(CurrentShot),NickName,Unit);
            c=AddNewCurve(x,y,num2str(CurrentShot),NickName,Unit);
        else
            nMyCurveList=strcat('00000',CurrentSysName,'\$',CurrentChannel,'%',num2str(CurrentIndex));
            c=AddNewCurve(x(:,1),y(:,CurrentIndex),num2str(CurrentShot),strcat(NickName,'%',num2str(CurrentIndex)),Unit);
        end
        CurrentChannelNum=CurrentChannelNum+1;
        if CurrentChannelNum>1
            MyCurves(CurrentChannelNum)=c;
            MyCurveList(CurrentChannelNum)={nMyCurveList};
        else
            MyCurves=c;
            MyCurveList={nMyCurveList};
        end
    end%CurrentIndex
    s=SetMyCurves(MyCurveList);
catch
    ShowWarning(CurrentShot,strcat('no curve/', nMyCurveList),handles)
end

% --------------------------------------------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------





function AccessMode_Callback(hObject, eventdata, handles)
DataFlag=SetDataFlag();

function AccessMode_CreateFcn(hObject, eventdata, handles)
% --- Executes on button press in CChannels.
function CChannels_Callback(hObject, eventdata, handles)
setappdata(0,'clickConfigMode','chnlShow');

dir_struct = dir(getDProot('Channels'));
[n,m]=size(dir_struct);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
Mylist={dir_struct.name};
set(handles.lbConfiguration,'Value',1);
set(handles.lbConfiguration,'String',Mylist);


% --------------------------------------------------------------------
function PutIntoBase_Callback(hObject, eventdata, handles)
global   MyCurves
% MyCurves=get(handles.lbCurves,'UserData');%
[m,n]=size(MyCurves);
if n>0
    for i=1:n
        myVar=strtok(MyCurves(i).ChnlName,'%');
        myVar=strrep(myVar,'-','');
        myVar=strrep(myVar,'#','');
        myVar=strrep(myVar,'+','');
        myVar=strrep(myVar,'*','');
        myVar=strrep(myVar,'/','');
        myVar=strrep(myVar,'\','');
        myVar=strrep(myVar,'@','');
        myVar=strrep(myVar,'=','');
        myVar=genvarname(myVar,who);
        
        MyXY=MyCurves(i).x;
        MyXY(:,2)=MyCurves(i).y;
        %global 'myVar'
        %'myVar'=MyXY;
        assignin('base',myVar,MyXY);
    end
end

%ViewDeltaT_Callback(handles.ViewDeltaT, eventdata, handles)
% --------------------------------------------------------------------


% --------------------------------------------------------------------
function ViewDeltaT_Callback(hObject, eventdata, handles)
global   MyCurves
% MyCurves=get(handles.lbCurves,'UserData');%
[m,n]=size(MyCurves);
myVar=strtok(MyCurves(1).ChnlName,'%');

MyX=strcat(myVar,'(:,1)');
x=evalin('base',MyX);
MyY=strcat(myVar,'(:,2)');
y=evalin('base',MyY);

%x1=x(1:length(x)-1);
%x2=x(2:length(x));
%delX=x2-x1;
delX=diff(x);
delY=diff(y);
delX(length(x))=delX(length(x)-1);
delY(length(x))=delY(length(x)-1);
%ind=find(delX==max(delX));
%ind=find(delX==min(delX));
figure;
plot(x,1000*delX,'Marker','.');
xlabel('t(s)');
ylabel('DelT(ms)');
title(strcat(MyCurves(1).Shot,'/',MyCurves(1).ChnlName));

delT=x;
delT(:,2)=delX*1e6;
assignin('base','delT',delT);
return

ind=find(delX==0);
delX(ind)=inf;
delY=delY./delX;
MyPosition=get(gca,'Position');
a0=axes('Position',MyPosition);
set(a0,'Color','none','XColor','b','YAxisLocation','right','YColor','r');
hline=line(x,delY,'Parent',a0,'Color','r','Marker','.');


% --- Executes during object creation, after setting all properties.
function LoadCurve_CreateFcn(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function OpenF_Callback(hObject, eventdata, handles)
sShotNumber=get(handles.ShotNumber,'string');
if iscell(sShotNumber)
    sShotNumber=sShotNumber{get(handles.ShotNumber,'value')};
end
isOneshot=getappdata(0,'isOneshot');%select one shot or all shot

if isempty(isOneshot)
    if isempty(sShotNumber)
        shotfilter='';
    else
        shotfilter=sShotNumber;
        setappdata(0,'isOneshot',1)
    end
elseif isOneshot==1
    shotfilter=sShotNumber;
end

%access the file we access recently
MyPath=getappdata(0,'MyPath');%initial
if isempty(MyPath) || ~ischar(MyPath) || ~isdir(MyPath)
    MyPath=fullfile('z:','vec','inf');%initial
end

% [FileName,PathName,FilterIndex] = uigetfile(FilterSpec)




MyPath = uigetdir(MyPath);
setappdata(0,'MyPath',MyPath)


if ~ischar(MyPath) || ~isdir(MyPath)
    msgbox('no valid dir')
    return
end
%try to guess the interesting access mode
n=length(MyPath);

if ~isempty(strfind(lower(MyPath),'vec'))
    DataFlag=4;%for vec file
elseif ~isempty(strfind(lower(MyPath),'inftim'))
    DataFlag=3;%for long
elseif ~isempty(strfind(lower(MyPath),'inf'))
    DataFlag=1;%for short
else
    CurrentInfoFile=strcat('*',shotfilter,'*.inf');
    MyPath1=fullfile(MyPath,CurrentInfoFile);   %
    dir_struct = dir(MyPath1);
    if isempty(dir_struct)
        msgbox('no valid dir')
    else
        DataFlag=5;%inf and data in the same dir
    end
end

% change accessMode
set(handles.AccessMode,'UserData',DataFlag);
set(handles.ShotNumber,'UserData',MyPath);
set(handles.lbWarning,'String',{MyPath});
set(handles.lbWarning,'value',1);


CurrentInfoFile='*.inf';
MyPath=fullfile(MyPath,CurrentInfoFile);   %
dir_struct = dir(MyPath);


if 0 % length(dir_struct)>50
    CurrentInfoFile=strcat('*',shotfilter,'*.inf');
    MyPath=get(handles.ShotNumber,'UserData');
    MyPath=fullfile(MyPath,CurrentInfoFile);   %
    dir_struct = dir(MyPath);
end



if isempty(dir_struct)
    msgbox('no file for this shot')
    return
end
[n,m]=size(dir_struct);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
%Mylist={dir_struct.name};
Mylist=sorted_names;

if DataFlag~=4;%for vec file
    Mylist(~cellfun('isempty',strfind(Mylist,'VEC')))=[];
end

set(handles.lbConfiguration,'Value',1);
set(handles.lbConfiguration,'String',Mylist);

clickConfigMode='fileShow';
setappdata(0,'clickConfigMode',clickConfigMode);



% --------------------------------------------------------------------
function ViewInfo_Callback(hObject, eventdata, handles)
CurrentChannels=get(handles.lbChannels,'String');
CurrentSelectNum=get(handles.lbChannels,'Value');
CurrentChannels=deblank(CurrentChannels{CurrentSelectNum});
MyChannels=get(handles.lbChannels,'UserData');
if isfield(MyChannels,'DasInf')
    CurrentInfs=MyChannels.DasInf;
elseif isfield(MyChannels,'VecInf')
    CurrentInfs=MyChannels.VecInf;
end
CurrentChannels=genvarname(CurrentChannels,who);
myInfo=strcat(CurrentChannels,'_Info');
assignin('base',myInfo,CurrentInfs(CurrentSelectNum));

% --- Executes on selection change in lbWarning.
function lbWarning_Callback(hObject, eventdata, handles)
myWarning=get(handles.lbWarning,'String');
mySelectionType=get(gcf,'SelectionType');
if isempty(myWarning)
    switch mySelectionType
        case 'normal'
            MyChanLists=GetCurveNames;
            set(handles.lbChannels,'UserData',[]);
            set(handles.lbChannels,'String',MyChanLists);
            set(handles.lbChannels,'Value',length(MyChanLists));
            set(handles.lbConfiguration,'Value',0);
            set(handles.lbConfiguration,'String',[]);
            
        case 'extend'
            R1_Callback([], [], handles)
        case 'f6'
    end
else
    set(handles.lbWarning,'String',[])
end


function lbWarning_CreateFcn(hObject, eventdata, handles)
function xLeft_CreateFcn(hObject, eventdata, handles)
function xStep_CreateFcn(hObject, eventdata, handles)
function xRight_CreateFcn(hObject, eventdata, handles)
function xLeft_Callback(hObject, eventdata, handles)
function xStep_Callback(hObject, eventdata, handles)
function xRight_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------


function InitPicPara_Callback(hObject, eventdata, handles)
global   PicDescription MyPicStruct Lines2Axes
Lines2Axes=[];
PicDescription=[];%init

MyPicStruct=MyPicInit;%init by file data
Struct2View(handles);
%update the view

function InterpPeriod_Callback(hObject, eventdata, handles)
global InterpPeriod bFullOrFast
sInterpPeriod=get(hObject,'String');
if length(sInterpPeriod)>2 && strcmpi(sInterpPeriod(end-1:end),'hz')
    InterpPeriod=sInterpPeriod(1:end-2);
elseif length(sInterpPeriod)>1 && strcmpi(sInterpPeriod(end:end),'h')
    InterpPeriod=sInterpPeriod(1:end-1);
elseif strcmpi(sInterpPeriod,'nan')
    InterpPeriod=[];
else
    InterpPeriod=str2num(sInterpPeriod);
end


if ~isempty(InterpPeriod) && isnumeric(InterpPeriod) && InterpPeriod==1
    bFullOrFast=1;
    set(handles.AccessSpeed,'BackgroundColor','g');
    set(handles.AccessSpeed,'String','FULL');
else
    bFullOrFast=0;
    set(handles.AccessSpeed,'BackgroundColor','m');
    set(handles.AccessSpeed,'String','FAST');
end




% --- Executes during object creation, after setting all properties.
function InterpPeriod_CreateFcn(hObject, eventdata, handles)




% --------------------------------------------------------------------
function OpenVector_Callback(hObject, eventdata, handles)
global LocalPath
DataFlag=0;%
set(handles.AccessMode,'UserData',DataFlag);
if ~isdir(MyPath)
    MyPath='z:\backup\vec';
end
MyPath = uigetdir(MyPath);
%if isdir(MyPath)
if ischar(MyPath)
    if isdir(MyPath)
        LocalPath=MyPath;
    else
        return
    end
else
    return
end

%MyPath =yDriver;
MyPath = strcat(MyPath,'\inf\');
%MyPath = strcat(MyPath,'\fb\inf\');
set(handles.ShotNumber,'UserData',MyPath);
set(handles.lbWarning,'String',MyPath);

MyPath=strcat(MyPath,'*.inf');   %
dir_struct = dir(MyPath);
[n,m]=size(dir_struct);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');

Mylist={dir_struct.name};
set(handles.lbConfiguration,'Value',1);
set(handles.lbConfiguration,'String',Mylist);




% --- Executes on button press in tChannels.
function tChannels_Callback(hObject, eventdata, handles)
v=get(hObject,'UserData');
if isempty(v)
    v=0;
end

if v==0%tChannels
    v=1;
    set(handles.tChannels,'BackgroundColor','g');
    set(handles.tChannels,'UserData',v);
    set(handles.tChannels,'String','Browser+Add');
    
elseif v==1
    v=0;
    set(handles.tChannels,'BackgroundColor','m');
    set(handles.tChannels,'UserData',v);
    set(handles.tChannels,'String','Browser');
end


% --- Executes on button press in DataMode.
function DataMode_Callback(hObject, eventdata, handles)
global SmoothStatus bFullOrFast
global  zdTstart zdTend

SmoothStatus=get(handles.DataMode,'value')-1;

if SmoothStatus==4
    bFullOrFast=1;
    set(handles.AccessSpeed,'BackgroundColor','g');
    set(handles.AccessSpeed,'String','FULL');
    set(handles.InterpPeriod,'String','1');
else
    zdTstart=[];
    zdTend=[];
    bFullOrFast=0;
    set(handles.AccessSpeed,'BackgroundColor','m');
    set(handles.AccessSpeed,'String','FAST');
    set(handles.InterpPeriod,'String','nan');
end





% --------------------------------------------------------------------
% --------------------------------------------------------------------
function DP_KeyPressFcn(hObject, eventdata, handles)
global  MyPicStruct PicDescription
if isempty(MyPicStruct)
    MyPicStruct=MyPicInit;%init by file data
end
C=get(handles.DP,'currentkey');

switch C
    case 'shift'
    case 'control'
    case 'delete'
        setappdata(0,'SingleFigure',[]);
        setappdata(0,'MenuStatus',[]);
    case 'insert'
        setappdata(0,'MenuStatus',1);
    case 'end'
        setappdata(0,'SingleFigure',1);
        
        
    case 'f8'
        dlg_title = '0=1/0;1=1/1;2=135/246/;3=111;';
        prompt = {'4=1/1.2/2.3/3;5=2/0;6=111...222;7=135+246;'};
        def     = {num2str(MyPicStruct.LayoutMode)};
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        
        MyPicStruct.LayoutMode=str2num(answer{1});
        MyPicStruct.Modified=1;
        DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
    case 'f9'
        dlg_title = 'Marker';
        prompt = {'Enter the Marker'};
        def     = {num2str(MyPicStruct.Marker)};
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        
        MyPicStruct.Marker=str2num(answer{1});
        MyPicStruct.Modified=1;
    case 'f10'
        if MyPicStruct.DefaultAxesLineWidth==12
            MyPicStruct.DefaultAxesLineWidth=18;
        elseif MyPicStruct.DefaultAxesLineWidth==18
            MyPicStruct.DefaultAxesLineWidth=12;
        end
        MyPicStruct.Modified=1;
    case 'f11'
        dlg_title = 'Tick accuracy';
        prompt = {'Enter the number of accuracy'};
        def     = {num2str(MyPicStruct.RightDigit)};
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        MyPicStruct.RightDigit=str2num(answer{1});
        MyPicStruct.Modified=1;
    case 'f12'
        if MyPicStruct.MyTransparencyValue==1
            MyPicStruct.MyTransparencyValue=0.5;
        elseif MyPicStruct.MyTransparencyValue==0.5
            MyPicStruct.MyTransparencyValue=1;
        end
        MyPicStruct.Modified=1;
    otherwise
end




% --- Executes on button press in Help.
function Help_Callback(hObject, eventdata, handles)
dos('"C:\Program Files\Adobe\Acrobat 9.0\Acrobat\Acrobat.exe" "C:\DataProc\dp.pdf" &');







% sHelp='del=del menu & figure';
% ShowWarning(0,sHelp,handles)
% sHelp='insert=add menu';
% ShowWarning(0,sHelp,handles)
% sHelp='end=add figure';
% ShowWarning(0,sHelp,handles)
% sHelp='f8=Layout';
% ShowWarning(0,sHelp,handles)
% sHelp='f9=Marker';
% ShowWarning(0,sHelp,handles)
% sHelp='f10=DefaultAxesLineWidth';
% ShowWarning(0,sHelp,handles)
% sHelp='f11=Tick accuracy';
% ShowWarning(0,sHelp,handles)
% sHelp='f12=Transparency Value';
% ShowWarning(0,sHelp,handles)



% --- Executes on button press in GetParameter.
function GetParameter_Callback(hObject, eventdata, handles)
global  MyPicStruct PicDescription
Names=evalin('base','who');

for i=1:length(Names)
    Name=Names{i};
    myVar=strcat('''',Name,'''');
    Mycode=['setappdata(0,',myVar,',',Name,');'];
    evalin('base',Mycode);
    if strmatch('MyPicStruct',Name)
        MyPicStruct=getappdata(0,'MyPicStruct');
        setappdata(0,'MyPicStruct',[]);
        evalin('base','clear MyPicStruct;');
    end
    if strmatch('PicDescription',Name)
        PicDescription=getappdata(0,'PicDescription');
        setappdata(0,'PicDescription',[]);
        evalin('base','clear PicDescription;');
    end
end

evalin('base','clc;');




% --- Executes on button press in CConfiguration.
function CConfiguration_Callback(hObject, eventdata, handles)
setappdata(0,'clickConfigMode','chnlConfig');

MyPath = which('DP');
dir_struct = dir([MyPath(1:end-4) 'configuration']);
[n,m]=size(dir_struct);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');

Mylist={dir_struct.name};
set(handles.lbConfiguration,'Value',1);
set(handles.lbConfiguration,'String',Mylist);

% --- Executes on button press in ShotOK.
% function ShotOK_Callback(hObject, eventdata, handles)
% ShotNumber_Callback(handles.ShotNumber, eventdata, handles)

% --- Executes on selection change in LayoutMode.
function LayoutMode_Callback(hObject, eventdata, handles)
global  PicDescription MyPicStruct Lines2Axes
PicDescription=[];
Lines2Axes=[];
MyPicStruct=View2Struct(handles);

%---------------------------
function YMode_Callback(hObject, eventdata, handles)
global  MyPicStruct
v=get(hObject,'UserData');
if isempty(v)
    v=0
end
if v==0
    v=1;
    set(handles.YMode,'BackgroundColor','g');
    set(handles.YMode,'String','YLimitAuto');
elseif v==1
    v=0;
    set(handles.YMode,'BackgroundColor','m');
    set(handles.YMode,'String','YLimitFixed');
end
set(hObject,'UserData',v);

if isempty(MyPicStruct)
    MyPicStruct=MyPicInit;%init by file data
end
MyPicStruct.YLimitAuto=v;
% --------------------------------------------------------------------
function OpenVEC_Callback(hObject, eventdata, handles)
global   LocalPath
MyPath='c:';
MyPath = uigetdir(MyPath);
%if isdir(MyPath)
if ischar(MyPath)
    if isdir(MyPath)
        LocalPath=MyPath;
    else
        return
    end
else
    return
end

switch DataFlag
    case 1 %for local short name
        %MyPath =yDriver;
        MyPath = strcat(MyPath,'\inf\');
        %MyPath = strcat(MyPath,'\fb\inf\');
        
        set(handles.ShotNumber,'UserData',MyPath);
        set(handles.lbWarning,'String',MyPath);
        
        MyPath=strcat(MyPath,'*.inf');   %
        dir_struct = dir(MyPath);
        [n,m]=size(dir_struct);
        [sorted_names,sorted_index] = sortrows({dir_struct.name}');
        
        Mylist={dir_struct.name};
        set(handles.lbConfiguration,'Value',1);
        set(handles.lbConfiguration,'String',Mylist);
    case 3 %for local long name
        %MyPath =yDriver;
        MyPath = strcat(MyPath,'\inftim\');
        %MyPath = strcat(MyPath,'\fb\inf\');
        
        set(handles.ShotNumber,'UserData',MyPath);
        set(handles.lbWarning,'String',MyPath);
        
        MyPath=strcat(MyPath,'*.inf');   %
        dir_struct = dir(MyPath);
        [n,m]=size(dir_struct);
        [sorted_names,sorted_index] = sortrows({dir_struct.name}');
        
        Mylist={dir_struct.name};
        set(handles.lbConfiguration,'Value',1);
        set(handles.lbConfiguration,'String',Mylist);
end
function ADValue_Callback(hObject, eventdata, handles)
global ADValue %sometimes, we need the AD value for debugging, use this status for get it
if ~isempty(ADValue) && ADValue
    ADValue=[];
    set(handles.ADValue,'Label','PhysicalValue')
else
    ADValue=1;
    set(handles.ADValue,'Label','ADValue')
end
%----------------------------------------------------
function myInformation(hObject, eventdata, handles)
lbs=findobj(handles,'Type','uicontrol','style','listbox');
currentnum=get(hObject,'Value');
for i=1:length(lbs)
    set(lbs,'Value',currentnum);
end


function mySelect(hObject, eventdata, method)
global handles PicDescription
handles=getappdata(0,'handles');



hCheckBox=getappdata(0,'hCheckBox');
numChannels=length(hCheckBox);
switch method
    case 'all'
        myValues=ones(numChannels,1);
        myValues=num2cell(myValues);
        set(hCheckBox,{'value'},myValues)
    case 'none'
        myValues=zeros(numChannels,1);
        myValues=num2cell(myValues);
        set(hCheckBox,{'value'},myValues)
    case 'ok'
        index=get(hCheckBox,'value');
        index= cell2mat(index);
        index= logical(index);
        hChannel=getappdata(0,'hChannel');
        Channels=get(hChannel,'String');
        Channels=Channels(index);
        
        
        set(handles.lbCurves,'String',Channels);
        set(handles.lbCurves,'value',length(Channels));
        delete(get(hObject,'parent'))
        PicDescription=[];
        UpdateShot_Callback([], [], handles)
end



function Debug1_CreateFcn(hObject, eventdata, handles)
function Debug2_CreateFcn(hObject, eventdata, handles)

%set the debug parameter for temporary use
function Debug1_Callback(hObject, eventdata, handles)
function Debug2_Callback(hObject, eventdata, handles)
if strcmp(get(handles.Debug2,'string'),'0')
    MyChanLists=[];
    set(handles.lbChannels,'String',MyChanLists);
    set(handles.lbChannels,'Value',length(MyChanLists));
end



function InitPic_Callback(hObject, eventdata, handles)
global PicDescription HeightNumber MyPicStruct WidthNumber
PicDescription=[];%init
MyPicStruct=MyPicInit;%init by file data
Struct2View(handles);
HeightNumber=[];
WidthNumber=[];




%for calibration
% function EditMode_Callback(hObject, eventdata, handles)
% global bFacMode
%
% if strmatch(get(handles.SortMode,'String'),'FacMode=1')
%     bFacMode=0;
%     set(handles.SortMode,'BackgroundColor','m');
%     set(handles.SortMode,'String','FacMode=auto');
% elseif strmatch(get(handles.SortMode,'String'),'FacMode=auto')
%     bFacMode=1;
%     set(handles.SortMode,'BackgroundColor','g');
%     set(handles.SortMode,'String','FacMode=1');
% end

function SortMode_Callback(hObject, eventdata, handles)
%sorting the channel
global bSortMode
MyChanList=get(handles.lbChannels,'String');

if strmatch(get(handles.SortMode,'String'),'sorting')
    bSortMode=0;
    set(handles.SortMode,'BackgroundColor','m');
    set(handles.SortMode,'String','nosorting');
    if ~isempty(getappdata(0,'nosortingMyChanList'))
        MyChanList=getappdata(0,'nosortingMyChanList');
    end
elseif strmatch(get(handles.SortMode,'String'),'nosorting')
    bSortMode=1;
    set(handles.SortMode,'BackgroundColor','g');
    set(handles.SortMode,'String','Sorting');
    setappdata(0,'nosortingMyChanList',MyChanList);
    MyChanList=sort(MyChanList);
    
elseif strmatch(get(handles.SortMode,'String'),'Sorting')
    bSortMode=2;
    set(handles.SortMode,'BackgroundColor','c');
    set(handles.SortMode,'String','sorting');
    MyChanList=sort(lower(MyChanList));
end
set(handles.lbChannels,'String',MyChanList);
set(handles.lbChannels,'Value',length(MyChanList));


function R1_Callback(hObject, eventdata, handles)
% MyChanLists={'@ip';'@ccdh';'@bt';'@itf';'@fluxdh';'@dh';'@ie1toipfbc';'@ie2toie1fbc';...
%     	'@ie2toie1mmc';'@g4_fw';'@tedd7';'@neh';'@ph2p';'@ph2';'@xww';'@poh';...
%         '@pohmmc';'@v2i';'@v2islow';'@prad';'@pion';'@pecrh';'@flux'};
% set(handles.lbChannels,'String',MyChanLists);
% set(handles.lbChannels,'Value',length(MyChanLists));

global MyPicStruct Lstring Rstring Sstring Astring
MyPicStruct=View2Struct(handles);
if strmatch(get(handles.R1,'String'),'edit')
    set(handles.R1,'BackgroundColor','m');
    set(handles.R1,'String','popupmenu');
    set(handles.xLeft,'style','popupmenu');
    set(handles.xRight,'style','popupmenu');
    set(handles.xStep,'style','popupmenu');
    set(handles.ShotNumber,'style','popupmenu');
    set(handles.AddCurve,'style','popupmenu');
    LastestShot=GetLastestShot;
    if strmatch(get(handles.ShotNumber,'style'),'edit')
        set(handles.ShotNumber,'String',num2str(LastestShot));
    else
        LastestShots=LastestShot:-1:LastestShot-300;
        set(handles.ShotNumber,'String',{num2str(LastestShots')});
        set(handles.ShotNumber,'value',1);
    end
    
    Lstring{1}=num2str(MyPicStruct.xleft);
    Rstring{1}=num2str(MyPicStruct.xright);
    set(handles.xLeft,'value',1);
    set(handles.xRight,'value',1);
    set(handles.xLeft,'string',Lstring);
    set(handles.xRight,'string',Rstring);
    set(handles.xStep,'string',Sstring);
    set(handles.AddCurve,'string',Astring);
elseif strmatch(get(handles.R1,'String'),'popupmenu')
    set(handles.R1,'BackgroundColor','g');
    set(handles.R1,'String','edit');
    %     save the string
    Lstring=get(handles.xLeft,'string');
    Rstring=get(handles.xRight,'string');
    Sstring=get(handles.xStep,'string');
    Astring=get(handles.AddCurve,'string');
    
    set(handles.xLeft,'string',num2str(MyPicStruct.xleft));
    set(handles.xRight,'string',num2str(MyPicStruct.xright));
    set(handles.xStep,'string',num2str(MyPicStruct.xStep));
    set(handles.xLeft,'style','edit');
    set(handles.xRight,'style','edit');
    set(handles.xStep,'style','edit');
    MyShot=get(handles.ShotNumber,'String');
    if ~isempty(MyShot) && iscell(MyShot)
        MyShot=MyShot{get(handles.ShotNumber,'value')};
    end
    strAddCurve=get(handles.AddCurve,'String');
    if ~isempty(strAddCurve) && iscell(strAddCurve)
        strAddCurve=strAddCurve{get(handles.AddCurve,'value')};
    end
    set(handles.ShotNumber,'style','edit');
    set(handles.ShotNumber,'string',MyShot);
    set(handles.AddCurve,'style','edit');
    set(handles.AddCurve,'string',strAddCurve);
end
ShotNumber_Callback([], eventdata, handles)

function EqualFormula_Callback(hObject, eventdata, handles)
CurrentChannels=GetFormulaNames;
set(handles.lbChannels,'String',CurrentChannels);
set(handles.lbChannels,'value',1);
return


subplot(handles.aBrowser)
[X, map]=imread('russian.jpg');
image(X)
colormap(map)
axis image
axis off

function R3_Callback(hObject, eventdata, handles)
global Ylimit4Browser
global bFacMode

% setZDrange; %set zero drift calibration range
y=setSystemName;
ShowWarning(0,'new system name has been indexed!',handles)

%for calibration
% function EditMode_Callback(hObject, eventdata, handles)
%
% if strmatch(get(handles.SortMode,'String'),'FacMode=1')
%     bFacMode=0;
%     set(handles.SortMode,'BackgroundColor','m');
%     set(handles.SortMode,'String','FacMode=auto');
% elseif strmatch(get(handles.SortMode,'String'),'FacMode=auto')
%     bFacMode=1;
%     set(handles.SortMode,'BackgroundColor','g');
%     set(handles.SortMode,'String','FacMode=1');
% end


subplot(handles.aBrowser)
% [X, map]=imread('russian.jpg');
[X, map]=imread('songxm.jpg');
image(X)
colormap(map)
axis image
axis off
return


%for calibration   Luocuiwen
dlg_title = 'Set the Ylimit for browsering the curves';
prompt = {'ymin','ymax'};
def   = {'-6','6'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    ShowWarning(0,'no property change',handles)
    return
end
Ylimit4Browser(1,1)=str2num(answer{1});
Ylimit4Browser(1,2)=str2num(answer{2});
bFacMode=1;





function R4_Callback(hObject, eventdata, handles)
global bFacMode
subplot(handles.aBrowser)
[X, map]=imread('Harvard.jpg');
image(X)
colormap(map)
axis image
axis off
return
%for calibration   Luocuiwen
bFacMode=1;





function DefineFormula_Callback(hObject, eventdata, handles)

hfigNames=figure('resize','off','Name','Calculate the expression');
%         setappdata(0,'bCalculateOK',0);
%         assignin('base','bModifyOK',0)

%set(hfigNames,'MenuBar','none','WindowStyle','modal');
%         set(hfigNames,'MenuBar','none','Toolbar','figure');
set(hfigNames,'MenuBar','none');
scrsz = get(0,'ScreenSize');
set(hfigNames,'Units','pixels','Tag','Formula','Name','build up formula')
set(hfigNames,'Position',[scrsz(1) scrsz(2) scrsz(3)/1.05 scrsz(4)/1.05])


sLabel=[{'+'} {'-'} {'*'} {'/'} {'('} {')'} {'^'} {'sin'} {'cos'} {'log'}];

sCommand=[{'InBase'} {'InCurve'} {'Clear'} {'Save'} {'Load'} {'Show'} {'ZoomOn'} {'ZoomOff'} {'Close'}];
hListbox=scrsz(4)/1.15;
wListbox=scrsz(3)/10;
wstep=scrsz(3)/18;
hstep=scrsz(4)/36;
[Num,m]=size(sLabel);
for i=1:m+1
    dLeft(i)=(i-0.5)*wstep*1.1+5*wstep;
    dWidth(i)=wstep;
end


hFile=uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'BackgroundColor',          'm',...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'style', 'edit',...
    'Position',[wListbox+wstep/2 scrsz(2)+hstep+hListbox wListbox+wstep/2 hstep ],...
    'String', '');
hLabelExpression=uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'BackgroundColor',          'w',...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'style', 'text',...
    'Position',[dLeft(1) scrsz(2)-hstep+hListbox 2*dWidth(1) scrsz(4)/40 ],...
    'String', 'Formula');
hExpression=uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'BackgroundColor',          'm',...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'style', 'edit',...
    'Position',[dLeft(1) scrsz(2)-2*hstep+hListbox 11*dWidth(i) scrsz(4)/40 ],...
    'String', '');
hLabelChannelName=uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'BackgroundColor',          'w',...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'style', 'text',...
    'Position',[dLeft(1) scrsz(2)-3*hstep+hListbox 2*dWidth(1) scrsz(4)/40 ],...
    'String', 'CurrentName');
hLabelChannelNames=uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'BackgroundColor',          'w',...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'style', 'text',...
    'Position',[dLeft(1)+2.02*dWidth(1) scrsz(2)-3*hstep+hListbox 2*dWidth(1) scrsz(4)/40 ],...
    'String', 'CurrentName');
hChannelName=uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'BackgroundColor',          'm',...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'style', 'edit',...
    'Position',[dLeft(1) scrsz(2)-4*hstep+hListbox 2*dWidth(i) scrsz(4)/40 ],...
    'String', '=a');
hChannelNames=uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'BackgroundColor',          'm',...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'style', 'popupmenu',...
    'Position',[dLeft(1)+2.02*dWidth(1) scrsz(2)-4*hstep+hListbox 2*dWidth(1) scrsz(4)/40 ],...
    'String', '=a');
hLabelDependence=uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'BackgroundColor',          'w',...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'style', 'text',...
    'Position',[dLeft(1) scrsz(2)-5*hstep+hListbox 2*dWidth(1) scrsz(4)/40 ],...
    'String', 'Dependence');
hDependence=uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'BackgroundColor',          'm',...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'style', 'edit',...
    'Position',[dLeft(1) scrsz(2)-6*hstep+hListbox 11*dWidth(i) scrsz(4)/40 ],...
    'String', '');
hDisplay=axes('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'Position',[dLeft(1) scrsz(2)-28*hstep+hListbox 11*dWidth(1) 20*hstep]);
hChannelSelect = uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'String',                  '', ...
    'BackgroundColor',          'w',...
    'Position',                 [wListbox+wstep/2 scrsz(2)+hstep wListbox+wstep/2 hListbox ],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'listbox', ...
    'Enable',                   'on', ...
    'Tooltipstring',            'Select the channel');
hFileSelect = uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'String',                  '', ...
    'BackgroundColor',          'w',...
    'Position',                 [0 scrsz(2)+hstep wListbox+wstep/2 hListbox ],...
    'HorizontalAlignment',      'left', ...
    'FontWeight',               'bold', ...
    'FontSize',                 12,...
    'Style',                    'listbox', ...
    'Enable',                   'on', ...
    'callback',                {@myhFileSelect,hChannelSelect,hFile,hDependence},...
    'Tooltipstring',            'Select the channel');

LastestShot=GetLastestShot;
hShotNumber=uicontrol('parent',                   hfigNames,...
    'Units',                    'pixels', ...
    'BackgroundColor',          'm',...
    'Visible',                  'on',...
    'FontWeight',               'bold', ...
    'FontSize',                 14,...
    'style', 'edit',...
    'Position',[0 scrsz(2)+hstep+hListbox wListbox+wstep/2 hstep ],...
    'String', num2str(LastestShot),...
    'callback', {@myhShotNumber,hFileSelect});
for i=1:m
    hCommand(i) = uicontrol('parent',                   hfigNames,...
        'Units',                    'pixels', ...
        'BackgroundColor',          'm',...
        'Visible',                  'on',...
        'FontWeight',               'bold', ...
        'FontSize',                 12,...
        'style', 'pushbutton',...
        'Position',[dLeft(i) scrsz(2)+hstep+hListbox dWidth(i) hstep ],...
        'String', sLabel{i},...
        'callback', {@myCommand,hExpression});
end
for i=1:length(sCommand)
    hCommandRun(i) = uicontrol('parent',                   hfigNames,...
        'Units',                    'pixels', ...
        'BackgroundColor',          'm',...
        'Visible',                  'on',...
        'FontWeight',               'bold', ...
        'FontSize',                 12,...
        'style', 'pushbutton',...
        'Position',[dLeft(i) scrsz(2)-7*hstep+hListbox dWidth(i) hstep ],...
        'String', sCommand{i},...
        'callback', {@myhCommandRun,hExpression,i,hChannelName,hDependence,hDisplay,hShotNumber});
end
set(hChannelSelect,'callback',{@myChannelSelect,hExpression,hDependence,hShotNumber,hFile,hDisplay})
myhShotNumber(hShotNumber, eventdata, hFileSelect)
CurrentChannels=GetFormulaNames;
set(hChannelNames,'String',CurrentChannels,'value',1);
set(hChannelName,'String',CurrentChannels{1});
set(hChannelNames,'callback',{@myChannelNames,hChannelName,hExpression,hDependence});
set(hChannelName,'callback',{@myChannelName,hExpression,hDependence});
[Expression,Dependence]=GetFormula(CurrentChannels{1});
set(hExpression,'String',Expression);
set(hDependence,'String',Dependence);
%----------------------------------------------------
function myChannelNames(hObject, eventdata, hChannelName,hExpression,hDependence)
ChannelNames=get(hObject,'String');
set(hChannelName,'String',ChannelNames{get(hObject,'Value')})
[Expression,Dependence]=GetFormula(ChannelNames{get(hObject,'Value')});
set(hExpression,'String',Expression);
set(hDependence,'String',Dependence);
%----------------------------------------------------
function myChannelName(hObject, eventdata,hExpression,hDependence)
ChannelName=get(hObject,'String');
[Expression,Dependence]=GetFormula(ChannelName);
set(hExpression,'String',Expression);
set(hDependence,'String',Dependence);

%----------------------------------------------------
function myhFileSelect(hObject, eventdata, hChannelSelect,hFile,hDependence)

MyFile=get(hObject,'String');
if iscell(MyFile)
    MyFile=MyFile{get(hObject,'value')};
end

if length(MyFile)==12
    system=MyFile(6:8);
    set(hFile,'String',system);%
    sDependence=get(hDependence,'String');
    if isempty(sDependence)
        sDependence=[system ':'];
    else
        %         sDependence = regexprep(sDependence, '\w$', ';');
        sDependence=[sDependence ';' system ':'];
    end
    set(hDependence,'String',sDependence);%
    MyShot1=MyFile(1:5);
else
    msgbox('the file is not standard one')
    return
end

CurrentShot=str2num(MyShot1);
[sMyShot,MyPath,Mylist] = GetShotPath(CurrentShot);
MyFile=get(hObject,'String');
if iscell(MyFile)
    MyFile=MyFile{get(hObject,'value')};
end
CurrentInfoFile=fullfile(MyPath,MyFile);
[DasInfos,ChannelNums]=GetMyInfoN(CurrentInfoFile);
if isempty(DasInfos) || isempty(DasInfos)
    msgbox('no channels in this file')
    return
end

MyChanList(1:ChannelNums,1)={DasInfos(1:ChannelNums).ChnlName};
MyChanList=ChannelsConditionning(MyChanList);

set(hChannelSelect,'value',1);%
set(hChannelSelect,'String',MyChanList);%



%----------------------------------------------------

%----------------------------------------------------
function myChannelSelect(hObject, eventdata, hExpression,hDependence,hShotNumber,hFile,hDisplay)
CurrentCurveNum=get(hObject,'Value');%
MyList=get(hObject,'String');%
MyCurveList=get(hExpression,'String');%
MyCurveList=[MyCurveList MyList{CurrentCurveNum}];%add one
set(hExpression,'String',MyCurveList);%
MyCurveList=get(hDependence,'String');%

MyCurveList = regexprep(MyCurveList, '(\w)$', '$1,');


MyCurveList=[MyCurveList MyList{CurrentCurveNum}];%add one
set(hDependence,'String',MyCurveList);%

CurrentShot=str2num(get(hShotNumber,'String'));
CurrentChannel=MyList{CurrentCurveNum};
CurrentSysName=get(hFile,'String');
[y,t]=hl2adb(CurrentShot,CurrentChannel,CurrentSysName);
subplot(hDisplay)
plot(t,y,'.g-')
% plot(t,y)
hold on

%----------------------------------------------------
function myCommand(hObject, eventdata, hExpression)
MyCurveList=get(hExpression,'String');%
MyList=get(hObject,'String');%
MyCurveList=[MyCurveList MyList];%add one
set(hExpression,'String',MyCurveList);%
% subplot(handles.aBrowser)
% % [X, map]=imread('MING32.bmp');
% [X, map]=imread('mm.bmp');
% image(X)
% colormap(map)
% axis image
% axis off
return
%----------------------------------------------------
function myhCommandRun(hObject, eventdata,hExpression, index,hChannelName,hDependence,hDisplay,hShotNumber)
global handles
handles=getappdata(0,'handles');
switch index
    case 1 % inbase
    case 2 % incurve
    case 3 % clear
        hLine=findobj(hDisplay,'type','line');
        if ~isempty(hLine)
            if ishandle(hLine)
                delete(hLine);
            end
        end
        
    case 4 %save
        mychannelname=get(hChannelName,'String');
        myexpression=get(hExpression,'String');
        mydependence=get(hDependence,'String');
        MyPath= which('DP');
        FormulaFile=[MyPath(1:end-4) 'configurations' filesep 'Formula.txt'];
        fid = fopen(FormulaFile,'r');
        remain = fread(fid, '*char')';
        status = fclose('all');
        
        if ispc
            mytok =[char(13) char(10)];
        elseif isunix
            mytok =[char(10)];
        end
        
        
        
        k = strfind(remain, mytok);
        k = strfind(remain, mychannelname);
        %replace the old
        if isempty(k)
            fid = fopen(FormulaFile,'a+');
            fwrite(fid,mychannelname,'char');
            fwrite(fid,mytok,'char');
            fwrite(fid,myexpression,'char');
            fwrite(fid,mytok,'char');
            fwrite(fid,mydependence,'char');
            fwrite(fid,mytok,'char');
            status = fclose('all');
        else
            delete(FormulaFile)
            mypattern=['\' mychannelname mytok '[^\=]+'];
            myvarname=regexp(remain, mypattern, 'match');%find old expression and dependence
            %           modify the  expression and dependence
            remain=strrep(remain,myvarname{1},[mychannelname mytok myexpression mytok mydependence mytok]);
            
            fid = fopen(FormulaFile,'a+');
            fwrite(fid,remain,'char');
            status = fclose('all');
        end
        %         k = strfind(remain, char(13));
        %         k = strfind(remain, mychannelname);
        %         if isempty(k)
        %             fid = fopen(FormulaFile,'a+');
        %             fwrite(fid,mychannelname,'char');
        %             fwrite(fid,[char(13) char(10)],'char');
        %             fwrite(fid,myexpression,'char');
        %             fwrite(fid,[char(13) char(10)],'char');
        %             fwrite(fid,mydependence,'char');
        %             fwrite(fid,[char(13) char(10)],'char');
        %             status = fclose('all');
        %         else
        %             delete(FormulaFile)
        %             mypattern=['\' mychannelname char(13) char(10) '[^\=]+'];
        %             myvarname=regexp(remain, mypattern, 'match');%|\.[\*\/\^]
        % %             Expression=regexprep(Expression,'(?<!\.)([/*///^])','.$1');
        %             remain=strrep(remain,myvarname{1},[mychannelname char(13) char(10) myexpression char(13) char(10) mydependence char(13) char(10)]);
        %
        %             fid = fopen(FormulaFile,'a+');
        %             fwrite(fid,remain,'char');
        %             status = fclose('all');
        %         end
    case 5 %load
        CurrentChannel=get(hChannelName,'String');
        [Expression,Dependence]=GetFormula(CurrentChannel);
        set(hExpression,'String',Expression);
        set(hDependence,'String',Dependence);
        
    case 6 %show
        MyPicStruct=View2Struct(handles);
        % calculate
        CurrentShot=str2num(get(hShotNumber,'String'));
        %         LastestShot=GetLastestShot-1;
        myexpression=get(hExpression,'String');
        mychannelname=get(hChannelName,'String');
        mydependence=get(hDependence,'String');
        
        [yy,t]=Formula(CurrentShot,myexpression,mydependence);
        if mychannelname(1)=='='
            CurrentChannel=mychannelname(2:end);
        else
            CurrentChannel=mychannelname;
        end
        myexpression=[CurrentChannel '=yy;'];
        eval(myexpression);
        subplot(hDisplay)
        mycommand=['plot(t,' CurrentChannel ',''.r-'')'];
        eval(mycommand)
    case 7 %zoom on
        zoom on
    case 8 %zoom off
        zoom off
        
    case 9 %close
        delete(gcf)
        
        
end
%----------------------------------------------------
function myhShotNumber(hObject,eventdata,handles)
MyShot1=get(hObject,'String');
if iscell(MyShot1)
    MyShot1=MyShot1{get(hObject,'value')};
end
CurrentShot=str2num(MyShot1);
[sMyShot,MyPath,Mylist] = GetShotPath(CurrentShot);
set(handles,'String',Mylist);
%----------------------------------------------------
function CurrentChannels=GetFormulaNames
MyPath= which('DP');
FormulaFile=[MyPath(1:end-4) 'configurations' filesep 'Formula.txt'];
fid = fopen(FormulaFile,'r');
remain = fread(fid, '*char')';
status = fclose('all');

if ispc
    mytok =[char(13) char(10)];
elseif isunix
    mytok =[char(10)];
end


k = strfind(remain, mytok);
for i=1:(length(k)+1)/3
    [mychannelname, remain] = strtok(remain, mytok);
    CurrentChannels{i}=mychannelname;
    [myexpression, remain] = strtok(remain, mytok);
    [mydependence, remain] = strtok(remain, mytok);
end

% --------------------------------------------------------------------
function FacMode_Callback(hObject, eventdata, handles)
global Ylimit4Browser
global bFacMode


%for calibration
% function EditMode_Callback(hObject, eventdata, handles)

if bFacMode==1
    bFacMode=0;
    set(hObject,'Label','Factor=auto');
elseif bFacMode==0
    bFacMode=1;
    set(hObject,'Label','Factor=1');
    %for calibration   Luocuiwen
    dlg_title = 'Set the Ylimit for browsering the curves';
    prompt = {'ymin','ymax'};
    def   = {'-6','6'};
    num_lines= 1;
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    if isempty(answer)
        ShowWarning(0,'no property change',handles)
        return
    end
    Ylimit4Browser(1,1)=str2num(answer{1});
    Ylimit4Browser(1,2)=str2num(answer{2});
    subplot(handles.aBrowser)
    [X, map]=imread('russian.jpg');
    image(X)
    colormap(map)
    axis image
    axis off
end




% --- Executes on button press in CurrentShot.
function CurrentShot_Callback(hObject, eventdata, handles)
%this control is not text, but button
LastestShot=GetLastestShot;
if strmatch(get(handles.ShotNumber,'style'),'edit')
    set(handles.ShotNumber,'String',num2str(LastestShot));
else
    LastestShots=LastestShot:-1:LastestShot-300;
    set(handles.ShotNumber,'String',{num2str(LastestShots')});
    set(handles.ShotNumber,'value',1);
end
ShotOK_Callback(handles.ShotNumber, eventdata, handles)



% --- Executes on key press with focus on ShotOK and none of its controls.
function ShotOK_KeyPressFcn(hObject, eventdata, handles)
ShotOK_Callback(handles.ShotNumber, eventdata, handles)



% --- Executes on key press with focus on DP or any of its controls.
function DP_WindowKeyPressFcn(hObject, eventdata, handles)
k=get(handles.DP,'currentkey');
if strmatch(k,'f6','exact')
    myFun=get(handles.aBrowser,'ButtonDownFcn');
    if isempty(myFun)
        set(handles.aBrowser,'ButtonDownFcn',{@myButtonDownFcn,handles});
    end
end

% --- Executes on mouse press over axes background.
function myButtonDownFcn(hObject, eventdata, handles)



point1 = get(handles.aBrowser,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(handles.aBrowser,'CurrentPoint');    % button up detected
point1 = point1(1,1:2);              % extract x and y
point2 = point2(1,1:2);
p1 = min(point1,point2);             % calculate locations


if point1(1)<point2(1)
    xLim=[point1(1) point2(1)];
    yLim=[min(point1(2), point2(2)),max(point1(2), point2(2))];
else
    lBrowser=getappdata(handles.aBrowser,'lBrowser');
    if isempty(lBrowser)
        return
    end
    xLim=getappdata(handles.aBrowser,'myXLim');
    yLim=getappdata(handles.aBrowser,'myYLim');
    
end
try
    % set(handles.aBrowser,'XLim',xLim)
    set(handles.aBrowser,'YLim',yLim)
    [L,S,R]=gettheXTick(xLim(1),xLim(2));
    xLim=[L R];
    set(handles.aBrowser,'XLim',xLim,'XTick',[L:S:R],'TickDir', 'in');
catch e
end

% --------------------------------------------------------------------
function LocalFile_ClickedCallback(hObject, eventdata, handles)
global   MyPicStruct
setappdata(0,'machine','localdas')
set(handles.AccessMode,'UserData',1);%local data
if isempty(MyPicStruct)
    MyPicStruct=MyPicInit;%init by file data
end
Struct2View(handles);
OpenF_Callback(handles.OpenF, eventdata, handles)



% --------------------------------------------------------------------
function InputMode_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to InputMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function InputMode_OffCallback(hObject, eventdata, handles)
set(handles.otherPanel,'visible','off')
ResizeDataProc4(handles)
return
global MyPicStruct Lstring Rstring Sstring Astring
Lstring=get(handles.xLeft,'string');
Rstring=get(handles.xRight,'string');
Astring=get(handles.AddCurve,'string');

set(handles.xLeft,'string',num2str(MyPicStruct.xleft));
set(handles.xRight,'string',num2str(MyPicStruct.xright));
set(handles.xLeft,'style','edit');
set(handles.xRight,'style','edit');
MyShot=get(handles.ShotNumber,'String');
if ~isempty(MyShot) && iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end
strAddCurve=get(handles.AddCurve,'String');
if ~isempty(strAddCurve) && iscell(strAddCurve)
    strAddCurve=strAddCurve{get(handles.AddCurve,'value')};
end
set(handles.ShotNumber,'style','edit');
set(handles.ShotNumber,'string',MyShot);
set(handles.AddCurve,'style','edit');
set(handles.AddCurve,'string',strAddCurve);

% --------------------------------------------------------------------
function InputMode_OnCallback(hObject, eventdata, handles)
ResizeDataProc(handles)
return

global MyPicStruct Lstring Rstring Sstring Astring
set(handles.xLeft,'style','popupmenu');
set(handles.xRight,'style','popupmenu');
set(handles.ShotNumber,'style','popupmenu');
set(handles.AddCurve,'style','popupmenu');
LastestShot=GetLastestShot;
if strmatch(get(handles.ShotNumber,'style'),'edit')
    set(handles.ShotNumber,'String',num2str(LastestShot));
else
    LastestShots=LastestShot:-1:LastestShot-300;
    set(handles.ShotNumber,'String',{num2str(LastestShots')});
    set(handles.ShotNumber,'value',1);
end

Lstring{1}=num2str(MyPicStruct.xleft);
Rstring{1}=num2str(MyPicStruct.xright);
set(handles.xLeft,'value',1);
set(handles.xRight,'value',1);
set(handles.xLeft,'string',Lstring);
set(handles.xRight,'string',Rstring);
set(handles.AddCurve,'string',Astring);



% --------------------------------------------------------------------
function changeAxisSize_OffCallback(hObject, eventdata, handles)
ResizeDataProc2(handles)

% --------------------------------------------------------------------
function changeAxisSize_OnCallback(hObject, eventdata, handles)
ResizeDataProc1(handles)


% --------------------------------------------------------------------
function customZoom_ClickedCallback(hObject, eventdata, handles)
myFun=get(handles.aBrowser,'ButtonDownFcn');
if isempty(myFun)
    set(handles.aBrowser,'ButtonDownFcn',{@myButtonDownFcn,handles});
end


% --------------------------------------------------------------------
function showOther_OffCallback(hObject, eventdata, handles)
set(handles.otherPanel,'visible','off')
ResizeDataProc(handles)

% --------------------------------------------------------------------
function showOther_OnCallback(hObject, eventdata, handles)
ResizeDataProc5(handles)
set(handles.otherPanel,'visible','on')




% --- Executes on mouse motion over figure - except title and menu.
function DP_WindowButtonMotionFcn(hObject, eventdata, handles)
persistent  eventInTime eventOutTime isInState isOutState
responseDelay=1; %in second
cP=get(hObject,'CurrentPoint');
currentTime=clock;
pDrawCurves=get(handles.aBrowser,'position');
if cP(1)>pDrawCurves(1) && cP(1)<pDrawCurves(1)+pDrawCurves(3) && cP(2)>pDrawCurves(2) && cP(2)<pDrawCurves(2)+pDrawCurves(4)
    if isempty(eventInTime)
        eventInTime=currentTime(6); %the 6 element is second
        eventOutTime=[];
        isInState=1;
    end
    if isInState && (currentTime(6)-eventInTime>responseDelay)
        ResizeDataProc1(handles)
        isInState=0;
    end
    
else
    if isempty(eventOutTime)
        eventOutTime=currentTime(6); %the 6 element is second
        eventInTime=[];
        isOutState=1;
    end
    if isOutState && (currentTime(6)-eventOutTime>responseDelay)
        ResizeDataProc2(handles)
        isOutState=0;
    end
end


% --------------------------------------------------------------------
function AddButton_Callback(hObject, eventdata, handles)
%add button in toolbar for you own function
if ispc
    mytok =[char(13) char(10)];
elseif isunix
    mytok =[char(10)];
end

MyPath= which('DP');
initializationFile= [MyPath(1:end-4) 'initialization.m'];
fid = fopen(initializationFile,'a+');

myCommand=['tbh = findall(handles.DP,''Type'',''uitoolbar'');'];
eval(myCommand);
fwrite(fid,myCommand,'char');
fwrite(fid,mytok,'char');

%input the function name
dlg_title = 'input your function name';
prompt = {'function'};
def   = {'DrawCurves_Callback'};
num_lines= 1;
myFunction  = inputdlg(prompt,dlg_title,num_lines,def);

myCommand=['pth=uipushtool(tbh,''CData'',rand(20,20,3),''Separator'',''on'',''HandleVisibility'',''off'',''TooltipString'',''' myFunction{1} ''', ''ClickedCallback'',{@' myFunction{1} ',handles});'];
eval(myCommand);
fwrite(fid,myCommand,'char');
fwrite(fid,mytok,'char');

status = fclose('all');
return


% --------------------------------------------------------------------
function scanTree4Channels_Callback(hObject, eventdata, handles)
%% for das = setSystem

machine=getappdata(0,'machine');
switch machine
    case {'exl50','east'}
        
        
        sShots=get(handles.ShotNumber,'String');
        if iscell(sShots)
            CurrentShot=str2num(sShots{get(handles.ShotNumber,'value')});
        else
            CurrentShot=str2num(sShots);
        end
        
        machine=getappdata(0,'machine');
        sct(machine,CurrentShot)
    case {'hl2a', 'localdas','hl2m'}
        sShots=get(handles.ShotNumber,'String');
        if iscell(sShots)
            CurrentShot=str2num(sShots{get(handles.ShotNumber,'value')});
        else
            CurrentShot=str2num(sShots);
        end
        y=setSystemName(CurrentShot,1);
end
return


function    ShowDefaultChannel(CurrentShot,handles)
try
    defaultChannel=getappdata(0,'defaultChannel');
    machine=getappdata(0,'machine');
    switch machine
        case 'east'
            if isempty(defaultChannel)
                defaultChannel='pcrl01';
            end
            defaultChannel=regexp(defaultChannel,'\w*$','match','once');
            [y,x]=eastdb(CurrentShot,defaultChannel);
            
        case 'exl50'
            if isempty(defaultChannel)
                defaultChannel='IP';
                setappdata(0,'defaultChannel',defaultChannel);
            end
            defaultChannel=regexp(defaultChannel,'\w*$','match','once');
            [y,x]=exl50db(CurrentShot,defaultChannel);
        otherwise
            if isempty(defaultChannel)
                defaultChannel='ip';
                setappdata(0,'defaultChannel',defaultChannel);
            end
            defaultChannel=regexp(defaultChannel,'\w*$','match','once');
            [y,x]=hl2adb(CurrentShot,defaultChannel);
    end
    setappdata(0,'defaultChannel',defaultChannel);
    
    
    
    
    
    if isempty(x)  || ischar(x)
        set(handles.lbWarning,'String','no data in the node!')
        
        
    else
        
        lBrowser=plot(handles.aBrowser,x,y,'Color','b');
        
        setappdata(handles.aBrowser,'lBrowser',lBrowser)
        set(handles.aBrowser,'XColor','g','YColor','g','XGrid','on','YGrid','on');
        set(handles.aBrowser,'XLim',[min(x) max(x)+1]);
        
        %     set(handles.aBrowser,'YLim',[min(y) max(y)+1]);
        
        myYLim=get(handles.aBrowser,'YLim');
        setappdata(handles.aBrowser,'myYLim',myYLim)
        myXLim=get(handles.aBrowser,'XLim');
        setappdata(handles.aBrowser,'myXLim',myXLim)
    end
    set(handles.aBrowser,'ButtonDownFcn',{@myButtonDownFcn,handles});
    
catch
end
if ~isempty(getappdata(0,'MyErr'))
    ShowWarning(1,[],handles);
end


% --------------------------------------------------------------------
function toggleEditPopup_Callback(hObject, eventdata, handles)
R1_Callback([], [], handles)


% --------------------------------------------------------------------
function changeMachine_Callback(hObject, eventdata, handles)
machine=changeDriver;
switch machine
    case 'east'
        set(handles.ShotNumber,'String','33038');
    case 'exl50'
        set(handles.ShotNumber,'String','20066');
end

set(handles.lbWarning,'String',['machine is ' machine])
set(handles.lbWarning,'value',1)

% --------------------------------------------------------------------
function ViewEFIT_ClickedCallback(hObject, eventdata, handles)
p2a
EF



% --------------------------------------------------------------------
function delFile_Callback(hObject, eventdata, handles)
del2Mfile


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function helpFirstPlasma_Callback(hObject, eventdata, handles)
doc shotLog
MyFile = which('shotlog');
web(MyFile)


function AddCurve_CreateFcn(hObject, eventdata, handles)
function lbCurves_CreateFcn(hObject, eventdata, handles)
function lbChannels_CreateFcn(hObject, eventdata, handles)
% --------------------------------------------------------------------
function GridMode_Callback(hObject, eventdata, handles)
global MyPicStruct Lines2Axes
dlg_title = 'Set Axes Layout';
prompt = {'Row Number','Column Number'};
def   = {num2str(MyPicStruct.RowNumber),num2str(MyPicStruct.ColumnNumber)};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
MyPicStruct.RowNumber=str2num(answer{1});
MyPicStruct.ColumnNumber=str2num(answer{2});
Lines2Axes=[];  % initialization


% --- Executes during object creation, after setting all properties.
function LayoutMode_CreateFcn(hObject, eventdata, handles)




