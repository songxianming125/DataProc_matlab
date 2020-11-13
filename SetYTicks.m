function nAxis=SetYTicks(varargin)
haxis= findobj(gcf,'Type','axes');
nAxis=length(haxis);

varargin(end+1)={haxis(1)};
varargin=circshift(varargin,1,2);

for i=1:nAxis
    varargin(1)={haxis(i)};
    Yy=SetYTick(varargin{:});
end
end


