function [jPlasma,varargout]=getPlasmaCurrent(j,gFit,Fit,varargin)
%%
%       This program is to solve the Grad-Shafranov equation in Green Function way  (integration way)                  
%       Developed by Song xianming 2013.8.30           


%% argument in
if nargin>=4
    betap=varargin{1};
else
    betap=Fit.betap;
end


X1=gFit.X1;  % Matrix, X1 in grid
Y1=gFit.Y1;  % Matrix, Y1 in grid

fluxPlasma=gFit.fluxPlasma; % Green function for flux contributed by Plasma
Iex=Fit.Iex; % PF current

Ip=Fit.Ip; % plasma current
alphaIndex=gFit.alphaIndex; % the index of equilibrium iteration for GAQ model


%%  draw grid area
%% over 
Flux=Fit.fluxByPF; % PF contribution
% add plasma contribution
if ~isempty(j)
    jPlasma=j*Ip;
else
    j=initPlasmaCurrent(gFit,Fit);
    jPlasma=j*Ip;
end


%  up down symmetry is mandatory for DN
% if strcmpi(shapeType,'qqDN')
%     jPlasma1=reshape(jPlasma,size(X1));
%     jPlasma1=(jPlasma1+flipud(jPlasma1))/2;
%     jPlasma=jPlasma1;  %grid
% end


if isempty(jPlasma)
    error('no initial plasma current for flux calculation/on line %d',55)
    C=[];
    C1=[];
    index=[];
else
    jPlasma=reshape(jPlasma,[numel(X1) 1]);  %grid
    Flux=Flux+fluxPlasma*jPlasma;  % PF + plasma contribution
    
    
    M=reshape(Flux,size(X1));%

    
    %%
    % calculate the flux of limiter need Iex and jPlasma, limiter position
    
    fluxPlasmaLimiter=gFit.fluxPlasmaLimiter; % green function for flux in limiter contributed by plasma
    fluxPFLimiter=gFit.fluxPFLimiter; % green function for flux in limiter contributed by PF
    
    MLimiter=fluxPFLimiter*Iex'+fluxPlasmaLimiter*jPlasma;
    if nargout>=2
        [M,index,C,C1,v,phiCenter]=IdentifyPlasma(gFit,M,MLimiter);
    else
        [M,index,C]=IdentifyPlasma(gFit,M,MLimiter);
    end
    
    %% only need 
    
    
    
    %% GAQ model for equilibrium
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
end
%% output new data
% Fit
if nargout>=2
    varargout{1}=M;
end
if nargout>=3
    varargout{2}=C;
end

if nargout>=4
    varargout{3}=C1;
end
if nargout>=5
    varargout{4}=v;
end
if nargout>=6
    varargout{5}=index;
end
if nargout>=7
    varargout{6}=phiCenter;
end
return


%% draw jPlasma
% 
sourceLen=numel(index);
X2=reshape(X1(index),1,sourceLen);%
Y2=reshape(Y1(index),1,sourceLen);%
jPlasma4Draw=reshape(jPlasma(index),sourceLen,1);%

factor=jPlasma4Draw/max(jPlasma4Draw(:));
factorthree=[factor factor/2 1-factor];
mycolor=mat2cell(factorthree,[linspace(1,1,sourceLen)],[3]);

% draw the same number vertical line
XX=[X2;X2];
YY=[Y2;Y2+0.0001];


h=plot(XX,YY,'.','LineWidth',1); %plasma
set(h,{'Color'},mycolor)
 

