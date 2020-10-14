function [j,C]=jAndC(varargin)
global Ip Xp betap alphaIndex
global Iex


shapeType='DN';


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
[Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D(shapeType);
Iex=getPFcurrent(shapeType);
FilledType=sign(Iex);
RSV2M(1,0)
% 
% 
PFCoef=fluxPF;
fluxPF=PFCoef*Iex'; % should transpose


j=getPlasmaCurrent(fluxPlasma,fluxPF);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
j=getPlasmaCurrent(fluxPlasma,fluxPF,j);
isDraw=1;
[j2,C2]=getPlasmaCurrent(fluxPlasma,fluxPF,j,isDraw);
save([shapeType 'jAndC'],'j2','C2')
load([shapeType 'jAndC'],'j2','C2')




% [y,iPF1]=getFieldNullConfC(C2);

% %%
% iCS=11281;
% iPF4=1446;
% [y,iPF1]=getFieldNullConfC(C2,iCS,iPF4);
% iPF1=[iCS;iCS;iPF1(1:6);iPF4;iPF4;iPF1(7:14)]; % add iCS again
% 
% save('iPF1','iPF1') % z=1.1  0.0119 phi=9.4587
% factor=110000/iPF1(1);
% Iex=factor*iPF1;
% %%

branch=1;
switch branch
    case 0 %
        iCS=110000;
        [y,iPF]=getFieldNullConfCB(C2,iCS);
        Iex=iPF;
        M=j2'*PFCoef;  %mutual inductance
        Phi=dot(M,Iex);
    case 1
        Point=getControlPoint(C2);
        XX=[Point(1,:);Point(1,:)];
        YY=[Point(2,:);Point(2,:)+0.0001];
        
        
        h=plot(XX,YY,'.','LineWidth',1); %plasma
        
        
        
        dPhi1=0.03;
        dPhi2=0.02;
        [y,iPF]=enlongation(C2,dPhi1,dPhi2);
    case 2
    case 3
    case 4
end


%%



close all
FilledType=sign(Iex);
RSV2M(1,0)
save('iPFnull','Iex')

[X,Y]=PFQuiver(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
return


