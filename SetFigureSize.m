function s=SetFigureSize(hObject, eventdata,handles);
global hfig MyPicStruct bInitSize
s=1;
FigPos=get(hfig,'Position');

dlg_title = 'Set Figure Size';
prompt = {'Enter the Figure Width (in pixels)','Enter the Figure Height (in pixels)','DefaultAxesLineWidth','DefaultTextFontSize',...
    'DefaultAxesFontSize','DefaultTextFontWeight','DefaultAxesFontWeight','myleft','mybottom','mywidth','myheight','PicTitle'};
def   = {num2str(FigPos(3)),num2str(FigPos(4)),num2str(MyPicStruct.DefaultAxesLineWidth),num2str(MyPicStruct.DefaultTextFontSize),...
    num2str(MyPicStruct.DefaultAxesFontSize),MyPicStruct.DefaultTextFontWeight,MyPicStruct.DefaultAxesFontWeight,num2str(MyPicStruct.myleft),num2str(MyPicStruct.mybottom),num2str(MyPicStruct.mywidth),num2str(MyPicStruct.myheight),MyPicStruct.PicTitle};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
myFigureWidth=str2num(answer{1});
myFigureHeight=str2num(answer{2});
MyPicStruct.FigureWidth=myFigureWidth;
MyPicStruct.FigureHeight=myFigureHeight;


MyPicStruct.DefaultAxesLineWidth=str2num(answer{3});
MyPicStruct.DefaultTextFontSize=str2num(answer{4});
MyPicStruct.DefaultAxesFontSize=str2num(answer{5});
MyPicStruct.DefaultTextFontWeight=answer{6};
MyPicStruct.DefaultAxesFontWeight=answer{7};
MyPicStruct.myleft=str2num(answer{8});
MyPicStruct.mybottom=str2num(answer{9});
MyPicStruct.mywidth=str2num(answer{10});
MyPicStruct.myheight=str2num(answer{11});
MyPicStruct.PicTitle=answer{12};


FigPos=get(hfig,'Position');
FigPos(3)=myFigureWidth;
FigPos(4)=myFigureHeight;

set(hfig,'Position',FigPos,'Visible','off');
ha=getappdata(hObject,'hAxis');
%set(ha,{'LineWidth'},{MyPicStruct.DefaultAxesLineWidth},{'FontSize'},{MyPicStruct.DefaultAxesFontSize},{'FontWeight'},{MyPicStruct.DefaultAxesFontWeight});




set(hfig,'DefaultTextFontWeight',MyPicStruct.DefaultTextFontWeight,'DefaultTextFontSize',MyPicStruct.DefaultTextFontSize,...
        'DefaultAxesFontWeight',MyPicStruct.DefaultAxesFontWeight,...
        'DefaultAxesFontSize',MyPicStruct.DefaultAxesFontSize,'DefaultAxesLineWidth',MyPicStruct.DefaultAxesLineWidth);%,...

bInitSize=1;
set(hfig,'Visible','on')
DrawCurves_Callback(hfig, eventdata, handles)
s=0;
return
