function UpdateShot_Callback(hObject, eventdata, handles)
global   MyCurves
MyCurves=[];
sMyCurveList=get(handles.lbCurves,'String');  % curves for more shot
if isempty(sMyCurveList)
    msgbox('no curves for update')
    return
end



sShots=get(handles.ShotNumber,'String');
if iscell(sShots)
    CurrentShot=str2num(sShots{get(handles.ShotNumber,'value')});
else
    CurrentShot=str2num(sShots);
end

% UpdateScreens(CurrentShot)
% return

setCurvesForShots(handles,CurrentShot)

DrawCurves_Callback(handles.DrawCurves, eventdata, handles)
% td=toc
% profile viewer

return



%%

