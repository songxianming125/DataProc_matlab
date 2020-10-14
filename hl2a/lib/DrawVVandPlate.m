%ËÎÏÔÃ÷ 
%»­Õæ¿ÕÊÒºÍÆ«ÂËÆ÷°å
%
%

function M=DrawVVandPlate(u,Limiter)
%Õæ¿ÕÊÒ
limiterColor='k';

NumCoil=7;
X1(1:NumCoil)=[1.070 1.840 2.310 2.310 1.840 1.070 1.070];
X2(1:NumCoil)=[1.095 1.815 2.270 2.270 1.815 1.095 1.095];
Y1(1:NumCoil)=[1.215 1.215 0.436 -0.436 -1.215 -1.215 1.215];
Y2(1:NumCoil)=[1.185 1.185 0.430 -0.430 -1.185 -1.185 1.185];

X(1:NumCoil+NumCoil)=[1.070 1.840 2.310 2.310 1.840 1.070 1.070 1.095 1.815 2.280 2.280 1.815 1.095 1.095];
Y(1:NumCoil+NumCoil)=[1.215 1.215 0.436 -0.436 -1.215 -1.215 1.215 1.185 1.185 0.430 -0.430 -1.185 -1.185 1.185];
C= 'g';


if u==0
    plot(X1,Y1)
    hold on
    plot(X2,Y2)
    hold on
elseif u==1
    patch(X,Y,C)
    hold on
end

%% movable limiter
    % outer fixed limiter
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
    plot(XL,YL,limiterColor,'LineWidth',2);
    hold on

    % inner fixed limiter
RLimit=0.4115;
XLimit=1.623;
ZLimit=0;
alpha=0.8;
phi=pi-alpha:alpha/50:pi+alpha;
    XL=XLimit+RLimit.*cos(phi);
    YL=ZLimit+RLimit.*sin(phi);
    
    plot(XL,YL,limiterColor,'LineWidth',2);
    hold on


    
RLimit=0.4395;
XLimit=1.6195;
ZLimit=0;
alpha=1.05;
phi=-alpha:alpha/50:alpha;
    XL=XLimit+RLimit.*cos(phi);
    YL=ZLimit+RLimit.*sin(phi);
    plot(XL,YL,limiterColor,'LineWidth',2);
    hold on

%% Limiter over    

%MP coil Plate
NumCoil=6;
Xc(1:NumCoil)=[1.355 1.500 1.5165 1.5165 1.727 1.53];
Yc(1:NumCoil)=[0.498 0.735 0.6753 0.6753 0.56 0.745];
Rc(1:NumCoil)=[0.085 0.177 0.1175 0.1175 0.085 0.185];






%PX1(1:2)=[1.2 1.389];
PX1(1:2)=[1.2 1.36];
PY1(1:2)=[0.33 0.33];

Phi=-pi/4:pi/20:pi/4;
i=1;
PX1(3:13)=Xc(i)+Rc(i).*cos(Phi);
PY1(3:13)=Yc(i)+Rc(i).*sin(Phi);


Phi=5*pi/4:-pi/20:3*pi/4;
i=2;
PX1(14:24)=Xc(i)+Rc(i).*cos(Phi);
PY1(14:24)=Yc(i)+Rc(i).*sin(Phi);



plot(PX1,PY1,'LineWidth',2)
hold on
plot(PX1,-PY1,'LineWidth',2)
hold on


PX2(1:2)=[1.400 1.4000];
PY2(1:2)=[0.96 0.96];

Phi=pi:pi/40:5*pi/4;
i=3;
PX2(3:13)=Xc(i)+Rc(i).*cos(Phi);
PY2(3:13)=Yc(i)+Rc(i).*sin(Phi);
PX2(14:15)=[1.4915 1.5415];
PY2(14:15)=[0.5203 0.5203];

Phi=-pi/4:pi/40:0;
i=4;
PX2(16:26)=Xc(i)+Rc(i).*cos(Phi);
PY2(16:26)=Yc(i)+Rc(i).*sin(Phi);
PX2(27:28)=[1.6335 1.6335];
PY2(27:28)=[0.96 0.96];

plot(PX2,PY2,'LineWidth',2)
hold on
plot(PX2,-PY2,'LineWidth',2)
hold on



PX3(1:2)=[1.862 1.75];
PY3(1:2)=[0.416 0.416];

Phi=5*pi/4:-pi/20:3*pi/4;
i=5;
PX3(3:13)=Xc(i)+Rc(i).*cos(Phi);
PY3(3:13)=Yc(i)+Rc(i).*sin(Phi);


Phi=-pi/4:pi/20:pi/4;
i=6;
PX3(14:24)=Xc(i)+Rc(i).*cos(Phi);
PY3(14:24)=Yc(i)+Rc(i).*sin(Phi);



plot(PX3,PY3,'LineWidth',2)
hold on
plot(PX3,-PY3,'LineWidth',2)
hold on


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

plot(X,Y)
    hold on
Rc1=0.01;
for i=1:7
    X1=X(i)+Rc1.*cos(phi1);
    Y1=Y(i)+Rc1.*sin(phi1);
    patch(X1,Y1,'k');
    hold on
end

phi=5*alpha:-alpha:-5*alpha;
X=Xc+Rc.*cos(phi);
Y=Yc+Rc.*sin(phi);
plot(X,Y)
    hold on
for i=1:11
    X1=X(i)+Rc1.*cos(phi1);
    Y1=Y(i)+Rc1.*sin(phi1);
    patch(X1,Y1,'k');
    hold on
end

%% flux loop
% X1=[1.170 1.170 2.120 2.120];
X1=[1.180 1.180 2.120 2.120];
Y1 =[0.404 -0.404 0.640 -0.640]/2; %should be half
Rc1=0.02;
X1=repmat(X1,101,1);
Y1=repmat(Y1,101,1);
X2=repmat((Rc1.*cos(phi1))',1,4);
Y2=repmat((Rc1.*sin(phi1))',1,4);
X=X1+X2;
Y=Y1+Y2;
handle =fill(X,Y,'r');


M=1;

