function [xs,ys]=getCurrentScreen(Xs,Ys,ha)   % a set of point
% support array

axesLBWH=get(ha,'position');
xLim=get(ha,'XLim');
yLim=get(ha,'YLim');
xs=axesLBWH(1)+(Xs-xLim(1))*axesLBWH(3)/(xLim(2)-xLim(1));
ys=axesLBWH(2)+(Ys-yLim(1))*axesLBWH(4)/(yLim(2)-yLim(1));
