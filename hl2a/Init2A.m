function Init2A 
%% 2014/ PF6 is changed to 27 turns

global dataPath
global XCenter YCenter W H NX NY N Angle R L S Iex Color Labels myInitialValue Seffective % PF parameters
%%initialization
global FilledType %control the filling style
global Numcoils %PF coil number in total
global XStart XStep XEnd YStart YStep YEnd X1 Y1 %field area parameters
global Ip ap chi tri Xp Yp delta Lsol alpha Rstep It
global rho Lvv
global RStart REnd ZStart  ZEnd  %drawing area parameters
global debugPosition
global ContentOfInterest
global mu0 betap li
% global M


%% open parallel
coreNum=8;
if matlabpool('size')>0
    % already open
else
    %not open
    tic
    matlabpool(coreNum)
    parallelOk=toc
end
% matlabpool close
setappdata(0,'MachineCode','2A')








dataPath='d:\data\equ\';
ContentOfInterest='B'; % B Br Bv AbsB
% ContentOfInterest='Bv'; % B Br Bv AbsB
% ContentOfInterest='Br'; % B Br Bv AbsB
% ContentOfInterest='AbsB'; % B Br Bv AbsB
Numcoils=11;


%%------------------------------------------------------------------------
%The material is Inconel 625
% micro ohmic meter, resistivity for Inconel 625 at 23 celsius degrees 1.29, 
%1.35 for 625 at 300 celsius degrees
% Lvv=0.005;% the thickness of vacuum vessel in meter
% rho=1.29;% % micro ohmic meter,
%The material is 316 SS LN iter material
%rho=0.79;% micro ohmic meter,
%Lvv=0.008;% the thickness of vacuum vessel in meter
% [Lvv,rho]=getVVparameter;

debugPosition='Init2M:21';

%%
%default value of plasma
mu0=4*pi*1.0e-7;
 Ip=0.15e6;%A

ap=0.40;% max=0.5  minor radius a
chi=1.0;%elongation
tri=0.0;%triangularity
betap=0.15;
li=0.8;
%plasma position
Xp=1.65;
Yp=0;

delta=0.02;%shafranov shift

Lsol=0.03; % SOL thickness for parabolic distribution
% filament parameter
alpha=pi/4; %
Rstep=0.1;
%%


It=45*1.0e3; %toroidal current 140kA





%%

%input
FilledType=zeros(1,Numcoils);
%%

%field and penetration time
Iex=ones(1,Numcoils)*1.0*1.0e3;%1kA, field coefficient study field in Gause need a factor 1.0e7
% Iex=zeros(1,Numcoils)*1.0*1.0e3;%1kA, field coefficient study field in Gause need a factor 1.0e7



%%

myInitialValue= false(1,Numcoils);


%% geogrophy parameter

if 1
    XCenter=[748 748 912 912 912 912 912 912 912 912 1092 1092 1501 1501 2500 2500 2760 2760]/1000; %m 11/09/15
    YCenter=[1721.125/2 -1721.125/2 185 -185 586 -586 987 -987 1388 -1388 1753 -1753 1790 -1790 1200 -1200 480 -480]/1000;%m
    W=[116.75 116.75 50.4 50.4 50.4 50.4 50.4 50.4 50.4 50.4 183 183 257 257 183 183 183 183]/1000;%m
    H=[1721.125 1721.125 352.4 352.4 352.4 352.4 352.4 352.4 352.4 352.4 220 220 146 146 220 220 220 220]/1000;%m
    NX=[2 2 2 2 2 2 2 2 2 2 5 5 7 7 5 5 5 5]*8;
    NY=[24 24 14 14 14 14 14 14 14 14 6 6 4 4 6 6 6 6]*8;
    N=[48 48 28 28 28 28 28 28 28 28 28 28 27 27 28 28 28 28]; %real turn of coils, not the product
    Angle=[90 90 90 90 90 90 90 90 90 90 90 90 90 90 64 64 90 90];
