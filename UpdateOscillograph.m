function UpdateOscillograph(hObject)
global YLeftorRight Lines2Axes Axes2Lines Axes2Loc Loc2Axes HeightNumber MyPicStruct PicDescription MyCurves LocationLeftRight
global hLines handles

ha=getappdata(hObject,'hAxis');
[BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
if MyPicStruct.Oscillograph==1;  %display Oscillograph
    hOscillograph=getappdata(hObject,'hOscillograph');
    %Displaying X
    mytext=[];
    xLim=get(ha(1),'XLim');
    hX1=findobj(hObject,'Type','axes','Tag','hShadow1');
    axesLBWH=get(hX1,'position');%get the size of the axes
    X1=xLim(1)+(xLim(2)-xLim(1))*(axesLBWH(1)-BkLeft)/BkWidth;
    hX2=findobj(hObject,'Type','axes','Tag','hShadow2');
    axesLBWH=get(hX2,'position');%get the size of the axes
    X2=xLim(1)+(xLim(2)-xLim(1))*(axesLBWH(1)-BkLeft)/BkWidth;
    set(hOscillograph(1),'String',num2str(X1));
    set(hOscillograph(2),'String',num2str(X2));
    set(hOscillograph(3),'String',num2str(X2-X1));
    %Displaying Y
    %init Displaying y
    for i=4:9
        set(hOscillograph(i),'String','NAN');
    end


    hY1=findobj(hObject,'Type','axes','Tag','hHorizontal3');
    axesLBWH=get(hY1,'position');%get the size of the axes
    Yp1=axesLBWH(2);%pixel
    hY2=findobj(hObject,'Type','axes','Tag','hHorizontal4');
    axesLBWH=get(hY2,'position');%get the size of the axes
    Yp2=axesLBWH(2);%pixel

    NTotal=sum(HeightNumber);
    HeightUnit=BkHeight/NTotal;

    [P1,L1,P2,L2]=getPositionLocation(hObject,Yp1,Yp2);

    AxesIndex1=Loc2Axes{L1};
    AxesIndex2=Loc2Axes{L2};
    %Axes2Lines
    
    if isempty(YLeftorRight)
        YLeftorRight=0;
%     elseif YLeftorRight=0
%         YLeftorRight=1;
%     elseif YLeftorRight=1
%         YLeftorRight=0;
    end
    
    if L1==L2
%         for i=1:length(AxesIndex1)

            if YLeftorRight==0
                i=1;
            elseif YLeftorRight==1
                i=length(AxesIndex1);
            end
            yLim=get(ha(AxesIndex1(i)),'YLim');
            Y1=yLim(1)+(yLim(2)-yLim(1))*(Yp1-P1*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L1));
            Y2=yLim(1)+(yLim(2)-yLim(1))*(Yp2-P2*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L2));
            LineIndex=Axes2Lines{AxesIndex1(i)};
            set(hOscillograph(6+PicDescription(LineIndex(1)).Right*3),'String',num2str(Y2-Y1));
            set(hOscillograph(4+PicDescription(LineIndex(1)).Right*3),'String',num2str(Y1));
            set(hOscillograph(5+PicDescription(LineIndex(1)).Right*3),'String',num2str(Y2));
            mytext={['x=',num2str(X1)];['y',num2str(i),'=',num2str(Y1)];['dx=',num2str(X2-X1)];['dy=',num2str(Y2-Y1)]};
%         end

    else

        for i=1:length(AxesIndex1)
            yLim=get(ha(AxesIndex1(i)),'YLim');
            Y1=yLim(1)+(yLim(2)-yLim(1))*(Yp1-P1*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L1));
            LineIndex=Axes2Lines{AxesIndex1(i)};
            set(hOscillograph(4+PicDescription(LineIndex(1)).Right*3),'String',num2str(Y1));
        end

%         for i=1:length(AxesIndex2)
            if YLeftorRight==0
                i=1;
            elseif YLeftorRight==1
                i=length(AxesIndex1);
            end
            yLim=get(ha(AxesIndex2(i)),'YLim');
            Y2=yLim(1)+(yLim(2)-yLim(1))*(Yp2-P2*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L2));
            LineIndex=Axes2Lines{AxesIndex2(i)};
            set(hOscillograph(5+PicDescription(LineIndex(1)).Right*3),'String',num2str(Y2));
%         end
        mytext={['x=',num2str(X1)];['y',num2str(i),'=',num2str(Y1)];['dx=',num2str(X2-X1)]};
    end
    htext=getappdata(0,'htext');
    if isempty(htext) || ~ishandle(htext)
        return
    else
        figLBWH=get(hObject,'position');%get the size of the picture
        CurrentPoint=get(hObject,'CurrentPoint');
        set(htext,'string',mytext,'Position',[CurrentPoint(1)/figLBWH(3) CurrentPoint(2)/figLBWH(4) 0.1 0.1])
    end
end
%--------------------------------------------------------------------------

return
