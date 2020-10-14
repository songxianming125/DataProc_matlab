function vb(varargin)
if nargin>0
    v=varargin{1};
else
    v=1;
end

setappdata(0,'verbose',v);
end