end

if 0
    XCenter=[748 748 912 912 912 912 912 912 912 912 1092 1092 1501 1501 2440 2440 2760 2760 2760 2760]/1000; %m 11/09/15
    YCenter=[1721.125/2 -1721.125/2 185 -185 586 -586 987 -987 1388 -1388 1753 -1753 1790 -1790 1350 -1350 630 -630 480 -480]/1000;%m
    W=[116.75 116.75 50.4 50.4 50.4 50.4 50.4 50.4 50.4 50.4 183 183 257 257 183 183 183 183 183 183]/1000;%m
    H=[1721.125 1721.125 352.4 352.4 352.4 352.4 352.4 352.4 352.4 352.4 220 220 146 146 26 26 26 26 220 220]/1000;%m
    NX=[2 2 2 2 2 2 2 2 2 2 5 5 7 7 5 5 5 5 5 5]*8;
    NY=[24 24 14 14 14 14 14 14 14 14 6 6 4 4 6 6 6 6 6 6]*8;
    N=[48 48 28 28 28 28 28 28 28 28 28 28 27 27 1 1 1 1 28 28]; %real turn of coils, not the product
    Angle=[90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90  90 90];
    Numcoils=20;
end







R=[0 1.1 7.8 7.8 7.8 7.8 7.8 7.8 7.8 7.8 3.6 3.6 4.9 4.9 7.6 7.6 8.3 8.3];%mOhmic  1=CS in parallel, 2=CS in parallel, other=single coil
L=[19.1 9.9 9.9 0.02 0 0 0 0 0 0 0 0 0 0 0 0 0 0];%mH








S=[22*55 30*48 30*48 60*60 60*60 0 0 0 0 0 0 0 0 0 0 0 0 0]/1000000;%m2, cross-section
Color={'r','r','m','m','b','b','k','k','g','g','c','c','y','y','k','k','b','b'};
Labels={'OH' 'OH' 'PF1' 'PF1' 'PF2' 'PF2' 'PF3' 'PF3' 'PF4' 'PF4' 'PF5' 'PF5' 'PF6' 'PF6' 'PF7' 'PF7' 'PF8' 'PF8'};
Labels={'CS' ' ' 'PF1U' 'PF1L' 'PF2U' 'PF2L' 'PF3U' 'PF3L' 'PF4U' 'PF4L' 'PF5U' 'PF5L' 'PF6U' 'PF6L' 'PF7U' 'PF7L' 'PF8U' 'PF8L'};
% Labels={'' '' '' '' '' '' '' '' '' '' '' '' 'PF6' 'PF6' 'PF7' 'PF7' 'PF8' 'PF8'};
Seffective=ones(1,Numcoils)*0.9;

 %drawing area parameters
 % RStart=1.2;
% REnd=2.3;
% ZStart=-0.6;
% ZEnd=0.6; 

RStart=0;
REnd=3.3;
ZStart=-2.6;
ZEnd=2.6;  %drawing area parameters

% XStart=0;
% XStep=0.2;
% XEnd=3.3;
% YStart=2.6;
% YStep=-0.2;
% YEnd=-2.6;

% XStart=1.2;
% XStep=0.2;
% XEnd=2.2;
% YStart=0.6;
% YStep=-0.22;
% YEnd=-0.6;

% 
XStart=1.25;
XStep=0.05;
XEnd=2.05;
YStart=0.4;
YStep=-0.05;
YEnd=-0.4;
[X1,Y1] = meshgrid(XStart:XStep:XEnd,YStart:YStep:YEnd);  %field point
% X1=[1.7 1.2 1.2 1.9 2.5];
% Y1=[0.2 1.0 2.2 -2 2];
%%


% load('d:\data\equ\M','M')
% load([dataPath 'MM'],'M')

gFit=globalFit;
setappdata(0,'gFit',gFit)

return




