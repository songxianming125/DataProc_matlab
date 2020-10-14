function [TXX1,TYY1,TXX,TYY]=GetTFPara(varargin)
%%%********************************************************%%%
%%% This program is to get the parameter of TF coils   %%%
%%%   including position of the D shape structure        %%%
%%%      Developed by Song xianming 2008/08/19/            %%%
%%%     modified by Song Xianming on 2011/09/15/            %%%
%%%********************************************************%%%
% option=1 means the item is necessary, option=0 means the item is optional
% input
% option  VarName             DataType           Meaning
% 0       num              int=100               the number of elements
% 0       bHalf               int=0,1            1=only half,0=both 
%
% output:
% option    VarName             DataType        Meaning      
% 0         TXX1               double array      outer x coordinates
% 0         TYY1               double array      outer y coordinates
% 0         TXX                double array      inner x coordinates
% 0         TYY                double array      inner y coordinates
%%%********************************************************%%%
%%%********************************************************%%%
%------------------------------------------------------------------------
% figure
% hold on
% axis equal
% ylim([-2.7 2.7])


if nargin==0
    num=100;
    bHalf=0; %only half is got
elseif nargin==1
    if ~isempty(varargin{1}) && isnumeric(varargin{1})
        num=varargin{1};
    else
        num=100;
    end
    bHalf=0;
elseif nargin==2
    if ~isempty(varargin{1}) && isnumeric(varargin{1})
        num=varargin{1};
    else
        num=100;
    end
    if ~isempty(varargin{2}) && isnumeric(varargin{2})
        bHalf=varargin{2};
    else
        bHalf=0;
    end
end
%TF coil parameter without stainless steel shell
%    20*7, toroidal direction 7 coils, 20 sets


% all data in meter
dX=0.38;% straight width in meter
Xbase=0.6504; %straight segment inner edge position for base
num=100;
index=1:num;
%outer
%from straight segment clockwise
TXX=[];
TYY=[];

%outer straight segment
TXX=[TXX Xbase-dX];
TXX=linspace(TXX, TXX,num);

TCY0=3.580/2; %outer straight segment half height
TYY=linspace(0, TCY0,num);
    
    
%%
%arc one
TR=1.059796;   % outer radius of the circle
TCX=1.329737;  % x for center of the circle
TCY=1.790009; % y for center of the circle

XStart=0.270;   %x for the start point of the arc
YStart=1.796379;%y for the start point of the arc

XEnd=0.42292;   %x for the end point of the arc
YEnd=2.33852;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];

% plot(TCX, TCY,'dr');
% plot(XStart, YStart,'dr');
% plot(XEnd, YEnd,'dr');
% 
% 
% d1=sqrt((XStart-TCX)^2+(YStart-TCY)^2);
% d2=sqrt((XEnd-TCX)^2+(YEnd-TCY)^2);

%arc one over
%%
 

%%
% obliqued line with 30 degree
LengthOblique=0.403;  % the length of oblique line
AngleOblique=30*pi/180; % the angle of oblique line
XStart=TXX(end);   %x for the start point of the line
YStart=TYY(end);%y for the start point of the line
XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc


TXX=[TXX linspace(XStart,XEnd,num)];
TYY=[TYY linspace(YStart,YEnd,num)];


%oblique line with 30 degree over
%%  
    
%%
% horizontal line 
LengthOblique=0.874;  % the length of oblique line
AngleOblique=0*pi/180; % the angle of oblique line
XStart=TXX(end);   %x for the start point of the line
YStart=TYY(end);%y for the start point of the line
XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc


TXX=[TXX linspace(XStart,XEnd,num)];
TYY=[TYY linspace(YStart,YEnd,num)];

% horizontal line over
%%    
 


%%
%sawtooth area
for i=1:5
    % sawtooth area with vertical line
    LengthOblique=0.055;  % the length of oblique line
    AngleOblique=-90*pi/180; % the angle of oblique line
    XStart=TXX(end);   %x for the start point of the line
    YStart=TYY(end);%y for the start point of the line
    XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
    YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc
    
    
    TXX=[TXX linspace(XStart,XEnd,num)];
    TYY=[TYY linspace(YStart,YEnd,num)];
    
    % vertical line over
    
    
    
    % sawtooth area with horizontal line
    LengthOblique=0.078;  % the length of oblique line
    AngleOblique=0*pi/180; % the angle of oblique line
    XStart=TXX(end);   %x for the start point of the line
    YStart=TYY(end);%y for the start point of the line
    XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
    YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc
    
    
    TXX=[TXX linspace(XStart,XEnd,num)];
    TYY=[TYY linspace(YStart,YEnd,num)];
    
    
      % horizontal line over
