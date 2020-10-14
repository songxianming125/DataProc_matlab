function [xs,ys]=getCurrentCoordinate(Xs,Ys,ha)
% support array
axesLBWH=get(ha,'position');
xLim=get(ha,'XLim');
yLim=get(ha,'YLim');
xs=xLim(1)+(xLim(2)-xLim(1))*(Xs-axesLBWH(1))/axesLBWH(3);
ys=yLim(1)+(yLim(2)-yLim(1))*(Ys-axesLBWH(2))/axesLBWH(4);
