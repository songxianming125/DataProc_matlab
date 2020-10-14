function [varargout] = getBoundaryGreenFn(varargin)
%% 
% GETBOUNDARYGREENFN the short description(H1 line help)
% SYNTAX
% [output] = GETBOUNDARYGREENFN(A)
% input: 
% 
% 
% output: 
% 
% 
% INPUT PARAMETERS
if nargin==0
    
elseif nargin==1
    Point=varargin{1};
    pointType=0;
elseif nargin==2
    Point=varargin{1};
    pointType=varargin{2};
elseif nargin==3
    Point=varargin{1};
    pointType=varargin{2};
    C=varargin{3};
elseif nargin>3
    disp('too many input parameters for function getBoundaryGreenFn')
end
%
% DESCRIPTION
% Exhaustive and long description of functionality of getBoundaryGreenFn.
%
% Examples:
% description of example for getBoundaryGreenFn
% >> [output] = getBoundaryGreenFn(A);
%
% See also:
% ALSO1, ALSO2
%
% References:
% [1] A. Einstein, Die Grundlage der allgemeinen Relativitaetstheorie,
%     Annalen der Physik 49, 769-822 (1916).
% Author: Dr. Xianming SONG
% Email: songxm@swip.ac.cn
% Copyright (c) %Southwestern Institute of Physic, PO. Box 432#, Chengdu, China. 1966-2014
% All Rights Reserved.
% Version 1.0 , Created on: 06-May-2014 14:13:49

% write down your codes from here.
%% update Green Function at boundary
% Green function for points at boundary
switch  pointType
    case 0 % Boundary
        fluxPlasmaPoint=getappdata(0,'fluxPlasmaBoundary');
        fluxPFPoint=getappdata(0,'fluxPFBoundary');
        oldPoint=getappdata(0,'oldBoundary');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        if ~isempty(fluxPFPoint) && size(Point,2)==size(fluxPFPoint,1) && sum(oldPoint(:))<0.01 % point is the same
        else
            [fluxPFPoint,fluxPlasmaPoint]=getFluxCoefAtBoundary(Point);
            setappdata(0,'fluxPlasmaBoundary',fluxPlasmaPoint)
            setappdata(0,'fluxPFBoundary',fluxPFPoint)
            setappdata(0,'oldBoundary',Point);
        end
    case 1 % limiter
        fluxPlasmaPoint=getappdata(0,'fluxPlasmaLimiter');
        fluxPFPoint=getappdata(0,'fluxPFLimiter');
        oldPoint=getappdata(0,'oldLimiter');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        if ~isempty(fluxPFPoint) && size(Point,2)==size(fluxPFPoint,1) && sum(oldPoint(:))<0.01 % point is the same
        else
            [fluxPFPoint,fluxPlasmaPoint]=getFluxCoefAtBoundary(Point);
            setappdata(0,'fluxPlasmaLimiter',fluxPlasmaPoint)
            setappdata(0,'fluxPFLimiter',fluxPFPoint)
            setappdata(0,'oldLimiter',Point);
        end
    case 2 % diagnostic position
        fluxPlasmaPoint=getappdata(0,'fluxPlasmaDiag');
        fluxPFPoint=getappdata(0,'fluxPFDiag');
        oldPoint=getappdata(0,'oldDiag');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        if ~isempty(fluxPFPoint) && size(Point,2)==size(fluxPFPoint,1) && sum(oldPoint(:))<0.01 % point is the same
        else
            [fluxPFPoint,fluxPlasmaPoint]=getFluxCoefAtBoundary(Point);
            setappdata(0,'fluxPlasmaDiag',fluxPlasmaPoint)
            setappdata(0,'fluxPFDiag',fluxPFPoint)
            setappdata(0,'oldDiag',Point);
        end
end



% OUTPUT PARAMETERS
if nargout==1
    varargout{1}=fluxPlasmaPoint;
elseif nargout==2
    varargout{1}=fluxPlasmaPoint;
    varargout{2}=fluxPFPoint;
elseif nargout==3
    varargout{1}=fluxPlasmaPoint;
    varargout{2}=fluxPFPoint;
    varargout{3}=V;
elseif nargout>3
    disp('too many output parameters for function getBoundaryGreenFn')
end
