function [varargout] = putIntoDP(varargin)
%% 
% PUTINTODP the short description(H1 line help)
% SYNTAX
% [output] = PUTINTODP(A)
% input: 
% 
% 
% output: 
% 
% 
% INPUT PARAMETERS
global handles

if nargin==0
elseif nargin==1
    C=varargin{1};
elseif nargin==2
    C=varargin{1};
    C=varargin{2};
elseif nargin==3
    t=varargin{1};
    channels=varargin{2};
    names=varargin{3};
elseif nargin==4
    t=varargin{1};
    channels=varargin{2};
    names=varargin{3};
    units=varargin{4};
elseif nargin>4
    disp('too many input parameters for function putIntoDP')
end
%

% write down your codes from here.
numChannels=length(names);

for i=1:numChannels
myCommand=['eventdata.x=t;'];
eval(myCommand)
myCommand=['eventdata.y=channels(:,' num2str(i) ');'];
eval(myCommand)
myCommand=['eventdata.z=[];'];
eval(myCommand)
myCommand=['eventdata.n=''' names{i} ''';'];
eval(myCommand)
myCommand=['eventdata.s=[];'];
eval(myCommand)
myCommand=['eventdata.u=''' units{i} ''';'];
eval(myCommand)
addChnl([], eventdata, handles)    
end



% OUTPUT PARAMETERS
if nargout==1
    varargout{1}=0;
elseif nargout==2
    varargout{1}=R;
    varargout{2}=S;
elseif nargout==3
    varargout{1}=R;
    varargout{2}=S;
    varargout{3}=V;
elseif nargout>3
    disp('too many output parameters for function putIntoDP')
end
