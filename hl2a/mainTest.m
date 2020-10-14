% global  dataPath
global Iex
global ContentOfInterest
Init2A


ContentOfInterest='B'; % B Br Bv AbsB
% ContentOfInterest='Bv'; % B Br Bv AbsB
%  ContentOfInterest='Br'; % B Br Bv AbsB
% ContentOfInterest='AbsB'; % B Br Bv AbsB

close all
limiterRadius=0.40;
p=DrawBackground(limiterRadius);


[X,Y]=PFQuiver(11);
return
% RSV2M(1,0)
% 
% PFFlux(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);




% RSV2M(1,0)
% return
shapeType='DN';
load(['d:\data\equ\' shapeType 'jAndC'],'C','C1') % get the C
Point = getPointFromContour(C,[]);
% figure
XX=Point(1,:);
YY=Point(2,:);+0.0001;
% h=plot(XX,YY,'.','LineWidth',0.5); %plasma
h=plot(XX,YY,'r','LineWidth',1); %plasma
% return
Point = C1{1};
Point(:,1) =[];
XX=Point(1,:);
YY=Point(2,:);+0.0001;
% h=plot(XX,YY,'.','LineWidth',0.5); %plasma
h=plot(XX,YY,'r','LineWidth',1); %plasma
Point = C1{2};
Point(:,1) =[];
XX=Point(1,:);
YY=Point(2,:);+0.0001;
% h=plot(XX,YY,'.','LineWidth',0.5); %plasma
h=plot(XX,YY,'r','LineWidth',1); %plasma

Point = getPointFromContour(C,[]);

indexPoint=abs(Point(2,:))>1.1; % filter the Y>1.1
Point(:,indexPoint)=[];

% figure
XX=Point(1,:);
YY=Point(2,:);+0.0001;
% h=plot(XX,YY,'.','LineWidth',0.5); %plasma
h=plot(XX,YY,'.r','LineWidth',2); %plasma

return




%% open parallel
coreNum=8;
if matlabpool('size')>0
    % already open
else
    %not open
    matlabpool(coreNum)
end

Init2M
RPF=getR;
return

RSV2M(1,0)
br=PFQuiver(1,2);
return


% M=setMM;
shapeType='MM';
load([dataPath 'MM'],'M')

title={'M','IP','CS','PF1U','PF1L','PF2U','PF2L','PF3U','PF3L','PF4U','PF4L','PF5U','PF5L','PF6U','PF6L','PF7U','PF7L','PF8U','PF8L'};
titleV={'IP','CS','PF1U','PF1L','PF2U','PF2L','PF3U','PF3L','PF4U','PF4L','PF5U','PF5L','PF6U','PF6L','PF7U','PF7L','PF8U','PF8L'}';
xlswrite([dataPath shapeType  '.xls'],title,1)
xlswrite([dataPath shapeType  '.xls'],titleV,1,'A2')
xlswrite([dataPath shapeType  '.xls'],M,1,'B2')

return

RSV2M(1,1)



%         m2=getML(17,17);
return
%%  statistic for 0.23

%0.00001
% 1=87927
% 4=83707
% 16=82894
% 64=82744
% 128=82727

%f=0.46
% 1=82136
% 4=82528
% 16=82667
% 64=82705
% 128=82711


%f=0.46/2
% 1=82671
% 4=82663
% 16=82701
% 64=82713
% 128=82715







%f=0.46
% 1=3.9826
% 4=
% 16=4.0196
% 64=4.0220
% 128=4.0224


%f=0.46/2
% 1=4.0159
% 4=4.0191
% 16=4.0217
% 64=4.0225
% 128=4.0227


RSV2M(1,0)
br=PFQuiver(7,-8);
 RSV2M(1,0)
return


[Xv,Yv,Iv,Sv,Vv]=GetLocationVV;







% Xp=1.85;
% Yp=0;
% ap=0.7;
% elong=1.4;
Init2M
Xp=1.65;
Yp=0;
ap=0.7;
elong=1.4;
% Init2M
% Xp=1.7;
% Yp=0;
% ap=0.7;
% elong=1.3;
% Xp=1.6;
% Yp=0;
% ap=0.7;
% elong=1.3;
% Xp=1.7;
% Yp=0;
% ap=0.75;
% elong=1.3;

% [k1,k2,Xb,Yb]=getFieldNullConf(ap,Xp,Yp,elong);
RSV2M(1,0)


global Iex

fileName=[num2str(Xp) '_' num2str(ap) '_' num2str(elong)];
fileName=strrep(fileName,'.','d');
fileName='C';

load(['C:\2w\equ\data\fieldNullConf' fileName],'iPF1')
iPF=iPF1;

% load(['C:\2w\equ\fieldNullConf'],'iPF')

factor=110000/iPF(1);
Iex=factor*iPF;
[X,Y]=PFQuiver(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);

RSV2M(1,0)

PFFlux(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);

% plot(Xb,Yb,'.r')

% load('C:\2w\equ\fieldNullConf','iPF')
% factor=110000/iPF(1);
% Iex=factor*iPF;
% Iex=[110 110 0 0 0 0 0 0 13.5 13.5 10.0 10.0 16.0 16.0 6.236 6.236 1.738 1.738]*1.0e3;
% % close all
% [X,Y]=PFQuiver(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
% plot(Xb,Yb,'.r')
% 

% delete(['C:\2w\equ\fieldNullConf' fileName])

return




global Iex
load('C:\2w\delIex','delI')
Iex=110000*delI/delI(1);
 [X,Y]=PFQuiver(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
return
RSV2M(1,1);
return
%initialization
Init2M
M3=getML(18,18);
RPF=getR;
return

br=PFQuiver(17,-18); 
br1=PFQuiver(15,-16); 

return
[dBrdZ,Br,Z]=GetWeightedMeanBr;

return

% Flux=allFlux;
% return
M3=getML(14,14);
return
M4=getML(3,3);

M5=getML(3,3);

M6=M3-M5;
M7=M4-M5;




[U,t]=DN3MA;
% [U,t]=firstPlasma068;
% plot(t,U(:,1),'r',t,U(:,2),'g',t,U(:,3),'m',t,U(:,4),'b')
% xlim([-500 3000])
return

Flux=allFlux;


% RSV2M(1,0)
% [X,Y]=PFQuiver(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
return




RPF=getR;
return


%build a inductance matrix
global Numcoils
M=zeros(Numcoils,Numcoils);
% 1=plasma 2=cs in parallel other=index
M(1,1)=getML(0,0);
M(2,1)=getML(0,'p');

for i=3:Numcoils
    M(i,1)=getML(0,i);
end
%cs in parallel
L=getML(1,1);
MM=getML(1,2);
M(2,2)=(L+MM)/2;



for i=3:Numcoils
    M(i,2)=getML(i,'p');
end

for j=3:Numcoils
    for i=j:Numcoils
        M(i,j)=getML(i,j);
    end
end


save('c:\2w\M','M')
return %below is parameter
%%
%default value of plasma
mu0=4*pi*1.0e-7;
 Ip=1;%A
%Ip=3.0*1.0e6;%MA or MA/s

ap=0.65;% max=0.5  minor radius a
chi=1.5;%elongation
tri=0.3;%triangularity
betap=0.15;
li=0.8;
%plasma position
Xp=1.782;
Yp=0.0;
delta=0.02;%shafranov shift

Lsol=0.03; % SOL thickness for parabolic distribution
% filament parameter
alpha=pi/4; %
Rstep=0.1;
%% 




L=getML(13,'p')*1000;
return

PFFlux(15);
return


RSV2M(1,1);
return

[p,pIndex]=compareVV;
return

clear
num=10;
[TXX0,TYY0,TXX1,TYY1,TXX2,TYY2]=GetTFParameter(num,0);
index=(0:30)*num;
index(1)=1;
index1=(0:30)*num;
index1(1)=1;

    hfig=figure('NumberTitle','off','Name','TFparameter','Tag','TF');
    figure(hfig);
    scrsz = get(0,'ScreenSize');
    set(hfig,'Units','pixels')
    set(hfig,'Position',[scrsz(1) scrsz(2)+60 scrsz(3)/2.0 scrsz(4)/1.2])
    hold on
    
    plot(TXX1, TYY1,'.r');
    plot(TXX2, TYY2,'.r');
    
    
    plot(TXX1(index1), TYY1(index1),'db');
    plot(TXX2(index), TYY2(index),'.g');
    
return




[My,Mz]=TOS2M;
return

[dBrdZ,Br,Z]=GetWeightedMeanBr;
return

 [X,Y]=PFQuiver(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
return

y=DiagBF;
return

%[X,Y]=PFQuiver(1,2,13,14,17,18);




[bv,i]=getBvIpf8;
return






RSV2M(1,1);
return

 [v(1,1),v(2,1),v(3,1),v(4,1),v(5,1),v(6,1)]=tVV(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);

%  [v(1,1),v(2,1),v(3,1)]=tVV(1,2);
% [v(1,1),v(2,1),v(3,1),v(4,1),v(5,1),v(6,1)]=tVV(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
[v(1,1),v(2,1),v(3,1),v(4,1),v(5,1),v(6,1)]=tVV(1,2);
[v(1,1),v(2,1),v(3,1),v(4,1),v(5,1),v(6,1)]=tVV(7,8);
[v(1,1),v(2,1),v(3,1),v(4,1),v(5,1),v(6,1)]=tVV(7,-8);
[v(1,1),v(2,1),v(3,1),v(4,1),v(5,1),v(6,1)]=tVV(15,16);
[v(1,1),v(2,1),v(3,1),v(4,1),v(5,1),v(6,1)]=tVV(15,-16);
%  [t1,R1,L1,I1,V1,P1]=tVV(1,2);
%   [t2,R2,L2]=tVV(7,-8);
%  [t3,R3,L3]=tVV(15,-16);
%  [t4,R4,L4]=tVV(15,16);
return

















bt1=GetBT(1.13);
bt2=GetBT(1.78);
bt3=GetBT(2.43);
return






RSV2M(1,1);
return


Flux1=Flux;
return

PFFlux(1,2);
PFFlux(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
return

 RPF=getR
 return
 



%eddy current for startup
[S,L]=Eddy4Breakup();


figure

axis equal
plot(L(101:500)-L(100),-S(101:500),'.g',L(901:1300)-L(900),-S(901:1300),'.k')
legend('inner wall','outer wall')
xlabel('Distance(m)')
ylabel('Current density (A/m^2)')
hold on 

num=100;
indexUpper=[num+1:5*num 9*num+1:13*num];
indexMarkerUpper=[(1:5) 9:13]*num;
% plot(L(indexUpper),S(indexUpper),'color','b','marker','.','linestyle','none');
plot(L(indexMarkerUpper)-L(100),-S(indexMarkerUpper),'color','r','marker','o','linestyle','none');



% indexLower=[num:-1:1 8*num:-1:5*num+1 9*num:-1:8*num+1 16*num:-1:13*num+1];
% indexMarkerLower=[0 1 8:-1:5 9 16:-1:13]*num;
% indexMarkerLower(1)=1;
% plot(L(indexLower),S(indexLower),'color','b','marker','.','linestyle','none');
% plot(L(indexMarkerLower),S(indexMarkerLower),'color','r','marker','o','linestyle','none');



return



[y]=EddyQuiver;
return










RSV2M(1,1);
 return

L=getML(3,0);
return
RSV2M(1,1);
return


PFQuiver(5,6);
return



L1=getML(1,1)*1000;
L2=getML(2,2)*1000;
M=getML(2,1)*1000;
L=(L1*L2-M*M)/(L1+L2-2*M);


% L=(L+M)/2
% L=L*4
return



PFQuiver(5,6);
return


[y]=EddyQuiver;
return


















for i=1:8
L(i)=getMLinS(i)*1000;
end
return





RPF=getR
return
L=getML(1,1)*1000;
M=getML(1,2)*1000;
L=(L+M)/2
L=L*4
return
L(1:2)=0;
for i=3:18
L(i)=getML(i,'s')*1000;
end
return





return






PFFlux(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
return








 %PFFlux(1);
PFFlux(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
return
vmin=PFQuiver(3);
return
Init2M 

RSV2M(1,1);
return



 vmin=PFQuiver(13,14,25,26);
return
PFFlux(25,26);

return

b=GetBT;

return

% vmin=PFQuiver(13,14,25,26);
%vmin=PFQuiver(15,16,23,24);
return

%eddy current for startup

R=getR;

figure

axis equal
plot(L(101:500)-L(100),-S(101:500),'.r',L(901:1300)-L(900),-S(901:1300),'.k')
legend('inner wall','outer wall')
xlabel('Distance(m)')
ylabel('Current density (A/m^2)')
hold on 
plot(L(901:1300)-L(900),-S(901:1300),'.k')
I(:,1)=L(101:500)-L(100);
I(:,2)=-S(101:500);
I(:,3)=L(901:1300)-L(900);
I(:,4)=-S(901:1300);

return

save('d:\Eddy4VV.txt','LengthArcInner','IInner','LengthArcOuter','IOuter','-ASCII')
return



m1=TOS2M(12,13) 
% m2=TOS2M(3) 

return

L=GetInductance;
return



tic
hold on
load('PoloidalComponent16','X','Y','BX','BY')
quiver(X,Y,BX,BY,1)
BXmax=max(max(abs(BX)));
BYmax=max(max(abs(BY)));

t=toc
return


%calculate the Bt
tic
r=RSV2M;
hold on
IT=45; %in kA


X=zeros(14,13);
Y=zeros(14,13);
BX=zeros(14,13);
BY=zeros(14,13);

for j=1:1
    theta=pi/16;
    for i=1:5
        for k=1:13
            rho=1.1+(i-1)*0.05;
            z=0+(k-1)*0.1;
            [BT,BR,BZ]=GetBT(rho,theta,z,IT);

            X(i,k)=rho;
            Y(i,k)=z;

            %             B(i,j,k)=BT;
            BX(i,k)=BR;
            BY(i,k)=BZ;
        end
    end


    
    for i=6:14
        for k=1:13
            rho=2.2+(i-6)*0.05-(k-1)*0.05;
            z=0+(k-1)*0.1;
            [BT,BR,BZ]=GetBT(rho,theta,z,IT);

            X(i,k)=rho;
            Y(i,k)=z;

            %             B(i,j,k)=BT;
            BX(i,k)=BR;
            BY(i,k)=BZ;
        end
    end

    quiver(X,Y,BX,BY,1)

end
save('PoloidalComponent16','X','Y','BX','BY')

xlim([0.0 4.0]);
ylim([-3.0 3.0]);
t=toc



return

% I0=[0	0	37.75	45	45	11.195	11.195	0.77	0.77	1.73	1.73];
% I1=[0.172	171.9	28.86	35	35	11.195	11.195	-1.1	-1.1	-0.2	-0.2];
% dIdt=(I1-I0)./(I1(1)-I0(1))
return
%  load BtRipple R Btheory Bcalmax Bcalmin
% figure
% hold on
% scrsz = get(0,'ScreenSize');
% set(gcf,'Units','pixels')
% set(gcf,'Position',[scrsz(1) scrsz(2)+64 scrsz(3)/1.8 scrsz(4)/1.2])
% plot(R,Btheory,R,Bcalmax,R,Bcalmin,R,(Bcalmax-Bcalmin)*100./(Bcalmax+Bcalmin),'.m')
% legend('Theory','max','min','ripple%')





r=RSV2M(0)
return
PFQuiver(1)
m=TOS2M(2,3) 
 return


return
 
[Y,X,fitY,fitX,Yfit,vecY,expY]=StepWiseCurveFit(8770,'#OH','FbSumdUoh','ccUoh');
 %[Y,X,fitY,fitX,Yfit,vecY,expY]=StepWiseCurveFit(8770,'#OH','vl');
return
 % vv and pf
return

[dMdt1,M1,Z1]=MPlasma2Passive(101,0.01);
 [dMdt2,M2,Z2]=MPlasma2Passive(201,0.005);
%  pause
 figure
 plot(Z1,M1,'r',Z2,M2+0.01,'.b')
 pause
 plot(Z1,dMdt1,Z2,dMdt2+10)
 return

 

LPF2Plasma

return
for i=1:13
M(i)=LPF2Plasma(i);
end

return



L=getML

return
[X1,Y1,I1]=GetPlasmaPara;
[X2,Y2]=deal(X1-0.05,Y1);
Flux=I1.*MMutInductance(X1,Y1,X2,Y2,I1);
Lp=sum(Flux(:));

L=GetInductance;


for i=1:13
M=LPF2Plasma(i);
k2(i)=M*M/Lp/L(i);
k(i)=sqrt(k2(i));
end





return
xlim([0.0 4.0]);
ylim([-2.0 2.0]);
set(gca,'position',[.02  .06  .85  .7])
%PFQuiver(1,2,3,4,5,6,7,8,9,10,11)
PFQuiver(1)
return
PFFlux(2)
PFFlux(3)
PFFlux(2,3)
PFFlux(6)
PFFlux(4,6)
PFFlux(6)
PFFlux(4,6)
return
PFQuiver(4,6)
return

RSV2M(1,0,[10 11])
VVQuiver(15)
VVQuiver(15)
VV4PFQuiver(10,11)
VV4PFQuiver(10,11)
[X1,Y1,I,S,L]=GetLocationVV;
