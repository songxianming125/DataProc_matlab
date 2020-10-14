
function y=mainEqu
% Init2M
% y=testSimulation(3001);
% 
% return
%%
global Ip Xp betap alphaIndex
global Iex

Init2M
%% get plasma shape
fluxPlasma=getappdata(0,'fluxPlasma');
fluxPF=getappdata(0,'fluxPF');
if isempty(fluxPlasma)
load('Flux4Plasma8','fluxPlasma')
load('Flux4PF8','fluxPF')
setappdata(0,'fluxPlasma',fluxPlasma)
setappdata(0,'fluxPF',fluxPF)
end
[Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D('DN');
Iex=getPFcurrent('DN');
FilledType=sign(Iex);
RSV2M(1,0)


PFCoef=fluxPF;
fluxPF=PFCoef*Iex'; % should transpose


j=getPlasmaCurrent(fluxPlasma,fluxPF);
[j,C]=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);



return
%%




% global Iex
% global Ip Xp betap alphaIndex
% 
% [Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D;
% Iex=getPFcurrent;
% 
% 
% fluxPlasma=getappdata(0,'fluxPlasma');
% fluxPF=getappdata(0,'fluxPF');
% if isempty(fluxPlasma)
% load('Flux4Plasma8','fluxPlasma')
% load('Flux4PF8','fluxPF')
% setappdata(0,'fluxPlasma',fluxPlasma)
% setappdata(0,'fluxPF',fluxPF)
% end
% 
% PFCoef=fluxPF;
% fluxPF=fluxPF*Iex'; % should transpose
% FilledType=sign(Iex);
% RSV2M(1,0)
% 
% 
% % load('jAndCLimiter','j','C')
% % [iPF3,y]=getRampUpConsumption(j,C);  %dip=1A
% % M=j'*PFCoef;  %mutual inductance
% % Phi=dot(M,iPF3);
% % save('iPF3','iPF3','Phi')
% % return
% 
% 
% 
% j=getPlasmaCurrent(fluxPlasma,fluxPF);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% % j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% [j2,C2]=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% save('jAndC','j2','C2')
% % load('jAndC','j2','C2')
% 
% 
% 
% [chi3,iPF1]=getFieldNullConfC(C2);
% 
% save('iPF1','iPF1') % z=1.1  0.0119 phi=9.4587
% factor=110000/iPF1(1);
% Iex=factor*iPF1;
% [X,Y]=PFQuiver(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
% 
% 
% 
% 
% 
% return
% 
% 
% 





global Iex
global Ip Xp betap alphaIndex

%% set green function
% tic
% [Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D;


fluxPlasma=getappdata(0,'fluxPlasma');
fluxPF=getappdata(0,'fluxPF');
if isempty(fluxPlasma)
load('Flux4Plasma8','fluxPlasma')
load('Flux4PF8','fluxPF')
setappdata(0,'fluxPlasma',fluxPlasma)
setappdata(0,'fluxPF',fluxPF)
end

% toc

return

suffixName='Ohmic3MASN';
load(['c:\2w\equ\' suffixName],'t','iPF','Ip')

t=7000;

Ip=Ip(t);
Iex=iPF(t,:);



PFCoef=fluxPF;
fluxPF=fluxPF*Iex'; % should transpose
FilledType=sign(Iex);
RSV2M(1,0)


% load('jAndCLimiter','j','C')
% [iPF3,y]=getRampUpConsumption(j,C);  %dip=1A
% M=j'*PFCoef;  %mutual inductance
% Phi=dot(M,iPF3);
% save('iPF3','iPF3','Phi')
% return



j=getPlasmaCurrent(fluxPlasma,fluxPF);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
[j,C]=getPlasmaCurrent(fluxPlasma,fluxPF,j);


% save('jAndCLimiter','j','C')
% [iPF3,y]=getRampUpConsumption(j,C);  %dip=1A
% 
% 
% M=j'*fluxPF;  %mutual inductance
% Phi=dot(M,iPF3);
% save('iPF3','iPF3','Phi')



return
% load('jAndCLimiter','j','C')
% j3=j;
% C3=C;
% 
% load('jAndC','j','C')
% j2=j;
% C2=C;
% 
% save('jAndC','j2','C2','j3','C3')
% 
% return

% global FilledType
global Iex
% Iex=getPFcurrent;
% FilledType=sign(Iex);
% close all
RSV2M(1,0)

load('Flux4PF8','fluxPF')
load('jAndC','j','C')
% [chi3,iPF1]=getFieldNullConfC(C);

[iPF2,y]=getRampUpConsumption(j,C);  %dip=1A
M=j'*fluxPF;  %mutual inductance
Phi=dot(M,iPF2);

save('iPF2','iPF2','Phi')


return
save('iPF1','iPF1') % z=1.1  0.0119 phi=9.4587
factor=110000/iPF1(1);
Iex=factor*iPF1;
[X,Y]=PFQuiver(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);

return

load('Flux4Plasma8','fluxPlasma')
load('Flux4PF8','fluxPF')
% setappdata(0,'fluxPlasma',fluxPlasma)
% setappdata(0,'fluxPF',fluxPF)
% fluxPlasma=getappdata(0,'fluxPlasma');
% fluxPF=getappdata(0,'fluxPF');

PFCoef=fluxPF;
fluxPF=PFCoef*Iex'; % should transpose


j=getPlasmaCurrent(fluxPlasma,fluxPF);
[j,C]=getPlasmaCurrent(fluxPlasma,fluxPF,j);

% save('jAndC','j','C')



% M=j'*PFCoef;  %mutual inductance
% Iex=getPFcurrent(6);
% delTotalPhi=dot(M,Iex);

% [dI,y]=getRampUpConsumption(j,C);
% Iex=dI'*3e6;

return


j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);






% global Iex
% Init2M
% RSV2M(1,0)
% % 
% load('Flux4Plasma8','fluxPlasma')
% load('Flux4PF8','fluxPF')
% % PF contribution
% Iex=getPFcurrent;
% PFCoef=fluxPF;
% fluxPF=fluxPF*Iex'; % should transpose
% 
% 
% j=getPlasmaCurrent(fluxPlasma,fluxPF);
% [j,C]=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% [chi2,chi3]=getFieldNullConfC(C);
%  return
%initialization
Init2M

%%
tic
global FilledType
global Iex
Iex=getPFcurrent(6);
FilledType=sign(Iex);
close all
RSV2M(1,0)

load('Flux4Plasma8','fluxPlasma')
load('Flux4PF8','fluxPF')
% PF contribution
PFCoef=fluxPF;
fluxPF=PFCoef*Iex'; % should transpose
j=getPlasmaCurrent(fluxPlasma,fluxPF);
[j,C]=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);


% [dI,y]=getRampUpConsumption(j,C);
% 
% Iex=dI'*3e6;
% [M,jPF]=getPlasmaInductance(j,C,fluxPlasma,PFCoef,Iex);
% 
% 
% FilledType=sign(Iex);
% close all
% RSV2M(1,0)
% % PFFlux(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
% 
% fluxPF=PFCoef*Iex'; % should transpose
% 


j=getPlasmaCurrent(fluxPlasma,fluxPF);
[j,C]=getPlasmaCurrent(fluxPlasma,fluxPF,j);



return

% [M,jPF]=getPlasmaInductance(j,C,fluxPlasma,PFCoef,Iex);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);

dIex=zeros(size(Iex));
t=0;
% input parameter
j=getPlasmaCurrent(fluxPlasma,fluxPF);
[Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D;
Rp=1/3*1e-6; % uOhm
dt=10e-3; % ms
dIp=0; %platform
for i=1:100
    j=getPlasmaCurrent(fluxPlasma,fluxPF);
    j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
    [j,C]=getPlasmaCurrent(fluxPlasma,fluxPF,j);
    
    L=j'*fluxPlasma*j;
    dIex=i2iEvolution(Iex,Ip,dIp,dt,Rp,L,PFCoef,C);
    Iex=Iex+dIex';
    iPF(i,:)=Iex;
    t=t+dt;
    tc(i)=t;
    fluxPF=fluxPF+PFCoef*dIex;
end

t=tc;
save('PFevolution','t','iPF')
toc
close all
PFindex='1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18';
myCommand=['RSV2M(1,0,{' PFindex '});'];
eval(myCommand);


% [M,delI]=getPlasmaInductance(j,indexInside,C);
% fluxPF=fluxPF+PFCoef*delI;

j=getPlasmaCurrent(fluxPlasma,fluxPF);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
toc
return


% 2013/11/30 limiter
global FilledType
global Iex
Iex=getPFcurrent;
FilledType=sign(Iex);
close all
RSV2M(1,0)

% load('Flux4Plasma8','fluxPlasma')
% load('Flux4PF8','fluxPF')
% 
% 
% setappdata(0,'fluxPlasma',fluxPlasma)
% setappdata(0,'fluxPF',fluxPF)


fluxPlasma=getappdata(0,'fluxPlasma');
fluxPF=getappdata(0,'fluxPF');


% PF contribution
PFCoef=fluxPF;
fluxPF=PFCoef*Iex'; % should transpose
j=getPlasmaCurrent(fluxPlasma,fluxPF);
[j,C]=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
return
















load('Flux4PF','fluxPF')
% PF contribution
Iex=getPFcurrent;
fluxPF=fluxPF*Iex'; % should transpose
[X1,Y1]=getGrid;
PFindex='1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18';
myCommand=['RSV2M(1,0,{' PFindex '});'];
eval(myCommand);

fluxPF=reshape(fluxPF,size(X1));%

[C,h] = contour(X1,Y1,fluxPF);%,10);-1e-5 -9e-6 -8e-6-7e-6 -6.8e-6 -6.5e-6       

index=find(X1<2.3);
index1=find(abs(Y1)<1.3);
index=intersect(index,index1);
dphi=max(fluxPF(index))-min(fluxPF(index));

return
 
%% 
y=setGSdata;
return
