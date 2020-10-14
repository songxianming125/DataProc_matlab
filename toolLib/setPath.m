function [varargout]=setPath(varargin)

if nargin>0
    myPath=which(varargin{1});
    k = strfind(myPath, filesep);
    if ~isempty(k)
       myPath=myPath(1:k(end)-1);
    else
        msgbox('Init2M is not find','2M package is not ready','error');
        return
    end
else
    myPath=pwd;
end
addpath(myPath)



if nargin>1
    for i=1:nargin
        myPath=[myPath filesep varargin{i}];
    end
end

addpath(myPath)

varargout{1}=myPath;