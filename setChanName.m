function setChanName(hObject, eventdata, handles)


hcfg=getappdata(0,'hcfg');
hCurves=hcfg.hCurves;
index=get(hObject,'value');
ChanLists=get(hObject,'string');
ChanName=ChanLists{index};


%% get the channel name
currentCurveIndex=getappdata(0,'currentCurveIndex');
hChanName=hCurves(currentCurveIndex,3);

set(hChanName,'String',ChanName);
