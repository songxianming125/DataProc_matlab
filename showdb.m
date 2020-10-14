function showdb(hObject, eventdata, handles)
newMyPicStruct=View2Struct(handles);
MyShot1=get(handles.ShotNumber,'String');
if iscell(MyShot1)
    MyShot1=MyShot1{get(handles.ShotNumber,'value')};
end
CurrentShot=str2num(MyShot1);

%input the function name
dlg_title = 'input your pattern for channel and the system';
prompt = {'pattern','system'};
% def   = {'ep[a-z]?[0-9][0-9]','EPC','EPD','1'};
def   = {'_.*.*_','vax'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);

if isempty(answer)
    return
end

CurrentChannel=answer{1};
CurrentSysName=answer{2};



[y,t,s,u,chanLists]=hl2adb(CurrentShot,CurrentChannel,CurrentSysName);


title=[num2str(CurrentShot) ':total channels' num2str(length(chanLists))];
axesNum=6;
numChannels=length(chanLists);
numTimes=length(t);
handleBrowser.tLimit=[t(1) t(end)];
handleBrowser.t=num2cell(repmat(t,[1 numChannels]),1);  %  vectors
handleBrowser.y=num2cell(y,1);  %   vectors
handleBrowser.u=u;  %   vectors
handleBrowser.yLabel=chanLists;  % vectors
handleBrowser.axesNum=axesNum;  % vectors
handleBrowser.numChannels=numChannels;  % vectors
handleBrowser.numTimes=numTimes;  % vectors

handleBrowser.title=title;  % vectors


hBrowser=showData(handleBrowser);
return


