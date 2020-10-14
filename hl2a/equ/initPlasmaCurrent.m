function jPlasma=initPlasmaCurrent(gFit,Fit)
%%
%       This program is to calculate                     %%%
%    the Magnetic flux of PF coils and plasma  %%%
%      Developed by Song xianming 2013.8.30            %%%
%********************************************************%%%
%********************************************************%%%
%********************************************************%%%
%%
% gFit.isDraw=0;
alphaIndex=gFit.alphaIndex; % the index of equilibrium iteration for GAQ model
X1=gFit.X1;  % Matrix, X1 in grid
Y1=gFit.Y1;  % Matrix, Y1 in grid

%% argument in
% 
% fluxByPF=Fit.fluxByPF; % flux contributed by PF
% fluxPlasma=gFit.fluxPlasma; % Green function for flux contributed by Plasma
% fluxPF=Fit.fluxPF; % Green function for flux contributed by PF

Iex=Fit.Iex; % PF current
Ip=Fit.Ip; % plasma current
betap=Fit.betap; % plasma betap
Flux=Fit.fluxByPF; % PF contribution


%%  draw grid area
%% over 



% global Ip Xp betap Iex alphaIndex limiterRadius

% double null 3MA
% Iex=getPFcurrent;
% [Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D;


Flux=reshape(Flux,size(X1));
%add plasma contribution
if Ip~=0
    [X4,Y4,I4]=GetPlasmaPara(gFit,Fit);%plasma as source
    Flux=Flux+MMutInductance(X1,Y1,X4,Y4,I4);  %induced by plasma
end

% PFindex='1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18';
% myCommand=['RSV2M(1,0,{' PFindex '});'];
% eval(myCommand);


M=Flux;


% flux on limiter 
Point=gFit.Point;
factor=0.23;
gapX=(X1(1,2)-X1(1,1))*factor;  %grid gap

MLimiter=gFit.fluxPFLimiter*Iex'+(MMutInductance(Point(1,:),Point(2,:),X4,Y4,I4,gapX))'; %PF + plasma contribution
% initPlasma=1;

[M,index,C]=IdentifyPlasma(gFit,M,MLimiter,10);



if isempty(C)
    jPlasma=[];
else
    Xp=(min(C(1,2:end))+max(C(1,2:end)))/2;  % geometric center
    
    jPlasma=zeros(size(M));
    jPlasma(index)=(betap.*X1(index)./Xp+(1-betap).*Xp./X1(index)).*(M(index)).^alphaIndex;
    totalJ=sum(jPlasma(:));
    jPlasma=jPlasma/totalJ;
    jPlasma=reshape(jPlasma,numel(jPlasma),1);%
end

return


% return
%% draw jPlasma

% sourceLen=numel(index);
% X2=reshape(X1(index),1,sourceLen);%
% Y2=reshape(Y1(index),1,sourceLen);%
% jPlasma4Draw=reshape(jPlasma(index),sourceLen,1);%
% 
% factor=jPlasma4Draw/max(jPlasma4Draw(:));
% factorthree=[factor factor/2 1-factor];
% mycolor=mat2cell(factorthree,[linspace(1,1,sourceLen)],[3]);
% 
% % draw the same number vertical line
% XX=[X2;X2];
% YY=[Y2;Y2+0.0001];
% 
% 
% h=plot(XX,YY,'.','LineWidth',1); %plasma
% set(h,{'Color'},mycolor)
% %  
% 