end
%sawtooth area over
%%    


%%
%sawtooth area
    % sawtooth area with vertical line
    LengthOblique=0.055;  % the length of oblique line
    AngleOblique=-90*pi/180; % the angle of oblique line
    XStart=TXX(end);   %x for the start point of the line
    YStart=TYY(end);%y for the start point of the line
    XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
    YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc
    
    
    TXX=[TXX linspace(XStart,XEnd,num)];
    TYY=[TYY linspace(YStart,YEnd,num)];
    
    % vertical line over
    
    
    
    % sawtooth area with horizontal line
    % much longer than first five
    LengthOblique=0.0892;  % the length of oblique line
    AngleOblique=0*pi/180; % the angle of oblique line
    XStart=TXX(end);   %x for the start point of the line
    YStart=TYY(end);%y for the start point of the line
    XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
    YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc
    
    
    TXX=[TXX linspace(XStart,XEnd,num)];
    TYY=[TYY linspace(YStart,YEnd,num)];
    
    
      % horizontal line over
%sawtooth area over
%% 




%%
% obliqued line between sawtooth and arc
LengthOblique=0.403;  % the length of oblique line
AngleOblique=30*pi/180; % the angle of oblique line

XStart=2.125135;   %x for the start point of the line
YStart=2.210114;%y for the start point of the line
XEnd=2.405816;   %x for the end point of the arc
YEnd=1.955671;    %y for the end point of the arc


TXX=[TXX linspace(XStart,XEnd,num)];
TYY=[TYY linspace(YStart,YEnd,num)];


%oblique line with 30 degree over
%%  

% plot(XStart, YStart,'ob');
% plot(XEnd, YEnd,'ob');




%%
%arc two
TR=2.138593;   % outer radius of the circle
TCX=0.999238;  % x for center of the circle
TCY=0.344733; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=2.808929;   %x for the end point of the arc
YEnd=1.484295;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];

d1=sqrt((XStart-TCX)^2+(YStart-TCY)^2);
d2=sqrt((XEnd-TCX)^2+(YEnd-TCY)^2);

%arc two over
%%


%%
%arc three
TR=2.743042;   % outer radius of the circle
TCX=0.492074;  % x for center of the circle
TCY=0.015805; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=3.230;   %x for the end point of the arc
YEnd=0.18326;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];

d1=sqrt((XStart-TCX)^2+(YStart-TCY)^2);
d2=sqrt((XEnd-TCX)^2+(YEnd-TCY)^2);

%arc three over
%%
 

%%
%vertical line on equatorial plane
LengthOblique=0.18326;  % the length of oblique line
AngleOblique=-90*pi/180; % the angle of oblique line
XStart=TXX(end);   %x for the start point of the line
YStart=TYY(end);%y for the start point of the line
XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
YEnd=0;%YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc


TXX=[TXX linspace(XStart,XEnd,num)];
TYY=[TYY linspace(YStart,YEnd,num)];
%%

%lower outer half
% bHalf=0;
if bHalf==0
    TXX=[TXX fliplr(TXX)];
    TYY=[TYY -fliplr(TYY)];
elseif bHalf==1 
elseif bHalf==2 
    TXX=fliplr(TXX);
    TYY=-fliplr(TYY);
end

%save outer arc
TXX1=TXX;
TYY1=TYY;
%%
%%
% 
% plot(TXX,TYY,'m.')
% plot(TXX,TYY,'m.')
% 







%inner

TXX=[];
TYY=[];

%%
%first inner straight line
LengthOblique=3.490/2;  % the length of oblique line
AngleOblique=90*pi/180; % the angle of oblique line
XStart=Xbase;   %x for the start point of the line
YStart=0;%y for the start point of the line

XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc


TXX=[TXX linspace(XStart,XEnd,num)];
TYY=[TYY linspace(YStart,YEnd,num)];
% inner straight line over
%%



%%
%arc one
TR=0.491657;   % outer radius of the circle
TCX=1.126588;  % x for center of the circle
TCY=1.624209; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=0.768111;   %x for the end point of the arc
YEnd=1.960692;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];


%arc one over
%%

%%
%arc two
TR=0.596698;   % outer radius of the circle
TCX=1.21606;  % x for center of the circle
TCY=1.566497; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=0.914183;   %x for the end point of the arc
YEnd=2.081199;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];


%arc two over
%%




