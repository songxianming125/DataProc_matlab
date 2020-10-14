function hBrowser = showCurveGroup(U,t,Names,Units,varargin)
%% 
% SHOWCURVEGROUP the short description(H1 line help)
% SYNTAX
% [output] = SHOWCURVEGROUP(A)
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
if nargin>4
    workingIndex=varargin{1};
else
    workingIndex=1:length(Names);
end
%
% DESCRIPTION
% Exhaustive and long description of functionality of showCurveGroup.
%
% Examples:
% description of example for showCurveGroup
% >> [output] = showCurveGroup(A);
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
% Version 1.0 , Created on: 15-Apr-2015 15:17:00

% write down your codes from here.

    
    y=U(:,workingIndex);
    chanLists=Names(workingIndex);
    t=t;
    u=Units(workingIndex);
    
    
    %     s = putIntoDP(t,U,Names,Units);
    %     y=U(:,workingIndex);
    %     chanLists=Names;
    %     t=t;
    %     u=Units;
    
    title=[ 'total channels' num2str(length(chanLists))];
    axesNum=6;
    numChannels=length(chanLists);
    numTimes=length(t);
    handleBrowser.tLimit=[t(1) t(end)];
    handleBrowser.t=num2cell(repmat(t,[1 numChannels]),1);  %  vectors
    handleBrowser.y=num2cell(y,1);  %   vectors
    handleBrowser.u=u;  %   vectors
    handleBrowser.yLabel=chanLists;  % vectors
    handleBrowser.axesNum=axesNum;  % vectors
    handleBrowser.numChannels=numChannels;  % vectors
    handleBrowser.numTimes=numTimes;  % vectors
    handleBrowser.title=title;  % vectors
    hBrowser=showData(handleBrowser);



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
%     disp('too many output parameters for function showCurveGroup')
% end
