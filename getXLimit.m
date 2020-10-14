function [x1,x2]=getXLimit(hObject);
x1=[];
x2=[];
[n,ha,MyPicStruct,hXLabel,PicDescription,HeightNumber,M,figLBWH,BkLeft,BkBottom,BkWidth,BkHeight]=getPicProperty(hObject);
if MyPicStruct.Oscillograph==1;  %display Oscillograph
        hOscillograph=getappdata(hObject,'hOscillograph');
        %Displaying X
        xLim=get(ha(1),'XLim');
        hX1=findobj(hObject,'Type','axes','Tag','hShadow1');
        axesLBWH=get(hX1,'position');%get the size of the axes
        x1=xLim(1)+(xLim(2)-xLim(1))*(axesLBWH(1)-BkLeft)/BkWidth;
        hX2=findobj(hObject,'Type','axes','Tag','hShadow2');
        axesLBWH=get(hX2,'position');%get the size of the axes
        x2=xLim(1)+(xLim(2)-xLim(1))*(axesLBWH(1)-BkLeft)/BkWidth;
end
