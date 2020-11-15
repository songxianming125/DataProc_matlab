function s= setLayout(ha,GapMode)
global MyPicStruct
s=1;
nAxis=length(ha);

if nAxis>6
    RowNumber=ceil(nAxis/2);
    ColumnNumber=2;
else
    RowNumber=nAxis;
    ColumnNumber=1;
end
if isempty(MyPicStruct)
    MyPicStruct=MyPicInit;
end

MyPicStruct.GapMode=GapMode;

HeightNumber=ones(RowNumber,1);
WidthNumber=ones(ColumnNumber,1);

[BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(gcf);

HeightUnit=BkHeight/sum(HeightNumber(:));
WidthUnit=BkWidth/sum(WidthNumber(:));
GapWidth=MyPicStruct.GapWidth;

if GapMode==0  %control the YTick mode song mode or conventional mode
    GapHeight=0; %control the gap height for conventional YTick mode
else
    GapHeight=MyPicStruct.GapHeight; %control the gap height for conventional YTick mode
end

CurrentAxes=nAxis;
for iC=1:ColumnNumber
    for iR=1:RowNumber
        if ~isempty(ha)
            Lnum=sum(HeightNumber(1:iR));
            Wnum=sum(WidthNumber(1:iC))-WidthNumber(iC);
            
            if (HeightNumber(iR)==0) || (WidthNumber(iC)==0)
                set(ha(CurrentAxes),'Position',[2000+BkLeft BkBottom+BkHeight-HeightUnit*Lnum WidthUnit HeightUnit]);%move out our sight
            else
                set(ha(CurrentAxes),'Position',[BkLeft+WidthUnit*Wnum BkBottom+BkHeight-HeightUnit*Lnum WidthUnit*WidthNumber(iC)-GapWidth HeightUnit*HeightNumber(iR)-GapHeight]);%set the size
            end
            
            CurrentAxes=CurrentAxes-1;

        end %~isempty(ha)
    end %for iC=1:ColumnNumber
end % for iR=1:RowNumber
s=0;

end

