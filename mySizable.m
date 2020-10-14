function s=mySizable(hObject, eventdata,handles);
global hfig
if strmatch(get(hObject,'Checked'),'on')
    set(hfig,'resize','off');
    set(hObject,'Checked','off');
elseif strmatch(get(hObject,'Checked'),'off')
    set(hfig,'resize','on');
    set(hObject,'Checked','on');
end

s=0;

