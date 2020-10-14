function myXTickLabelTitle(handles)
%figure position
global  MyPicStruct  HeightNumber Loc2Axes Axes2Loc ha 


indexLoc=Axes2Loc(:);
firstLoc=min(indexLoc);
firstAxes=cell2mat(Loc2Axes(firstLoc));

if ~isempty(MyPicStruct.PicTitle)
    myTitle=strrep(MyPicStruct.PicTitle,'_','\_');
else
    myTitle=[];
end

hTitle=get(ha(firstAxes(1)),'Title');
set(hTitle,'String',myTitle,'Color',MyPicStruct.XColor,'Units','pixels')



lastLoc=max(indexLoc);
lastAxes=cell2mat(Loc2Axes(lastLoc));
if strcmp(MyPicStruct.timeUnit,'ms')
    set(get(ha(lastAxes(1)),'XLabel'),'String','Time(ms)','Color',MyPicStruct.XColor)
elseif strcmp(MyPicStruct.timeUnit,'s')
    set(get(ha(lastAxes(1)),'XLabel'),'String','Time(s)','Color',MyPicStruct.XColor)
end




% tx=toc
return
