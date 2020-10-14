function varargout = EF(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EF_OpeningFcn, ...
                   'gui_OutputFcn',  @EF_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before EF is made visible.
function EF_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% add a line
x=[0.5148 0.5148];
y=[0.1475 0.6620];
handles.hTimeLine=annotation(handles.EF,'line',x,y,'Color', 'k','LineWidth',3);%,'EraseMode ','xor','BackgroundColor','w')
setappdata(handles.EF,'SavedVisible','off');
set(handles.EF,'DeleteFcn',{@myExit,handles});
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EF wait for user response (see UIRESUME)
% uiwait(handles.EF);
function myExit(hObject, eventdata, handles)
global  efitServer
if exist(efitServer,'dir')==7
    myExitCode=strcat('net use',char(31),efitServer,char(31),'/delete');
    myExitCode=strrep(myExitCode,char(31),char(32));
    dos(myExitCode);
end
clear all

% --- Outputs from this function are returned to the command line.
function varargout = EF_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
set(handles.EF,'visible','off')
set(handles.EF,'position',[0 0 1 1])

LastestShot=GetLastestShot;
set(handles.ShotNumber,'String',num2str(LastestShot))
gFit=globalFit;




% ResizeEF(handles);
hPlasma=handles.Shape;
axes(hPlasma)
p=DrawBackground(gFit.limiterRadius,handles.EF);
%% zoom on
XLimOld=get(hPlasma,'XLim');
YLimOld=get(hPlasma,'YLim');

setappdata(0,'gFit',gFit)
setappdata(0,'Fit',[])
ResizeEF(handles);
updateAxes(handles)
% set(handles.EF,'MenuBar','figure');
pause(1)
% set(handles.EF,'visible','on')


% --- Executes on selection change in Start.
function Start_Callback(hObject, eventdata, handles)
updateAxes(handles)

function Start_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Step.
function Step_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Step_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Time_Callback(hObject, eventdata, handles)
set(handles.Time,'Enable','off')
xValue=get(hObject,'Value');
DisplayShape(xValue, handles)
pause(1)
set(handles.Time,'Enable','on')


% --- Executes during object creation, after setting all properties.
function Time_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in End.
function End_Callback(hObject, eventdata, handles)
updateAxes(handles)

