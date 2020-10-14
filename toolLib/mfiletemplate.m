function [varargout] = $filename$(varargin)
%% 
% $capsfilename$ the short description(H1 line help)
% SYNTAX
% [output] = $capsfilename$(A)
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
%     disp('too many input parameters for function $filename$')
% end
%
% DESCRIPTION
% Exhaustive and long description of functionality of $filename$.
%
% Examples:
% description of example for $filename$
% >> [output] = $filename$(A);
%
% See also:
% ALSO1, ALSO2
%
% References:
% [1] A. Einstein, Die Grundlage der allgemeinen Relativitaetstheorie,
%     Annalen der Physik 49, 769-822 (1916).
% Author: $author$
% Email: $email$
% Copyright (c) %Southwestern Institute of Physic, PO. Box 432#, Chengdu, China. 1966-$year$
% All Rights Reserved.
% $Version$ , $creationdate$

% write down your codes from here.




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
%     disp('too many output parameters for function $filename$')
% end
