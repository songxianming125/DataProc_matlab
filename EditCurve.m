function [varargout] = EditCurve(hObject, eventdata,handles)
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
 xLim=get(ha(1),'XLim');



dlg_title = 'Edit the curve for target value';
prompt = {'Curve Number','yFactor','yOffset','Type 1=pulse,2=triangle,3=sin,4=ran','click twice to select time window'};
def   = {num2str(currentLine),'1',  '0', '1','select the start and end'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
currentLine=str2double(answer{1});

x=MyCurves(currentLine).x;
y=MyCurves(currentLine).y;



[xStart1,~]=ginput(1);
[xEnd1,~]=ginput(1);

xStart=min(xStart1,xEnd1);
xEnd=max(xStart1,xEnd1);


indexStart=interp1(x,[1:length(x)],xStart,'nearest');
indexEnd=interp1(x,[1:length(x)],xEnd,'nearest');

switch answer{4}
    case '1' %pulse
        y(indexStart:indexEnd)=y(indexStart:indexEnd)*str2num(answer{2})+str2num(answer{3});
    case '2' % triangle
        index=indexStart:indexEnd;
        offSet=str2num(answer{3});
        if length(index)>5
            iLen=length(index);
            iMiddle=ceil((indexEnd-indexStart)/2);
            
            indexMiddle=indexStart+ceil((indexEnd-indexStart)/2);
            yOffset(1:iMiddle)=(1:iMiddle)*offSet/iMiddle;
            yOffset(iMiddle+1:iLen)=(iLen-iMiddle:-1:1)*offSet/iMiddle;
        else
            yOffset=offSet;
        end
        y(indexStart:indexEnd)=y(indexStart:indexEnd)*str2num(answer{2})+yOffset';
        
    case '3'  %sin
        index=indexStart:indexEnd;
        offSet=str2num(answer{3});
        if length(index)>5
            iLen=length(index);
            yOffset=offSet*sin(pi*(1:iLen)/iLen);
        else
            yOffset=offSet;
        end
        y(indexStart:indexEnd)=y(indexStart:indexEnd)*str2num(answer{2})+yOffset';
    case '4'  %ran
        index=indexStart:indexEnd;
        offSet=str2num(answer{3});
        if length(index)>5
            iLen=length(index);
            yOffset=offSet*(0.5-rand(1,iLen));
        else
            yOffset=offSet;
        end
        y(indexStart:indexEnd)=y(indexStart:indexEnd)*str2num(answer{2})+yOffset';
end
MyCurves(currentLine).y=y;
DrawCurves_Callback(hfig, eventdata, handles)

setappdata(0,'currentLine',currentLine);

