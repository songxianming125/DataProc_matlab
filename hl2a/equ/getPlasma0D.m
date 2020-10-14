function [Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D(varargin)
%%
%       This program set the zero dimension parameters of plasma                  
%       Developed by Song xianming 2013.11.16 
%
% input description
% alphaIndex  GS power index for get plasma current density

alphaIndex=1; %power in normalized phi

switch varargin{1}
    case 'SN'
        % single null 3MA t=3.0s
        Ip=0.154*1.0e6;% MA or MA/s
        ap=0.40;% max=0.5  minor radius a
        chi=1;%elongation
        tri=0.2;%triangularity
        betap=0.6;
        li=0.8;
        %plasma position
        Xp=1.68;
        Yp=0;
    case 'DN'
        % double null 3MA t=3.0s
        Ip=3.0*1.0e6;% MA or MA/s
        ap=0.655;% max=0.5  minor radius a
        chi=1.856;%elongation
        tri=0.62;%triangularity
        betap=0.6;
        li=0.8;
        %plasma position
        Xp=1.78;
        Yp=0.0;
end












% %% limiter  t=3.0s limiter
% Ip=3.0*1.0e6;% MA or MA/s
% ap=0.651;% max=0.5  minor radius a
% chi=1.481;%elongation
% tri=0.339;%triangularity
% betap=0.6;
% li=0.8;
% % plasma position
% Xp=1.781;
% Yp=0.0;
% alphaIndex=1; %current density expression
% 



% %% limiter t=1.47
% Ip=1.36*1.0e6;% MA or MA/s
% ap=0.613;% max=0.5  minor radius a
% chi=1.392;%elongation
% tri=0.233;%triangularity
% betap=0.25;
% li=0.8;
% % plasma position
% Xp=1.743;
% Yp=0.0;
% alphaIndex=1; %current density expression
% 
% 
% 





% %% limiter t=0.76
% Ip=0.6*1.0e6;% MA or MA/s
% ap=0.54;% max=0.5  minor radius a
% chi=1.28;%elongation
% tri=0.1;%triangularity
% betap=0.1;
% li=0.8;
% % plasma position
% Xp=1.67;
% Yp=0.0;
% alphaIndex=1; %current density expression
% 



% 
% %% limiter t=3
% Ip=3*1.0e6;% MA or MA/s
% 
% ap=0.651;% max=0.5  minor radius a
% chi=1.481;%elongation
% tri=0.339;%triangularity
% betap=0.6;
% li=0.8;
% % plasma position
% Xp=1.781;
% Yp=0.0;
% alphaIndex=1; %current density expression
% 










%%
%field area
% double null 3MA

% Ip=1.36*1.0e6;% MA or MA/s
% ap=0.629;% max=0.5  minor radius a
% chi=1.92;%elongation
% tri=0.58;%triangularity
% betap=0.8;
% li=0.8;
% %plasma position
% Xp=1.78;
% Yp=0.0;
% alphaIndex=0.7; %current density expression
% return







% 
% 
% 
% delta=0.02;%shafranov shift
% Lsol=0.03; % SOL thickness for parabolic distribution
% % filament parameter
% alpha=pi/4; %
% Rstep=0.1;

%%

