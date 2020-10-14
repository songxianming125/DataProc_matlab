function y=EquSN3A

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
shapeType='SN';


[Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D(shapeType);
Iex=getPFcurrent(shapeType);
FilledType=sign(Iex);
RSV2M(1,0)
isDraw=1;

fluxByPF=fluxPF*Iex'; % should transpose

j=getPlasmaCurrent(fluxPlasma,fluxByPF);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
j=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
[jSN,CSN]=getPlasmaCurrent(fluxPlasma,fluxPF,j);

save('jAndCSN','jSN','CSN')
load('jAndCSN','jSN','CSN')

% [chi3,iPF1]=getFieldNullConfC(C2);
% 
% save('iPF1','iPF1') % z=1.1  0.0119 phi=9.4587
% factor=110000/iPF1(1);
% Iex=factor*iPF1;

%%
% [iPF3,y]=getRampUpConsumption(jSN,CSN);  %dip=1A
% M=j'*PFCoef;  %mutual inductance
% Phi=dot(M,iPF3);
% 
% 
% save('iPF3SN','iPF3','Phi')
% Iex=iPF3*3e6;






%% 
iCS=-47061/3e6;

[iPF3,y]=getPF4EdgePhi(jSN,CSN,iCS);  %dip=1A, fix iCS
M=j'*PFCoef;  %mutual inductance

iPF3=[iCS;iCS;iPF3]; % add iCS again
Phi=dot(M,iPF3);


save('iPF3SN','iPF3','Phi')
Iex=iPF3*3e6;
r=Iex/Iex(1)
save('Ratio','r')


return


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
[Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D('SN');
Iex=getPFcurrent;
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
[jSN,CSN]=getPlasmaCurrent(fluxPlasma,fluxPF,j);

save('jAndCSN','jSN','CSN')
load('jAndCSN','jSN','CSN')

% [chi3,iPF1]=getFieldNullConfC(C2);
% 
% save('iPF1','iPF1') % z=1.1  0.0119 phi=9.4587
% factor=110000/iPF1(1);
% Iex=factor*iPF1;
[iPF3,y]=getRampUpConsumption(jSN,CSN);  %dip=1A
M=j'*PFCoef;  %mutual inductance
Phi=dot(M,iPF3);


save('iPF3SN','iPF3','Phi')
Iex=iPF3*3e6;
return

%% test the simulation result
y=testSimulation(3000);

%% test over



%% obtain shape configuration
global Ip Xp betap alphaIndex
global Iex

Init2M
load('iPF3SN','iPF3','Phi')
Iex=iPF3*3e6;
Iex=Iex';
FilledType=sign(Iex);
RSV2M(1,0)

%% get plasma shape
fluxPlasma=getappdata(0,'fluxPlasma');
fluxPF=getappdata(0,'fluxPF');
if isempty(fluxPlasma)
load('Flux4Plasma8','fluxPlasma')
load('Flux4PF8','fluxPF')
setappdata(0,'fluxPlasma',fluxPlasma)
setappdata(0,'fluxPF',fluxPF)
end

PFCoef=fluxPF;
fluxPF=PFCoef*Iex'; % should transpose

[Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D;



load('jAndCSN','jSN','CSN')
j=getPlasmaCurrent(fluxPlasma,fluxPF,jSN);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
[jSN,CSN]=getPlasmaCurrent(fluxPlasma,fluxPF,j);


return
%% over







% t=3 s;
% load('iPF3SN','iPF3','Phi')
% Iex=iPF3*3e6;
% return


