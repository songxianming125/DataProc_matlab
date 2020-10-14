function [varargout] = getBoundaryGreenFnBfield(varargin)
%% 
% GETBOUNDARYGREENFNBFIELD the short description(H1 line help)
% SYNTAX
% [output] = GETBOUNDARYGREENFNBFIELD(A)
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
    C=varargin{1};
    C=varargin{2};
    C=varargin{3};
elseif nargin>3
    disp('too many input parameters for function getBoundaryGreenFnBfield')
end
%
% DESCRIPTION
% Exhaustive and long description of functionality of getBoundaryGreenFnBfield.
%
% Examples:
% description of example for getBoundaryGreenFnBfield
% >> [output] = getBoundaryGreenFnBfield(A);
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
% Version 1.0 , Created on: 12-May-2014 16:23:21

% write down your codes from here.

switch  pointType
    case 0 % plasma boundary
        
        BX=getappdata(0,'BXboundary'); %for PF coils
        BY=getappdata(0,'BYboundary');
        BXp=getappdata(0,'BXpboundary'); %for plasma
        BYp=getappdata(0,'BYpboundary');
        oldPoint=getappdata(0,'oldBfieldboundary');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        
        if ~isempty(BX) && size(Point,2)==size(BX,1) && sum(oldPoint(:))<0.01 % point is not the same
        else
            [BX,BY,BXp,BYp]=getFieldAtBoundary(Point);
            setappdata(0,'BXboundary',BX)
            setappdata(0,'BYboundary',BY)
            setappdata(0,'BXpboundary',BXp)
            setappdata(0,'BYpboundary',BYp)
            setappdata(0,'oldBfieldboundary',Point)
        end
    case 1 % diagnostic position
        
        BX=getappdata(0,'BXDiag'); %for PF coils
        BY=getappdata(0,'BYDiag');
        BXp=getappdata(0,'BXpDiag'); %for plasma
        BYp=getappdata(0,'BYpDiag');
        oldPoint=getappdata(0,'oldBfieldDiag');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        
        if ~isempty(BX) && size(Point,2)==size(BX,1) && sum(oldPoint(:))<0.01 % point is not the same
        else
            [BX,BY,BXp,BYp]=getFieldAtBoundary(Point);
            setappdata(0,'BXDiag',BX)
            setappdata(0,'BYDiag',BY)
            setappdata(0,'BXpDiag',BXp)
            setappdata(0,'BYpDiag',BYp)
            setappdata(0,'oldBfieldDiag',Point)
        end
    case 3 % diagnostic position
        BX=getappdata(0,'BXLimiter'); %for PF coils
        BY=getappdata(0,'BYLimiter');
        BXp=getappdata(0,'BXpLimiter'); %for plasma
        BYp=getappdata(0,'BYpLimiter');
        oldPoint=getappdata(0,'oldBfieldLimiter');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        
        if ~isempty(BX) && size(Point,2)==size(BX,1) && sum(oldPoint(:))<0.01 % point is not the same
        else
            [BX,BY,BXp,BYp]=getFieldAtBoundary(Point);
            setappdata(0,'BXLimiter',BX)
            setappdata(0,'BYLimiter',BY)
            setappdata(0,'BXpLimiter',BXp)
            setappdata(0,'BYpLimiter',BYp)
            setappdata(0,'oldBfieldLimiter',Point)
        end
    case 4 % VV
        BX=getappdata(0,'BXVV'); %for PF coils
        BY=getappdata(0,'BYVV');
        BXp=getappdata(0,'BXpVV'); %for plasma
        BYp=getappdata(0,'BYpVV');
        oldPoint=getappdata(0,'oldBfieldVV');
        if ~isempty(oldPoint) 
            if size(oldPoint,2)==size(Point,2)
                oldPoint=abs(oldPoint-Point);
            end
        end
        
        if ~isempty(BX) && size(Point,2)==size(BX,1) && sum(oldPoint(:))<0.01 % point is not the same
        else
            [BX,BY,BXp,BYp]=getFieldAtBoundary(Point);
            setappdata(0,'BXVV',BX)
            setappdata(0,'BYVV',BY)
            setappdata(0,'BXpVV',BXp)
            setappdata(0,'BYpVV',BYp)
            setappdata(0,'oldBfieldVV',Point)
        end
end


% OUTPUT PARAMETERS
if nargout==1
    varargout{1}=R;
elseif nargout==2
    varargout{1}=BX;
    varargout{2}=BY;
elseif nargout==3
    varargout{1}=BX;
    varargout{2}=BY;
    varargout{3}=V;
elseif nargout==4 % ok
    varargout{1}=BX;
    varargout{2}=BY;
    varargout{3}=BXp;
    varargout{4}=BYp;
elseif nargout>4
    disp('too many output parameters for function getBoundaryGreenFnBfield')
end
