function s=myShowMenu(hObject,eventdata,handles)

global hfig MyPicStruct
if strmatch(get(hObject,'Checked'),'on')
    MyPicStruct.ShowMenu=0;
    set(hfig,'MenuBar','none');
    set(hObject,'Checked','off');
elseif strmatch(get(hObject,'Checked'),'off')
    set(hfig,'MenuBar','figure');
    set(hObject,'Checked','on');
    MyPicStruct.ShowMenu=1;
end

s=0;
