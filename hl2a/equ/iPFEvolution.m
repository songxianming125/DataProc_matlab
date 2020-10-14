function [iPF,t]=iPFEvolution

%%
%       This program simulate iPF waveform from ip waveform                 
%       Developed by Song xianming 2013.11.16  
%%  






global T1  %ms  5-20  breakdown time
global T2 %50-200  T1 to T2 resistance decrease interval

global T3 T4 % % 100 to 760 shape change: limiter to divertor
global T5 T6 % % 8000 to 9000 shape change: from divertor to limiter


% isSN=0;
isSN=1;



%电阻应该用mOh 则单位问题解决
fluxPlasma=getappdata(0,'fluxPlasma');
if isempty(fluxPlasma)
    load('Flux4Plasma8','fluxPlasma')
    setappdata(0,'fluxPlasma',fluxPlasma)
end

%% initialization
% fluxPF=getappdata(0,'fluxPF');

Numcoils=18;
[Ip,Rp,t]=getIpWave;
dIp=diff(Ip);
iStep=1; % ms
dt=iStep*1e-3; % ms->second

load('iPF1','iPF1') % z=1.1  0.0119 phi=9.4587
iPF1=iPF1'; %flux component

if ~isSN
    load('iPF2','iPF2','Phi')  % DN
    Phi2=Phi;
    load('iPF3','iPF3','Phi')  % Limiter
    Phi3=Phi; % the flux provided by the shape control current
    iPF2=iPF2';
    iPF3=iPF3';
    load('jAndC','j2','C2')
    load('jAndCLimiter','j3','C3')
    suffixName='DN3MA';
else
    load('iPF3SN','iPF3','Phi')   % SN
    Phi2=Phi;
    Phi3=Phi; % the flux provided by the shape control current
    iPF2=iPF3';
    iPF3=iPF3';
    load('jAndCSN','jSN','CSN')
    j2=jSN;
    j3=jSN;
    suffixName='SN3MA';
end

n=numel(t);
iPF=zeros(n,Numcoils); % ohmic consumption
iPFshape=zeros(n,Numcoils); % equilibrium, shape and position control



iPF(1,:)=110000/iPF1(1)*iPF1;  %Ampere

%% before breakdown



Lp3=j3'*fluxPlasma*j3;  % plasma self inductance
Lp2=j2'*fluxPlasma*j2;  % plasma self inductance

loopVoltage=15;  % V
dPhi=loopVoltage*dt; %Vs
diPF1=iPF1*dPhi;


for i=2:T1+1
    iPF(i,:)=iPF(i-1,:)-diPF1; % constant loop voltage
end


for i=T1+2:T2
    iPFshape(i,:)=iPF3*Ip(i); % confine the plasma
    dPhi=Ip(i)*Rp(i)*dt+Lp3*dIp(i-1)+Phi3*dIp(i-1);  % Vs consumption by Ohmic component
    diPF1=iPF1*dPhi;  % Ohmic component
    iPF(i,:)=iPF(i-1,:)-diPF1; % constant loop voltage
end

for i=T2+1:T3
    iPFshape(i,:)=iPF3*Ip(i); % confine the plasma
    dPhi=Ip(i)*Rp(i)*dt+Lp3*dIp(i-1)+Phi3*dIp(i-1);  % Vs consumption by Ohmic component
    diPF1=iPF1*dPhi;  % Ohmic component
    iPF(i,:)=iPF(i-1,:)-diPF1; % constant loop voltage
end

% limiter
%  keep boundary and current density constant
Njunction3=500;  %设置连接点
for i=(T3+1):Njunction3
    iPFshape(i,:)=iPF3*Ip(i); % confine the plasma
    dPhi=Ip(i)*Rp(i)*dt+Lp3*dIp(i-1)+Phi3*dIp(i-1);  % Vs consumption by Ohmic component
    diPF1=iPF1*dPhi;  % Ohmic component
    iPF(i,:)=iPF(i-1,:)-diPF1; % constant loop voltage
end

% change from limiter to divertor
Njunction4=1000;  %设置连接点
nStep=Njunction4-Njunction3;
for i=(Njunction3+1):Njunction4
    ratioI=(i-Njunction3)/nStep;
    iPFshape(i,:)=(iPF3+(iPF2-iPF3)*ratioI)*Ip(i); % confine the plasma
    dPhi=Ip(i)*Rp(i)*dt+(Lp3+(Lp2-Lp3)*ratioI)*dIp(i-1)+(Phi3+(Phi2-Phi3)*ratioI)*dIp(i-1);  % V
    diPF1=iPF1*dPhi;
    iPF(i,:)=iPF(i-1,:)-diPF1; % constant loop voltage
end

% divertor
%  keep boundary and current density constant
Njunction5=fix(T5/iStep)+1;  %设置连接点
for i=(Njunction4+1):Njunction5
    iPFshape(i,:)=iPF2*Ip(i); % confine the plasma
    dPhi=Ip(i)*Rp(i)*dt+Lp2*dIp(i-1)+Phi2*dIp(i-1);  % Vs consumption by Ohmic component
    diPF1=iPF1*dPhi;  % Ohmic component
    iPF(i,:)=iPF(i-1,:)-diPF1; % constant loop voltage
end

% change from divertor to limiter
Njunction6=fix(T6/iStep)+1;  %设置连接点
nStep=Njunction6-Njunction5;
for i=(Njunction5+1):Njunction6
    
    ratioI=(i-Njunction5)/nStep;
    iPFshape(i,:)=(iPF2+(iPF3-iPF2)*ratioI)*Ip(i); % confine the plasma
    dPhi=Ip(i)*Rp(i)*dt+(Lp2+(Lp3-Lp2)*ratioI)*dIp(i-1)+(Phi2+(Phi3-Phi2)*ratioI)*dIp(i-1);  % V
    diPF1=iPF1*dPhi;
    iPF(i,:)=iPF(i-1,:)-diPF1; % constant loop voltage
    
    
    
    
end

% limiter
%  keep boundary and current density constant
for i=(Njunction6+1):n
    iPFshape(i,:)=iPF3*Ip(i); % confine the plasma
    dPhi=Ip(i)*Rp(i)*dt+Lp3*dIp(i-1)+Phi3*dIp(i-1);  % Vs consumption by Ohmic component
    diPF1=iPF1*dPhi;  % Ohmic component
    iPF(i,:)=iPF(i-1,:)-diPF1; % constant loop voltage
end
%     iPFshape(n,:)=iPFshape(n-1,:); % confine the plasma
%     iPF(n,:)=iPF(n-1,:); % constant loop voltage


iPF=iPF+iPFshape;


% close all
% Init2M
% RSV2M(1,0)
% global Iex
% Iex=iPF(3000,:);
% [X,Y]=PFQuiver(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
% 
% plot(t,iPFshape(:,11))
% hold on
% xlim([-1000,11000])
% 

save(['c:\2w\equ\' suffixName],'t','iPF','Ip','Rp')


return

