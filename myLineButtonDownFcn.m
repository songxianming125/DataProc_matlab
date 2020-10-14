function myLineButtonDownFcn(hLine1, eventdata, hfig)
global  Lines2Axes Axes2Lines Axes2Loc Loc2Axes HeightNumber MyPicStruct PicDescription MyCurves LocationLeftRight
global hLines handles
k=get(hfig,'currentkey');
if strmatch(k,'f6','exact')
    hmyLine=gco;
    LineIndex=find(hLines==hmyLine);
    ha=getappdata(hfig,'hAxis');
    haxes1=gca;
    AxisIndex1=find(ha==haxes1);
    Location1=Axes2Loc(AxisIndex1);
    StartPoint=get(hfig,'CurrentPoint');
    [x,y] = ginput(1);
    haxes2=gca;
    AxisIndex2=find(ha==haxes2);
    Location2=Axes2Loc(AxisIndex2);
    
%     xLim=get(haxes1,'XLim');
%     if x>(xLim(1)+xLim(2))/2
%         PicDescription(LineIndex).Right=1;
%     else
%         PicDescription(LineIndex).Right=0;
%     end
    if Location2==Location1
    else
        PicDescription(LineIndex).Location=Location2;
    end
    set(hmyLine,'Parent',haxes2);
    hx=get(haxes1,'children');
    if isempty(hx)
        delete(haxes1)
    else
        axes(haxes1)
        legend('off')
        legend('toggle')
        legend('boxoff')
    end
    axes(haxes2)
    legend('off')
    legend('toggle')
    legend('boxoff')
    
    
    
    
    MyPicStruct.Modified=0;
%     DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
%     drawnow;
end
