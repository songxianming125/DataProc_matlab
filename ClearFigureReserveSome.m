function    ClearFigureReserveSome
%songxm 2008/1/12
global  MyPicStruct hfig bInitSize
hfigs=findobj('type','figure');
name=get(hfigs,'Tag');
if isempty(MyPicStruct)
    MyPicStruct=MyPicInit;%init by file data
end

%you can reserve some figures in you MyPicInit file
index=[];
ReservedNames=MyPicStruct.ReservedFigureNames(:);
for i=1:length(ReservedNames)
    index=[index strmatch(ReservedNames(i),name,'exact')];
end

indexsongxm=strmatch('songxm',name,'exact');
if  ~isempty(indexsongxm) && indexsongxm
    hfig=hfigs(indexsongxm);
    figure(hfig);
    clf;
    set(hfig,'Visible','on');
else
%     %create the figure
%     bInitSize=[];
%     hfig=figure('Color',MyPicStruct.PicBackgroundColor,'Visible','off','Tag','songxm');
%     set(hfig,'DefaultTextFontWeight',MyPicStruct.DefaultTextFontWeight,'DefaultTextFontSize',MyPicStruct.DefaultTextFontSize,...
%         'DefaultAxesFontWeight',MyPicStruct.DefaultAxesFontWeight,...
%         'DefaultAxesFontSize',MyPicStruct.DefaultAxesFontSize,'DefaultAxesLineWidth',MyPicStruct.DefaultAxesLineWidth);%,...
end
if ~isempty(index)
    hfigs(index)=[];%reserve the possible two important figure
end
delete(hfigs)%delete other figures
end
