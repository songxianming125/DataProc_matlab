
% field coordinates
function p=DrawBackground(varargin)


if nargin>0
  Limiter=varargin{1};
else
  Limiter=0.4;
end

if nargin>1
  hfig=varargin{2};
  figure(hfig)
else
    scrsz = get(0,'ScreenSize');
    set(gcf,'Units','pixels')
    set(gcf,'Position',[scrsz(3)/3 scrsz(2)+20 scrsz(3)/3 scrsz(4)/1.1])
    set(gca,'position',[.06  .06  .8  .88])
end



hold on


p=DrawMpPosition(0,0);
p=DrawMcPosition(0,0);%MC Location (u l)
p=DrawVFPosition(1);   %draw the MP coil position
p=DrawOHPosition(1);   %draw the MP coil position
p=DrawRFPosition(1);
p=DrawVVandPlate(1,Limiter);
axis xy
axis manual;
axis equal;
axis([0.8 2.6 -1.5 1.5])
box on
M=1;
