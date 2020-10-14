function nAxis=SetYTicks(varargin)
haxis= findobj(gcf,'Type','axes');
nAxis=length(haxis);
for i=1:nAxis
    varargin(1)={haxis(i)};
    Yy=SetYTick(varargin{:});
end
end


