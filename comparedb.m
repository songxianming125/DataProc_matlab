function comparedb(hObject, eventdata,handles)
newMyPicStruct=View2Struct(handles);

MyShot1=get(handles.ShotNumber,'String');
if iscell(MyShot1)
    MyShot1=MyShot1{get(handles.ShotNumber,'value')};
end
CurrentShot1=str2num(MyShot1);

%input the function name
dlg_title = 'input your pattern for channel, the system and the shot';
prompt = {'pattern','system','shot'};
% def   = {'ep[a-z]?[0-9][0-9]','EPC','EPD','1'};
def   = {'_.*_','vax','24000'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    return
end


CurrentChannel=answer{1};
CurrentSysName=answer{2};
CurrentShot=str2double(answer{3});


[y,t,s,u,chanLists]=hl2adb(CurrentShot,CurrentChannel,CurrentSysName);
[y1,t1,s1,u1,chanLists1]=hl2adb(CurrentShot1,CurrentChannel,CurrentSysName);

numChannels=length(chanLists);


tMin=min(t(1),t1(1));
tMax=max(t(end),t1(end));
handleBrowser.tLimit=[tMin tMax];



handleBrowser.t=[num2cell(repmat(t,[1 numChannels]),1) num2cell(repmat(t1,[1 numChannels]),1)];  %  vectors

% group together


handleBrowser.y=[num2cell(y,1) num2cell(y1,1)];  %   vectors



title=[num2str(CurrentShot) ':' num2str(CurrentShot1)];
axesNum=6;
numTimes=length(t);


handleBrowser.u=u;  %   vectors
handleBrowser.yLabel=chanLists;  % vectors
handleBrowser.axesNum=axesNum;  % vectors
handleBrowser.numChannels=numChannels;  % vectors
handleBrowser.numTimes=numTimes;  % vectors
handleBrowser.title=title;  % vectors


hBrowser=compareData(handleBrowser);

