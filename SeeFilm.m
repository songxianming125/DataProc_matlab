function SeeFilm(hObject, eventdata, hfig)
set(get(hObject,'UserData'),'Enable','on');
set(hObject,'Enable','off');
MyPicStruct=getappdata(0,'MyPicStruct');
if isempty(MyPicStruct)
    MyPicStruct=MyPicInit;%init by file data
end

[x1,x2]=getXLimit(hfig);
dx=abs(x2-x1);
DX=(MyPicStruct.xright-MyPicStruct.xleft)/20;
if dx<DX/5
    dx=DX;
elseif dx>DX*5
    dx=DX;
end
dx=floor(dx/5)*10;
x1=min(x1,x2);
x1=floor(x1);
x2=x1+dx;
setappdata(hfig,'stopstatus',0);
UpdatePicture(hfig,x1,x2);

