function [varargout]=GetPlasmaPara(gFit,Fit)
%% ********************************************************%%%
% This program is to Set the parameter of plasma       %%%
%                                                        %%%
%      Developed by Song xianming 2008/08/19/            %%%
%********************************************************%%%
%********************************************************%%%
%%
%% modified by input
% global Ip ap chi tri Xp Yp delta Lsol alpha Rstep


    Ip=Fit.Ip;
    ap=gFit.ap;
    chi=gFit.chi;
    tri=gFit.tri;
    
    Xp=Fit.Xp;
    Yp=Fit.Yp;
    
    delta=gFit.delta;

    Lsol=gFit.Lsol;
    alpha=gFit.alpha;
    Rstep=gFit.Rstep;


%default value of Plasma parameters
%%
% ap=0.4;
% chi=1.0;
% tri=0;
% 
% 
% delta=0.02;%shafranov shift
% Lsol=0.03; % SOL thickness for parabolic distribution
% 
% % filament parameter
% alpha=pi/4; %
% Rstep=0.1;
% Xp=1.65;
% Yp=-0.05;



%center of plasma
X=Xp;
Y=Yp;
factor=1;
nLevel=floor(ap/Rstep);




%%

for i=1:nLevel
    Xp1=Xp-(i/nLevel)*delta;%shafranov shift
    theta=alpha/i/2:alpha/i/2:2*pi;
    theta1=2*theta;
    ind= pi < theta1 & theta1 < 3*pi;
    theta1(ind)=0;
    Rplasma=Rstep*i*(1-(i/nLevel)*tri*abs(sin(theta1)).^1.6/3);%triangularity affect the radius
    
    Y=[Y Yp+chi.*Rplasma.*sin(theta)];
    X=[X Xp1+Rplasma.*cos(theta)-(i/nLevel)*Rplasma.*(1-abs(cos(theta).^1.6))*tri];% triangularity
    %parabolic distribution
    factor=[factor;ones(length(theta),1).*(1-((Rstep*i)/(ap+Lsol))^2)]; %SOL thickness affect current distribution
end

I=factor.*Ip./sum(factor(:));
%%
if nargout>2
    varargout{1}=X;
    varargout{2}=Y;
    varargout{3}=I;
end
if nargout>3
%     varargout{4}=length(theta);
    varargout{4}=linspace(1,1,numel(X))*Rstep*0.46;
end
