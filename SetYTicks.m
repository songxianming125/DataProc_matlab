function nAxis=SetYTicks(varargin)
%% SET Y axis ticks
% SetYTicks(varargin)
% GapMode=varargin{1}; 0=no gap; 1=with gap
% n=varargin{2};  an odd number for ticknumber


if nargin>0
    GapMode=varargin{1};
else
    GapMode=0;
end
haxis= findobj(gcf,'Type','axes');
nAxis=length(haxis);

varargin(1)={haxis(1)};
setLayout(haxis,GapMode);

for i=1:nAxis
    varargin(1)={haxis(i)};
    Yy=SetYTick(varargin{:});
end
