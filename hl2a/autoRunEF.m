function y= autoRunEF(handles)
%% 
% AUTORUNEF the short description(H1 line help)
% SYNTAX
% [output] = AUTORUNEF(A)
% option=1 means the item is necessary, option=0 means the item is optional
% input
% option  VarName             DataType           Meaning
% 0       V                   int/double         the loop voltage in V
% 0       num                 int                the number of element
%
% output:
% option    VarName             DataType        Meaning      
% 0         X                    double          X coordinates
% 0         Y                    double          Y coordinates
% 0         I                    double          The total current in A
% 0         S                    double          current density in A/m2
% 0         L                    double    the length from the start point
% 
% 
% INPUT PARAMETERS
% if nargin==0
% elseif nargin==1
%     C=varargin{1};
% elseif nargin==2
%     C=varargin{1};
%     C=varargin{2};
% elseif nargin==3
%     C=varargin{1};
%     C=varargin{2};
%     C=varargin{3};
% elseif nargin>3
%     disp('too many input parameters for function autoRunEF')
% end
%
% DESCRIPTION
% Exhaustive and long description of functionality of autoRunEF.
%
% Examples:
% description of example for autoRunEF
% >> [output] = autoRunEF(A);
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
% Version 1.0 , Created on: 05-Dec-2014 11:38:02

% write down your codes from here.
pauseTime=0;  % second
gFit=getappdata(0,'gFit');
CurrentShot=str2double(get(handles.ShotNumber,'String'));
for i=1:5000
    CurrentShot=CurrentShot+1;
    EfitFile=[gFit.pathEF '\exp\outFit' num2str(CurrentShot) '.mat'];
    if  exist(EfitFile,'file')==2   %  efit file already
        pause(pauseTime)
    else
        CurrentInfoFile = getInfFileName(CurrentShot,'FBC');
        if  exist(CurrentInfoFile,'file')==2   % discharge file already
            efitSimulation(handles,CurrentShot)
        else
            pause(pauseTime)
        end
    end
end
y=0;
    return
    



% OUTPUT PARAMETERS
% if nargout==1
%     varargout{1}=R;
% elseif nargout==2
%     varargout{1}=R;
%     varargout{2}=S;
% elseif nargout==3
%     varargout{1}=R;
%     varargout{2}=S;
%     varargout{3}=V;
% elseif nargout>3
%     disp('too many output parameters for function autoRunEF')
% end
