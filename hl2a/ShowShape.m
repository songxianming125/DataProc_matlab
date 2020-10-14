function hShow=ShowShape(gFit,M,v,phiCenter,C,index)
X1=gFit.X1;  % Matrix, X1 in grid
Y1=gFit.Y1;  % Matrix, Y1 in grid
delay=gFit.delay;
hShow=findobj('Type','figure','Tag','hShow');
if isempty(hShow)
    hShow=figure('Tag','hShow');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Units','pixels')
    set(gcf,'Position',[scrsz(1) scrsz(2)+20 scrsz(3)/2.5 scrsz(4)/1.1])
    set(gca,'position',[.06  .06  .7  .88])
    p=DrawBackground(0.4,hShow);
end

figure(hShow)
delV=phiCenter-v;
numContour=10;
vStep=delV/numContour;

[~,hisDraw1] = contour(X1,Y1,M,v+[1:numContour]*vStep,'m');
[~,hisDraw2] = contour(X1,Y1,M,v+[-3:2]*vStep/3,'b');
[~,hisDraw3]= contour(X1,Y1,M,v,'r');
set(hisDraw3,'linewidth',3)
Dh1=((min(C(1,2:end))+max(C(1,2:end)))/2-1.65);
Dv1=((min(C(2,2:end))+max(C(2,2:end)))/2);
hisDraw4=plot(1.65+Dh1,Dv1,'+r');

M(index)=M(index)+100;
[~,indexMax]=max(M(:));
hisDraw5=plot(X1(indexMax),Y1(indexMax),'+b');

pause(delay*3)
%         pause
delete(hisDraw1)
delete(hisDraw2)
delete(hisDraw3)
delete(hisDraw4)
delete(hisDraw5)
