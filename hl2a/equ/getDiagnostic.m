function [Point,varargout]=getDiagnostic(varargin)
%%
%       This program set the Diagnostic position                  
%       Developed by Song xianming 2013.11.30 
%
% input description
%
% XX, YY is the point position
persistent init

if nargin>0
    init=varargin{1};
end
if isempty(init)
    init=1;
    isdraw=1;
else
    isdraw=1;
end


%magnetic probe 
Xc=1.68;
Yc=0;
Rc=0.505;
Rc1=0.01;

alpha=10.5*pi/180;
phi=pi+3*alpha:-alpha:pi-3*alpha;
phi1=0:pi/50:2*pi;
X=Xc+Rc.*cos(phi);
Y=Yc+Rc.*sin(phi);

XX=X;
YY=Y;
theta=phi;
if isdraw
    plot(X,Y)
    hold on
    Rc1=0.01;
    for i=1:7
        X1=X(i)+Rc1.*cos(phi1);
        Y1=Y(i)+Rc1.*sin(phi1);
        patch(X1,Y1,'k');
        hold on
    end
end

phi=5*alpha:-alpha:-5*alpha;
X=Xc+Rc.*cos(phi);
Y=Yc+Rc.*sin(phi);

XX=[XX X];
YY=[YY Y];
theta=[theta phi];


if isdraw
    plot(X,Y)
    hold on
    for i=1:11
        X1=X(i)+Rc1.*cos(phi1);
        Y1=Y(i)+Rc1.*sin(phi1);
        patch(X1,Y1,'k');
        hold on
    end
end

%% flux loop
% X1=[1.170 1.170 2.120 2.120];
X1=[1.180 1.180 2.120 2.120];
Y1 =[0.404 -0.404 0.640 -0.640]/2; %should be half
XX=[XX X1];
YY=[YY Y1];


if isdraw
    Rc1=0.02;
    X1=repmat(X1,101,1);
    Y1=repmat(Y1,101,1);
    X2=repmat((Rc1.*cos(phi1))',1,4);
    Y2=repmat((Rc1.*sin(phi1))',1,4);
    X=X1+X2;
    Y=Y1+Y2;
    handle =fill(X,Y,'r');
end
Point=[XX;YY];
if nargout>1
    varargout{1}=theta;
end



