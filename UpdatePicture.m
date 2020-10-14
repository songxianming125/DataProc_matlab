function UpdatePicture(hObject,x1,x2);
global MyPicStruct PicDescription MyCurves hLines
global  Lines2Axes Axes2Lines Axes2Loc Loc2Axes HeightNumber MyPicStruct PicDescription MyCurves

[BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
AxesPower=getappdata(hObject,'AxesPower');
ha=getappdata(hObject,'hAxis');
NTotal=sum(HeightNumber);
HeightUnit=BkHeight/(sum(HeightNumber));
hLabel=getappdata(hObject,'hLabel');

if ~isempty(ha)
    tstep=floor((MyPicStruct.xright-MyPicStruct.xleft)/500);
    X1=x1;
    X2=x2;
    while X2<MyPicStruct.xright

        if ~isempty(hLabel)
            VerticalWidth=BkWidth*(MyPicStruct.Backgroundwidth)/(MyPicStruct.xright-MyPicStruct.xleft);
            CurrentPosition=[BkLeft BkBottom VerticalWidth BkHeight];

            set(hLabel(1),'Position',CurrentPosition);
            setappdata(hLabel(1),'Step',MyPicStruct.xStep);
            setappdata(hLabel(1),'t',BkLeft);
            CurrentPosition=[BkLeft+BkWidth BkBottom VerticalWidth BkHeight];
            set(hLabel(2),'Position',CurrentPosition);
            setappdata(hLabel(2),'Step',MyPicStruct.xStep);
            setappdata(hLabel(2),'t',BkLeft);
            HorizontalHeight=MyPicStruct.Backgroundheight;
            CurrentPosition=[BkLeft BkBottom BkWidth HorizontalHeight];

            set(hLabel(3),'Position',CurrentPosition);
            setappdata(hLabel(3),'Step',BkHeight/NTotal);
            setappdata(hLabel(3),'t',BkBottom);
            CurrentPosition=[BkLeft BkBottom+BkHeight BkWidth HorizontalHeight];
            set(hLabel(4),'Position',CurrentPosition);
            setappdata(hLabel(4),'Step',BkHeight/NTotal);
            setappdata(hLabel(4),'t',BkBottom);
        end % ~isempty(hLabel)
        UpdateOscillograph(hObject)
        if MyPicStruct.YLimitAuto==1
            UpdataY(hObject,X1,X2);
        end
        SetXYLimitTick(X1,X2,hObject);
        drawnow
        %myDelay(1);
        X1=X1+tstep;
        X2=X2+tstep;

        if X2>=MyPicStruct.xright
            %MyPicStruct1=MyPicInit;%init by file data
            %X1=MyPicStruct1.xleft;
            X1=MyPicStruct.xleft;
            X2=x1+tstep;
        end

        stopstatus=getappdata(hObject,'stopstatus');
        if ~isempty(stopstatus)
            if stopstatus==1
                return
            end
        end
        %myDelay(0.05);
    end %while
end%~isempty(ha)


