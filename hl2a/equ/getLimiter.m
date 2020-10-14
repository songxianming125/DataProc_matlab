function [limterPoint,varargout]=getLimiter(Limiter,varargin)
%%
%       This program set the limiter position                  
%       Developed by Song xianming 2013.11.30 
%
% input description
%
% XX, YY is the limiter position
persistent init
if nargin>1
    init=varargin{1};
end

if isempty(init)
    init=1;
    isdraw=0;
else
    isdraw=0;
end





%% movable limiter
RLimit=0.4;
XLimit=1.25+Limiter;
ZLimit=0;
alpha=asin(0.25/0.4);
phi=-alpha:alpha/50:alpha;
XL1=2.28;
YL1=-0.25;
XL2=XLimit+RLimit.*cos(phi);
YL2=ZLimit+RLimit.*sin(phi);
XL3=2.28;
YL3=0.25;
XL=[XL1,XL2,XL3];
YL=[YL1,YL2,YL3];
if isdraw
    plot(XL,YL,'r','LineWidth',2);
    hold on
end

% inner fixed limiter
RLimit=0.4115;
XLimit=1.623;
ZLimit=0;
alpha=0.8;
phi=pi-alpha:alpha/50:pi+alpha;
XL=XLimit+RLimit.*cos(phi);
YL=ZLimit+RLimit.*sin(phi);
if isdraw
    plot(XL,YL,'r','LineWidth',2);
    hold on
end
XX=[XL2 XL];
YY=[YL2 YL];
% outer fixed limiter
RLimit=0.4395;
XLimit=1.6195;
ZLimit=0;
alpha=1.05;
phi=-alpha:alpha/50:alpha;
XL=XLimit+RLimit.*cos(phi);
YL=ZLimit+RLimit.*sin(phi);
if isdraw
    plot(XL,YL,'r','LineWidth',2);
    hold on
end
XX=[XX XL];
YY=[YY YL];


limterPoint=[XX;YY];

%% Limiter over

if nargout>1
    varargout{1}=XL;
    varargout{2}=YL;
end