function End_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CurrentShot.
function CurrentShot_Callback(hObject, eventdata, handles)
LastestShot=GetLastestShot;
set(handles.ShotNumber,'String',num2str(LastestShot))
ShotNumber_Callback(handles.ShotNumber, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CurrentShot_CreateFcn(hObject, eventdata, handles)

function ShotNumber_Callback(hObject, eventdata, handles)
% show the ready shot
CurrentShot=str2double(get(handles.ShotNumber,'String'));
efitDriver=getEfitDriver;
outFile=[efitDriver '\outFit'  '*.mat'];
dir_struct = dir(outFile);
[n,m]=size(dir_struct);
% [sorted_names,sorted_index] = sortrows({dir_struct.name}');
mylist={dir_struct.name};

mylist=regexp(mylist,'[\d]{5}','match','once');



% n=length(mylist);
% mylist=cell2mat(mylist);
% m=length(mylist)/n;
% mylist=reshape(mylist,[m n]);
% mylist=mylist(7:11,:);



mylist=mylist';
% mylist = mat2cell(mylist,[n 1]);
% mylist=regexp(mylist,'[\d]{5}','match');
% mylist=cellfun(mylist);
mylist=cellstr(mylist);
set(handles.Info,'String',mylist);
set(handles.Info,'Value',length(mylist));
setappdata(handles.ShotNumber,'isShotNumber',1)

% --- Executes during object creation, after setting all properties.
function ShotNumber_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function CurrentTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in RunEF.
function RunEF_Callback(hObject, eventdata, handles)
ShotNumber_Callback(handles.ShotNumber, eventdata, handles)

return
coreNum=8;
y=startPara(coreNum);

clearAll(handles)
CurrentShot=str2double(get(handles.ShotNumber,'String'));
efitSimulation(handles,CurrentShot);

% --- Executes on button press in plus.
function plus_Callback(hObject, eventdata, handles)
MyShot=get(handles.ShotNumber,'String');
CurrentShot=str2double(MyShot);
CurrentShot=CurrentShot+1;
set(handles.ShotNumber,'String',num2str(CurrentShot));
% --- Executes on button press in minus.
function minus_Callback(hObject, eventdata, handles)
MyShot=get(handles.ShotNumber,'String');
CurrentShot=str2double(MyShot);
CurrentShot=CurrentShot-1;
set(handles.ShotNumber,'String',num2str(CurrentShot));



function Limiter_Callback(hObject, eventdata, handles)
updateAxes(handles)
% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
setappdata(handles.ShotNumber,'isShotNumber',0)

clearAll(handles)
CurrentShot=str2double(get(handles.ShotNumber,'String'));
set(handles.Info,'String',['shot:' num2str(CurrentShot) ' is loading, please wait a few minutes!']);
set(handles.Info,'Value',1);
pause(1)

efitDriver=getEfitDriver;
outFile=[efitDriver '\outFit' num2str(CurrentShot) '.mat'];
if  exist(outFile,'file')==2   % 0 %
    load(outFile,'outFit')
    setappdata(0,'outFit',outFit)
    showCurve(handles)
    set(handles.Info,'String',['shot:' num2str(CurrentShot) ' is  ready!']);
    set(handles.Info,'Value',1);
    fbcTime=outFit.fbcTime;
    
    xStart=fbcTime(1);
    xEnd=fbcTime(end);
    
    
    xStep=str2double(get(handles.Step,'String'));
    xStep=xStep/(xEnd-xStart);
    

    
    set(handles.Start,'String',xStart);
    set(handles.End,'String',xEnd);
    set(handles.CurrentTime,'String',xStart);
    set(handles.Time,'Min',xStart,'Max',xEnd,'Value',xStart,'SliderStep',[xStep 10*xStep])
    
    set(handles.Ip,'XLIM',[xStart xEnd]);
    set(handles.RDh,'XLIM',[xStart xEnd]);
    set(handles.ZDv,'XLIM',[xStart xEnd]);
    linkaxes([handles.Ip handles.RDh handles.ZDv],'x')
    
    
    
    
else
    set(handles.Info,'String',['shot:' num2str(CurrentShot) ' is not ready!']);
    set(handles.Info,'Value',1);
end


function CurrentTime_Callback(hObject, eventdata, handles)
xValue=str2double(get(hObject,'String'));
DisplayShape(xValue, handles)

% --------------------------------------------------------------------
function ZoomShape_ClickedCallback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function ZoomShape_OnCallback(hObject, eventdata, handles)
gFit=getappdata(0,'gFit');
hPlasma=handles.Shape;
XLimOld=get(hPlasma,'XLim');
YLimOld=get(hPlasma,'YLim');
XLimNew=[1.1 2.1];
YLimNew=[-0.9 0.5];
%  XLimNew=[1.4 1.7];
%  YLimNew=[-0.7 -0.3];
nFrame=10;
for ii=1:nFrame
    set(hPlasma,'XLim',XLimOld+(XLimNew-XLimOld)*ii/nFrame,'YLim',YLimOld+(YLimNew-YLimOld)*ii/nFrame)
    if gFit.isMovie
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    pause(gFit.delay/100)
end


% --------------------------------------------------------------------
function ZoomShape_OffCallback(hObject, eventdata, handles)
gFit=getappdata(0,'gFit');

hPlasma=handles.Shape;
XLimOld=get(hPlasma,'XLim');
YLimOld=get(hPlasma,'YLim');
XLimNew=[0.8 2.6];
YLimNew=[-1.5 1.5];
%  XLimNew=[1.4 1.7];
%  YLimNew=[-0.7 -0.3];
nFrame=10;
for ii=1:nFrame
    set(hPlasma,'XLim',XLimOld+(XLimNew-XLimOld)*ii/nFrame,'YLim',YLimOld+(YLimNew-YLimOld)*ii/nFrame)
    if gFit.isMovie
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    pause(gFit.delay/100)
end


% --- Executes on selection change in Info.
function Info_Callback(hObject, eventdata, handles)
isShotNumber=getappdata(handles.ShotNumber,'isShotNumber');
if ~isempty(isShotNumber) && isShotNumber
    index=get(handles.Info,'value');
    strShotNumbers=get(handles.Info,'String');
    strShotNumber=strShotNumbers(index);
    if ~isempty(strShotNumber) && iscell(strShotNumber)
        num=str2num(strShotNumber{1});
        if ~isempty(num) && isnumeric(num)
            set(handles.ShotNumber,'String',strShotNumber)
            Load_Callback(handles.Load, eventdata, handles)
            pause(1)
        else
            
        end
    end
else
    set(handles.Info,'String',[])
end
setappdata(handles.ShotNumber,'isShotNumber',0)





% --- Executes during object creation, after setting all properties.
function Info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function DisplayShape(xValue, handles)
hisDraw=getappdata(0,'hisDraw');
if ~isempty(hisDraw) &&  sum( ishandle(hisDraw))>0
    for i=1:length(hisDraw)
        if ishandle(hisDraw(i))
            delete(hisDraw(i))
        end
    end
end
gFit=getappdata(0,'gFit');


xStart=str2double(get(handles.Start,'String'));
xEnd=str2double(get(handles.End,'String'));
xStep=str2double(get(handles.Step,'String'));
% xValue=get(hObject,'Value');
xValue=fix(xValue/xStep)*xStep;
set(handles.Time,'Value',xValue);
set(handles.CurrentTime,'String',xValue);

pIp=get(handles.Ip,'Position'); % position of axis Ip
pEF=get(handles.EF,'Position'); % position of axis Ip


pLeft=(xValue-xStart)/(xEnd-xStart)*pIp(3);

pTimeLine(1)=pIp(1)+pLeft;

hTimeLine=handles.hTimeLine;

x=[pTimeLine(1) pTimeLine(1)]/pEF(3);
set(hTimeLine,'X',x);

outFit=getappdata(0,'outFit');
outTime=outFit.outTime;
xStart=outTime(1);
indexTime=xValue-xStart+1; %should be integer
if indexTime>0
        C=outFit.C;
        C1=outFit.C1;
    if length(C)>=indexTime
        C=C{indexTime};
        C1=C1{indexTime};
        
        phiCenter=outFit.phiCenter;
        phiCenter=phiCenter(indexTime);
        if ~isempty(C)
            
            Dh1=((min(C(1,2:end))+max(C(1,2:end)))/2);
            Dv1=((min(C(2,2:end))+max(C(2,2:end)))/2);
            ap=(-min(C(1,2:end))+max(C(1,2:end)))/2;
            hisDraw(1)=plot(Dh1,Dv1,'+r');
            
            
            axes(handles.Shape)
            hisDraw(2)=plot(C(1,2:end),C(2,2:end),'b');
            C=C1;
            hNum=2;
            while size(C,2)>1
                C1=C(:,2:C(2,1)+1);
                hNum=hNum+1;
                hisDraw(hNum)=plot(C1(1,:),C1(2,:));
                C(:,1:C(2,1)+1)=[];
                if size(C1,2)<10  && C1(2,1)>-0.52
                    hNum=hNum+1;
                    hisDraw(hNum)=plot(C1(1,:),C1(2,:),'+b');
                end
                
            end
%             strRZIP=[' m: ap=' num2str(round(ap*100)/100) '/LCFS: R=' num2str(round(Dh1*100)/100) ' Z='  num2str(round(Dv1*100)/100)  '/Current: R=' num2str(round(X1(indexMax)*100)/100) ' Z=' num2str(round(Y1(indexMax)*100)/100) '@t=' num2str(xValue)];
%             strIex= ['kA: Ip=' num2str(round(Ip/100)/10) '/ Ioh=' num2str(round(Iex(1)/10)/100) '/ Iv=' num2str(round(Iex(2)/10)/100) '/ Ir=' num2str(round(Iex(3)/10)/100) '/ Imp1=' num2str(round(Iex(8)/10)/100) '/ Imp2=' num2str(round(Iex(9)/10)/100)];
            
%             WarningString=get(handles.Info,'String');
%             if ~isempty(WarningString) && iscell(WarningString)
%                 WarningString={WarningString{:},strRZIP,strIex};
%             else
%                 WarningString={WarningString,strRZIP,strIex};
%             end
%             set(handles.Info,'String',WarningString);
%             set(handles.Info,'Value',length(WarningString));
            setappdata(0,'hisDraw',hisDraw)
        end
    end
end
function updateAxes(handles)
clearAll(handles)
gFit=getappdata(0,'gFit');
gFit.limiterRadius=str2double(get(handles.Limiter,'String'));
xStart=str2double(get(handles.Start,'String'));
xEnd=str2double(get(handles.End,'String'));
xStep=str2double(get(handles.Step,'String'));
xStep=xStep/(xEnd-xStart);

set(handles.CurrentTime,'String',xStart);


set(handles.Time,'Min',xStart,'Max',xEnd,'Value',xStart,'SliderStep',[xStep 10*xStep])

set(handles.Ip,'XLIM',[xStart xEnd]);
set(handles.RDh,'XLIM',[xStart xEnd]);
set(handles.ZDv,'XLIM',[xStart xEnd]);
linkaxes([handles.Ip handles.RDh handles.ZDv],'x')
    hTimeLine=handles.hTimeLine;
    if  ishandle(hTimeLine)
        pIp=get(handles.Ip,'Position'); % position of axis Ip
        pEF=get(handles.EF,'Position'); % position of axis Ip
        pLeft=(xStart-xStart)/(xEnd-xStart)*pIp(3);
        pTimeLine(1)=pIp(1)+pLeft;
        x=[pTimeLine(1) pTimeLine(1)]/pEF(3);
        set(hTimeLine,'X',x);
    end
setappdata(0,'gFit',gFit);

function showCurve(handles)
% clearAll(handles)
% 
% outFit=getappdata(0,'outFit');
% Fit=outFit.Fit;
% setappdata(0,'Fit',Fit)
% fbcTime=outFit.fbcTime;
% fbcCurves=outFit.fbcCurves;
% 
% outDh=outFit.Dh;
% outDv=outFit.Dv;
% outIp=outFit.Ip;
% outTime=outFit.outTime;
% 
% 
% 
% cla(handles.RDh)
% cla(handles.ZDv)
% cla(handles.Ip)
% 
% % change from m to cm
% outDh=(outDh-1.65)*100;
% outDv=outDv*100;
% outIp=outIp/1000; % A->kA
% fbcCurves(:,1)=fbcCurves(:,1)*2;
% fbcCurves(:,2)=fbcCurves(:,2)*3;
% % fbcCurves(:,1)=fbcCurves(:,1);
% 
% 
% hRZIP(1)=line('Parent',handles.RDh,'XData',fbcTime,'YData',fbcCurves(:,1),'Marker','.','Color','k');
% hRZIP(2)=line('Parent',handles.ZDv,'XData',fbcTime,'YData',fbcCurves(:,2),'Marker','.','Color','k');
% hRZIP(3)=line('Parent',handles.Ip,'XData',fbcTime,'YData',fbcCurves(:,3),'Marker','.','Color','k');
% haxes(1)=line('Parent',handles.RDh,'XData',outTime,'YData',outDh,'Marker','.','Color','r');
% haxes(2)=line('Parent',handles.ZDv,'XData',outTime,'YData',outDv,'Marker','.','Color','r');
% haxes(3)=line('Parent',handles.Ip,'XData',outTime,'YData',outIp,'Marker','.','Color','r');
% 
% 
% RDhmax=max(max(fbcCurves(:,1)),max(outDh));
% RDhmin=min(min(fbcCurves(:,1)),min(outDh));
% RDvmax=max(max(fbcCurves(:,2)),max(outDv));
% RDvmin=min(min(fbcCurves(:,2)),min(outDv));
% Ipmax=max(max(fbcCurves(:,3)),max(outIp));
% Iphmin=min(min(fbcCurves(:,3)),min(outIp));
% 
% 
% set(handles.RDh,'YLim',[RDhmin RDhmax]);
% set(handles.ZDv,'YLim',[RDvmin RDvmax]);
% set(handles.Ip,'YLim',[Iphmin Ipmax]);
% 
% MyYTick(handles.RDh,3,2);
% MyYTick(handles.ZDv,3,2);
% MyYTick(handles.Ip,3,1);
% 
% set(handles.RDh,'XGrid','on','YGrid','on')
% set(handles.ZDv,'XGrid','on','YGrid','on')
% set(handles.Ip,'XGrid','on','YGrid','on')
% setappdata(0,'haxes',haxes)
% setappdata(0,'hRZIP',hRZIP)
% 
% 
% 
%     %%
%     
%     handleBrowser.tLimit=[fbcTime(1) fbcTime(end)];
%     handleBrowser.t=num2cell([repmat(fbcTime,[1 3]) repmat(outTime',[1 3])],1);  %  vectors
%     handleBrowser.y=num2cell([fbcCurves outDh' outDv' outIp'],1);  %   vectors
%     
%     
% %     handleBrowser.u={'cm' 'cm' 'kA' 'cm' 'cm' 'kA'};  %   vectors
% %     handleBrowser.yLabel={'dh' 'dv' 'Ip' 'dh' 'dv' 'Ip'};  % vectors
%     handleBrowser.u={'cm' 'cm' 'kA'};  %   vectors
%     handleBrowser.yLabel={'dh' 'dv' 'Ip'};  % vectors
%     
%     
%     handleBrowser.axesNum=6;  % vectors
%     handleBrowser.numChannels=3;  % vectors
%     handleBrowser.numTimes=length(fbcTime);  % vectors
%     handleBrowser.title='Dhv';  % vectors
%     
%     hBrowser=compareData(handleBrowser);

    %%
clearAll(handles)

outFit=getappdata(0,'outFit');
% Fit=outFit.Fit;
% setappdata(0,'Fit',Fit)
fbcTime=outFit.fbcTime;
fbcCurves=outFit.fbcCurves;

outDh=outFit.Dh;
outDv=outFit.Dv;
outIp=outFit.Ip;
outTime=outFit.outTime;



cla(handles.RDh)
cla(handles.ZDv)
cla(handles.Ip)

% change from m to cm
outDh=(outDh-1.65)*100;
outDv=outDv*100;
outIp=outIp/1000; % A->kA
fbcCurves(:,1)=fbcCurves(:,1)*2;
fbcCurves(:,2)=fbcCurves(:,2)*3;
% fbcCurves(:,1)=fbcCurves(:,1);


hRZIP(1)=line('Parent',handles.RDh,'XData',fbcTime,'YData',fbcCurves(:,1),'Marker','.','Color','k');
hRZIP(2)=line('Parent',handles.ZDv,'XData',fbcTime,'YData',fbcCurves(:,2),'Marker','.','Color','k');
hRZIP(3)=line('Parent',handles.Ip,'XData',fbcTime,'YData',fbcCurves(:,3),'Marker','.','Color','k');
haxes(1)=line('Parent',handles.RDh,'XData',outTime,'YData',outDh,'Marker','.','Color','r');
haxes(2)=line('Parent',handles.ZDv,'XData',outTime,'YData',outDv,'Marker','.','Color','r');
haxes(3)=line('Parent',handles.Ip,'XData',outTime,'YData',outIp,'Marker','.','Color','r');


RDhmax=max(max(fbcCurves(:,1)),max(outDh));
RDhmin=min(min(fbcCurves(:,1)),min(outDh));
RDvmax=max(max(fbcCurves(:,2)),max(outDv));
RDvmin=min(min(fbcCurves(:,2)),min(outDv));
Ipmax=max(max(fbcCurves(:,3)),max(outIp));
Iphmin=min(min(fbcCurves(:,3)),min(outIp));


set(handles.RDh,'YLim',[RDhmin RDhmax]);
set(handles.ZDv,'YLim',[RDvmin RDvmax]);
set(handles.Ip,'YLim',[Iphmin Ipmax]);

MyYTick(handles.RDh,3,2);
MyYTick(handles.ZDv,3,2);
MyYTick(handles.Ip,3,1);

set(handles.RDh,'XGrid','on','YGrid','on')
set(handles.ZDv,'XGrid','on','YGrid','on')
set(handles.Ip,'XGrid','on','YGrid','on')
setappdata(0,'haxes',haxes)
setappdata(0,'hRZIP',hRZIP)







function clearAll(handles)
% cla(handles.RDh)
% cla(handles.ZDv)
% cla(handles.Ip)

cla(handles.Shape)
axes(handles.Shape)


gFit=getappdata(0,'gFit');
p=DrawBackground(gFit.limiterRadius,handles.EF);


% --- Executes on button press in autoComp.
function autoComp_Callback(hObject, eventdata, handles)
%% change to databrowser
CurrentShot=str2double(get(handles.ShotNumber,'String'));

xStart=fix(str2double(get(handles.Start,'String')));
xEnd=fix(str2double(get(handles.End,'String')));
xStep=fix(str2double(get(handles.Step,'String')));
numData=(xEnd-xStart)+1;
%% prepare the the experiment data
gFit=getappdata(0,'gFit');
gFit=getExpDatas(CurrentShot,xStart,xEnd,gFit,0);  
%% figure and axis preparing
hBrowser=ShowRawData(CurrentShot,xStart,xEnd,gFit);