%%
%arc three
TR=0.679029;   % outer radius of the circle
TCX=1.25784;  % x for center of the circle
TCY=1.495554; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=1.010788;   %x for the end point of the arc
YEnd=2.128046;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];


%arc three over
%%

%%
%arc four
TR=0.817;   % outer radius of the circle
TCX=1.297483;  % x for center of the circle
TCY=1.363; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=1.372798;   %x for the end point of the arc
YEnd=2.177618;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];

%arc four over
%%


%%
%arc five
TR=1.21917;   % outer radius of the circle
TCX=1.294622;  % x for center of the circle
TCY=0.96074; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=1.690331;   %x for the end point of the arc
YEnd=2.113905;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];


%arc five over
%%

%%
%arc six
TR=1.506649;   % outer radius of the circle
TCX=1.221585;  % x for center of the circle
TCY=0.68203; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=2.0011;   %x for the end point of the arc
YEnd=1.97135;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];


%arc six over
%%




%%
%arc seven
TR=1.885925;   % outer radius of the circle
TCX=1.021584;  % x for center of the circle
TCY=0.359748; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=2.454113;   %x for the end point of the arc
YEnd=1.586358;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];


%arc seven over
%%


%%
%arc eight
TR=2.216596;   % outer radius of the circle
TCX=0.771247;  % x for center of the circle
TCY=0.1437; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=2.772719;   %x for the end point of the arc
YEnd=1.096282;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];

% d1=sqrt((XStart-TCX)^2+(YStart-TCY)^2);
% d2=sqrt((XEnd-TCX)^2+(YEnd-TCY)^2);

%arc eight over
%%


%%
%arc nine
% format long
TR=2.594625;   % outer radius of the circle
TCX=0.421996;  % x for center of the circle
TCY=0.001981; % y for center of the circle

XStart=TXX(end);   %x for the start point of the arc
YStart=TYY(end);%y for the start point of the arc

XEnd=3.010;   %x for the end point of the arc
YEnd=0.18326;    %y for the end point of the arc

%clockwise,angle is monotonically going down
theta1=acos((XStart-TCX)/TR);
theta2=acos((XEnd-TCX)/TR);
theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0

TXX=[TXX TCX+TR*cos(theta)];
TYY=[TYY TCY+TR*sin(theta)];




% d1=sqrt((XStart-TCX)^2+(YStart-TCY)^2);
% d2=sqrt((XEnd-TCX)^2+(YEnd-TCY)^2);

%arc nine over
%%


%%
%vertical line on equatorial plane
LengthOblique=0.18326;  % the length of oblique line
AngleOblique=-90*pi/180; % the angle of oblique line
XStart=TXX(end);   %x for the start point of the line
YStart=TYY(end);%y for the start point of the line
XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
YEnd=0;%YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc


TXX=[TXX linspace(XStart,XEnd,num)];
TYY=[TYY linspace(YStart,YEnd,num)];
%%






% plot(TCX, TCY,'dr');
% plot(XStart, YStart,'dr');
% plot(XEnd, YEnd,'dr');




%%
%arc ten
% TR=0.330;   % outer radius of the circle
% TCX=0.980;  % x for center of the circle
% TCY=1.745; % y for center of the circle
% 
% XStart=TXX(end);   %x for the start point of the arc
% YStart=TYY(end);%y for the start point of the arc
% 
% XEnd=3.010;   %x for the end point of the arc
% YEnd=0.18326;    %y for the end point of the arc
% 
% %clockwise,angle is monotonically going down
% theta1=acos((XStart-TCX)/TR);
% theta2=acos((XEnd-TCX)/TR);
% theta=linspace(theta1,theta2,num); %0 to 1 %clockwise theta <0
% 
% TXX=[TXX TCX+TR*cos(theta)];
% TYY=[TYY TCY+TR*sin(theta)];
% 
% d1=sqrt((XStart-TCX)^2+(YStart-TCY)^2);
% d2=sqrt((XEnd-TCX)^2+(YEnd-TCY)^2);

%arc ten over
%%

% plot(TCX, TCY,'dc');
% plot(XStart, YStart,'dk');
% plot(XEnd, YEnd,'dg');


%lower inner half
if bHalf==0
    TXX=[TXX fliplr(TXX)];
    TYY=[TYY -fliplr(TYY)];
elseif bHalf==1 
elseif bHalf==2 
    TXX=fliplr(TXX);
    TYY=-fliplr(TYY);
end

% plot(TXX,TYY,'m.')
% plot(TXX,TYY,'m.')


