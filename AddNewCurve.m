function c=AddNewCurve(x,y,MyShot,CurrentChannel,Unit,varargin)
%% 
%% z data will be provided



yMax=max(y);
yMin=min(y);
if yMax*yMin<0 
%     c.GridOnYZero=true;
    c.GridOnYZero=false;
else
    c.GridOnYZero=false;
end
c.x=x;


% %debug
% r=1000;
% c.y=y+r*abs(yMin);
% c.yMax=yMax+r*abs(yMin);
% c.yMin=yMin+r*abs(yMin);
% 

c.y=y;

c.z=[];% for compatible to all curves
if nargin>5
    c.z=varargin{1};% for compatible to all curves
end
c.yMax=yMax;
c.yMin=yMin;




xMax=max(x);
xMin=min(x);
c.xMax=xMax;
c.xMin=xMin;
c.Shot=MyShot;
c.ChnlName=myFavouriteName(CurrentChannel);
c.Unit=Unit;
c.Color='b';
c.Marker='.';
c.LineStyle='-';


%###################################################################3
