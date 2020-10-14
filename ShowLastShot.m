function s=ShowLastShot(hObject, eventdata,handles)
MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
    set(handles.ShotNumber,'value',get(handles.ShotNumber,'value')+1)
else
    CurrentShot=str2num(MyShot);
    CurrentShot=CurrentShot-1;%next shot
    set(handles.ShotNumber,'String',num2str(CurrentShot))
end
 UpdateShot_Callback([], [], handles)
 s=1;

