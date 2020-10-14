function [P1,L1,P2,L2]=getPositionLocation(hObject,Yp1,Yp2);
%the the Location and Position of the two points

%songxm


[n,ha,MyPicStruct,hXLabel,PicDescription,HeightNumber,M,figLBWH,BkLeft,BkBottom,BkWidth,BkHeight]=getPicProperty(hObject);
NTotal=sum(HeightNumber);
HeightUnit=BkHeight/NTotal;
%find Unit number
N1=ceil((BkBottom+BkHeight-Yp1)/(HeightUnit));
N2=ceil((BkBottom+BkHeight-Yp2)/(HeightUnit));


%initialization
P1=0;%Unit number
P2=0;
L1=M;%Location number
L2=M;


%get the Location by the Unit number
Lnum=0;
for j=1:M
    Lnum=Lnum+HeightNumber(j);
    if N1<=Lnum
        L1=j;
        P1=NTotal-Lnum;
        break
    end
end

Lnum=0;
for j=1:M
    %HN2=Lnum;
    Lnum=Lnum+HeightNumber(j);
    if N2<=Lnum
        L2=j;
        P2=NTotal-Lnum;
        break
    end
end

