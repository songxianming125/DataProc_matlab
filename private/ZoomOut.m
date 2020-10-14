function ZoomOut
global    HeightNumber WidthNumber bResizable
bResizable=1;
HeightNumber1=getappdata(gcf,'oldHeightNumber');
WidthNumber1=getappdata(gcf,'oldWidthNumber');
if ~isempty(HeightNumber1) && ~isempty(WidthNumber1)
    HeightNumber=HeightNumber1;
    WidthNumber=WidthNumber1;
end
