function s=ShowNextShot(hObject, eventdata,handles)
MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
    if get(handles.ShotNumber,'value')==1
        CurrentShot=str2num(MyShot);
        CurrentShot=CurrentShot+1;
        myShotNumber=get(handles.ShotNumber,'String');
        myShotNumber(2:end+1)=myShotNumber(1:end);
        myShotNumber{1}=num2str(CurrentShot);
        set(handles.ShotNumber,'String',myShotNumber);
    else
        set(handles.ShotNumber,'value',get(handles.ShotNumber,'value')-1)
    end
else
    CurrentShot=str2num(MyShot);
    CurrentShot=CurrentShot+1;%next shot
    set(handles.ShotNumber,'String',num2str(CurrentShot))
end
 UpdateShot_Callback([], [], handles)
 s=1;