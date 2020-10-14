function y=getPath(varargin)
if nargin>0
    myPath=which(varargin{1});
    k = strfind(myPath, filesep);
    if ~isempty(k)
        y=myPath(1:k(end)-1);
    else
        msgbox('Init2M is not find','2M package is not ready','error');
        return
    end
else
    y=pwd;
end




if nargin>1
    for i=1:nargin
        y=[y filesep varargin{i}];
    end
end

