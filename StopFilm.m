function StopFilm(hObject, eventdata, hfig)
setappdata(hfig,'stopstatus',1);
set(hObject,'Enable','off');
set(get(hObject,'UserData'),'Enable','on');
