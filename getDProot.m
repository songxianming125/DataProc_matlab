function y=getDProot(varargin)
myPath = mfilename('fullpath');
k = strfind(myPath, filesep);
y=myPath(1:k(end)-1);
if nargin>0
    for i=1:nargin
        y=[y filesep varargin{i}];
    end
end

