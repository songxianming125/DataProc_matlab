function [varargout]=p2a(varargin)

if nargin>0
    isAdd=varargin{1};
else
    isAdd=1;
end




% userpath('clear')
% p=mfilename;


p = mfilename('fullpath');
root2A=which(p);
root2A=root2A(1:end-6); %without separator /




if isAdd
    action='addpath';
else
    action='rmpath';
end


% lib
path=[root2A filesep 'hl2a' filesep 'lib'];
command=[action '(path)' ];
eval(command)


% equ
path=[root2A filesep 'hl2a' filesep 'equ'];
command=[action '(path)' ];
eval(command)


% efit
path=[root2A filesep 'hl2a' filesep 'efit'];
command=[action '(path)' ];
eval(command)

% hl2a
path=[root2A filesep 'hl2a'];
command=[action '(path)' ];
eval(command)

% % root
% command=[action '(root2A)' ];
% eval(command)

% toolLib
path=[root2A filesep 'toolLib'];
command=[action '(path)' ];
eval(command)


% sigbuilder
path=[root2A filesep 'sigbuilder'];
command=[action '(path)' ];
eval(command)


% sigbuilder\newfun
path=[root2A filesep 'sigbuilder' filesep 'newfun'];
command=[action '(path)' ];
eval(command)

% sigbuilder\newfun
path=root2A;
command=[action '(path)' ];
eval(command)


% dos
path='C:\Windows\System32';
command=[action '(path)' ];
eval(command)


% % DataProc
% path=regexprep(root2A,'hl2a','DataProc');
% command=[action '(path)' ];
% eval(command)


if isAdd
    userpath(root2A)
else
    userpath('clear')
end




if nargout>0
    varargout{1}=root2A;
end




