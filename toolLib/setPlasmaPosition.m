function y=setPlasmaPosition(varargin)
%% set plasma center for function GetPlasmaPara
% This program is to Set the parameter of plasma       %%%
%                                                        %%%
%      Developed by Song xianming 2014/05/19/            %%%
%********************************************************%%%
global Xp Yp
%% modified by input
if nargin>0
    Xp=varargin{1};
end

if nargin>1
    Yp=varargin{2};
end
y=0;
