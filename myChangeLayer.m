function s=myChangeLayer(hObject, eventdata,handles);

global hfig
ha=getappdata(hfig,'ha');
for i=1:length(ha);
    hLines=get(ha(i),'Children');
    hLines=flipud(hLines);
    set(ha(i),'Children',hLines);
end




if strmatch(get(hObject,'Checked'),'on')
    set(hObject,'Checked','off');
elseif strmatch(get(hObject,'Checked'),'off')
    set(hObject,'Checked','on');
end
% haxes=get(hfig,'Children');
haxes=allchild(hfig);


% haxes=[flipud(haxes(1:end-1));haxes(end)];%keep the last one the same
haxes=flipud(haxes);%keep the last one the same
set(hfig,'Children',haxes);
s=0;

