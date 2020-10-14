function  [TXX0,TYY0,TXX1,TYY1,TXX2,TYY2]= GetTFParameter(varargin)
% GETTFPARAMETER the short description(H1 line help)
% SYNTAX
% [output] = GETTFPARAMETER(A)
%
% option=1 means the item is necessary, option=0 means the item is optional
% INPUT PARAMETERS
% option  VarName             DataType           Meaning
% 0       num                 int=100            the number of elements
% 0       bHalf               int=0,1            1=only half,0=both 
%
% OUTPUT PARAMETERS
% option    VarName             DataType        Meaning   
% 0         TXX0               double array      outline x coordinates
% 0         TYY0               double array      outline y coordinates
% 0         TXX1               double array      outer x coordinates
% 0         TYY1               double array      outer y coordinates
% 0         TXX2                double array     inner x coordinates
% 0         TYY2               double array      inner y coordinates
% DESCRIPTION
% Exhaustive and long description of functionality of GetTFParameter.
%
% Examples:
% description of example for GetTFParameter
% >> [output] = GetTFParameter(A);
%
% See also:
% ALSO1, ALSO2
%
% References:
% [1] A. Einstein, Die Grundlage der allgemeinen Relativitaetstheorie,
%     Annalen der Physik 49, 769-822 (1916).
% Author: Dr. Xianming SONG
% Email: songxm@swip.ac.cn
% Copyright (c) %Southwestern Institute of Physic, PO. Box 432#, Chengdu, China. 1966-2013
% All Rights Reserved.
% $Revision: 1.0$ Created on: 31-Aug-2013 13:26:10

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

debug=1; %for debug use

if debug
    close all
    hfig=figure('NumberTitle','off','Name','TFparameter','Tag','TF');
    figure(hfig);
    scrsz = get(0,'ScreenSize');
    set(hfig,'Units','pixels')
    set(hfig,'Position',[scrsz(1) scrsz(2)+100 scrsz(3)/2.0 scrsz(4)/1.2])
end


%TF coil parameter without stainless steel shell
%    20*7, toroidal direction 7 coils, 20 sets


% all data in meter
dX=0.38;% straight width in meter
Xbase=0.65; %straight segment inner edge position for base

index=1:num;
%outer
%from straight segment clockwise
TXX=[];
TYY=[];

%outer straight segment
TXX=[TXX Xbase-dX];
TXX=linspace(TXX, TXX,num);

TCY0=3.6580/2; %outer straight segment half height
TYY=linspace(0, TCY0,num);
    
    
%%
if debug
    plot(TXX, TYY,'.r');
end
%arc one over
%%
 

%%
%first oblique line
% oblique line with 530.08mm long, tilting 164.91(74.91 --15.09) degree
LengthOblique=0.53008;  % the length of oblique line
AngleOblique=74.91*pi/180; % the angle of oblique line
XStart=TXX(end);   %x for the start point of the line
YStart=TYY(end);%y for the start point of the line
XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc


TXX=[TXX linspace(XStart,XEnd,num)];
TYY=[TYY linspace(YStart,YEnd,num)];


%first oblique line  over
%%  



%%
%second oblique line
% oblique line with 398.39mm long, tilting 135.09(in 30) degree
LengthOblique=0.39839;  % the length of oblique line
AngleOblique=30*pi/180; % the angle of oblique line
XStart=TXX(end);   %x for the start point of the line
YStart=TYY(end);%y for the start point of the line
XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc

TXX=[TXX linspace(XStart,XEnd,num)];
TYY=[TYY linspace(YStart,YEnd,num)];
%second oblique line  over
%%  

if debug
    plot(TXX, TYY,'.r');
end


    
%%
% horizontal line 
%x=753 stop
% 1420+148-753=815 mm

LengthOblique=0.815;  % the length of horizontal line
AngleOblique=0*pi/180; % the angle of horizontal line
XStart=TXX(end);   %x for the start point of the line
YStart=TYY(end);%y for the start point of the line
XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc


TXX=[TXX linspace(XStart,XEnd,num)];
TYY=[TYY linspace(YStart,YEnd,num)];

% horizontal line over
%%    
 
if debug
    plot(TXX, TYY,'.r');
end


%%
%sawtooth area
for i=1:7
    % sawtooth area with vertical line
    LengthOblique=0.050;  % the length of vertical line
    AngleOblique=-90*pi/180; % the angle of vertical line
    XStart=TXX(end);   %x for the start point of the line
    YStart=TYY(end);%y for the start point of the line
    XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
    YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc
    
    
    TXX=[TXX linspace(XStart,XEnd,num)];
    TYY=[TYY linspace(YStart,YEnd,num)];
    
    % vertical line over
    
    % sawtooth area with horizontal line
    LengthOblique=0.086;  % the length of horizontal line
    AngleOblique=0*pi/180; % the angle of horizontal line
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


if debug
    plot(TXX, TYY,'.r');
end


%%
%the oblique line between sawtooth and arc in outer outline
% oblique line with 398.39mm long, tilting 135.09(in 30) degree
% LengthOblique=0.39839;  % the length of oblique line
% AngleOblique=30*pi/180; % the angle of oblique line
% XStart=TXX(end);   %x for the start point of the line
% YStart=TYY(end);%y for the start point of the line
% XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
% YEnd=YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc
% 
% TXX=[TXX linspace(XStart,XEnd,num)];
% TYY=[TYY linspace(YStart,YEnd,num)];
%second oblique line  over
%%  




%%
%arc K, first outer arc
TR=2.13859;   % outer radius of the circle
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

%arc K, first outer arc
%%
if debug
    plot(TXX, TYY,'.r');
end

%%
%arc J, second outer arc
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

%arc J, second outer arc
%%
if debug
    plot(TXX, TYY,'.r');
end
 

%%
%vertical line on equatorial plane
LengthOblique=0.36652/2;  % the length of vertical line
AngleOblique=-90*pi/180; % the angle of vertical line
XStart=TXX(end);   %x for the start point of the line
YStart=TYY(end);%y for the start point of the line
XEnd=XStart+LengthOblique*cos(AngleOblique);   %x for the end point of the arc
YEnd=0;%YStart+LengthOblique*sin(AngleOblique);    %y for the end point of the arc


TXX=[TXX linspace(XStart,XEnd,num)];
TYY=[TYY linspace(YStart,YEnd,num)];
%%

if debug
    plot(TXX, TYY,'.r');
end



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
TXX0=TXX;
TYY0=TYY;
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
LengthOblique=3.490/2;  % the length of straight line
AngleOblique=90*pi/180; % the angle of straight line
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
TR=0.34058;   % outer radius of the circle
TCX=0.990575;  % x for center of the circle
TCY=1.745; % y for center of the circle

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
TR=1.02935;   % outer radius of the circle
TCX=1.406475;  % x for center of the circle
TCY=1.175598; % y for center of the circle

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
TR=0.817;   % outer radius of the circle
TCX=1.297483;  % x for center of the circle
TCY=1.363; % y for center of the circle

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
TR=1.08517;   % outer radius of the circle
TCX=1.30085;  % x for center of the circle
TCY=1.094832; % y for center of the circle

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
TR=1.23347;   % outer radius of the circle
TCX=1.287529;  % x for center of the circle
TCY=0.947134; % y for center of the circle

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
TCY=-0.001981; % y for center of the circle

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

if debug
    hold on
    plot(TXX, TYY,'.r');
end



