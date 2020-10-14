function showDef(hObject, eventdata, handles)


hcfg=getappdata(0,'hcfg');
hCurves=hcfg.hCurves;
hPopup= hcfg.hPopup;

%hfig=hcfg.hfig;

%% get the channel name

index=find(hCurves(:,3)==hObject);
setappdata(0,'currentCurveIndex',index);



hChanName=hCurves(index,3);
channelPattern=get(hChanName,'String');

channels = getChannelsFromPattern( channelPattern);

set(hPopup,'string',channels)
set(hPopup,'value',1)
uicontrol(hPopup)  % get focus
