function [Row,Col,Pos]=getGridPosition(hObject,Point)
%% find the grid position within which the Point is
% developed by Dr. Song
global  MyPicStruct  HeightNumber WidthNumber
[BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
HeightUnit=BkHeight/sum(HeightNumber(:));
WidthUnit=BkWidth/sum(WidthNumber(:));
GapWidth=MyPicStruct.GapWidth;
GapHeight=MyPicStruct.GapHeight;
Pos(1)=BkLeft;
Pos(2)=BkBottom+BkHeight-HeightUnit*HeightNumber(1);

Pos(3)=WidthUnit*WidthNumber(1)-GapWidth;
Pos(4)=HeightUnit*HeightNumber(1)-GapHeight;

for iC=1:MyPicStruct.ColumnNumber
    Col=iC;
    if Point(1)<BkLeft+WidthUnit*sum(WidthNumber(1:iC))
        Pos(3)=WidthUnit*WidthNumber(iC)-GapWidth;
        break;
    else
        Pos(1)=BkLeft+WidthUnit*sum(WidthNumber(1:iC));
    end
end

if Point(1)>BkLeft+WidthUnit*sum(WidthNumber(:))
   Pos(1)=BkLeft+WidthUnit*sum(WidthNumber(1:end-1));
   Pos(3)=WidthUnit*WidthNumber(end)-GapWidth;
end




for iR=1:MyPicStruct.RowNumber
    Row=iR;
    if Point(2)>BkBottom+BkHeight-HeightUnit*sum(HeightNumber(1:iR))
        Pos(4)=HeightUnit*HeightNumber(iR)-GapHeight;
        break;
    else
%         if iR==
            Pos(2)=BkBottom+BkHeight-HeightUnit*sum(HeightNumber(1:iR));
%         end
    end
end

if Point(2)<BkBottom
   Pos(2)=BkBottom;
   Pos(4)=HeightUnit*HeightNumber(end)-GapHeight;
end
return

          
            

