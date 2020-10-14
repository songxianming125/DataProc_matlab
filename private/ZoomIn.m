function ZoomIn(Row,Col)
global    HeightNumber WidthNumber bResizable
bResizable=1;


HeightNumber(:)=0;
WidthNumber(:)=0;
HeightNumber(Row)=1;
WidthNumber(Col)=1;