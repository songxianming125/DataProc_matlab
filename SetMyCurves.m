function     s=SetMyCurves(MyCurveList)
global  handles MyCurves
if isempty(handles)
    SetTheHandles;
end


if ~isempty(MyCurves)
%     set(handles.lbCurves,'UserData',MyCurves);
end
if ~isempty(MyCurveList)
    set(handles.lbCurves,'String',MyCurveList);
    set(handles.lbCurves,'Value',length(MyCurves));%
    set(handles.lbCurves,'ForegroundColor','b');
    set(handles.DrawCurves,'Enable','on');
    set(handles.UpdateShot,'Enable','on');
    set(handles.ShotTogether,'Enable','on');
end
s=0;
return



