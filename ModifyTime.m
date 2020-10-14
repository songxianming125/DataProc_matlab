function [varargout] = ModifyTime(hObject, eventdata,handles)
%% 
global ha MyCurves hfig
% EDITCURVE the short description(H1 line help)
% SYNTAX
% [output] = EDITCURVE(A)
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
%     disp('too many input parameters for function EditCurve')
% end
%
% DESCRIPTION
% Exhaustive and long description of functionality of EditCurve.
%
% Examples:
% description of example for EditCurve
% >> [output] = EditCurve(A);
%
% See also:
% ALSO1, ALSO2
%
% References:
% [1] A. Einstein, Die Grundlage der allgemeinen Relativitaetstheorie,
%     Annalen der Physik 49, 769-822 (1916).
% Author: Dr. Xianming SONG
% Email: songxm@swip.ac.cn
% Copyright (c) %Southwestern Institute of Physic, PO. Box 432#, Chengdu, China. 1966-2015
% All Rights Reserved.
% Version 1.0 , Created on: 30-May-2015 16:25:46

% write down your codes from here.
currentLine=getappdata(0,'currentLine');
if isempty(currentLine)
    currentLine=1;
end



dlg_title = 'Modify the time windows';
prompt = {'Curve Number','xFactor','xOffset'};
def   = {num2str(currentLine),'1',  '0'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);

if strcmpi(answer{1},'all')
    for currentLine=1:length(MyCurves)
        x=MyCurves(currentLine).x;
        x=x*str2num(answer{2})+str2num(answer{3}); %#ok<ST2NM>
        MyCurves(currentLine).x=x;
    end
else
    currentLine=str2double(answer{1});
    x=MyCurves(currentLine).x;
    x=x*str2num(answer{2})+str2num(answer{3}); %#ok<ST2NM>
    MyCurves(currentLine).x=x;
end
DrawCurves_Callback(hfig, eventdata, handles)




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
%     disp('too many output parameters for function EditCurve')
% end
