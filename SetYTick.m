function Yy=SetYTick(varargin)
%%%********************************************************%%%
%%%       This program is setting the favorite YTick       %%%
%%%       Developed by Dr SONG Xianming 2020/05/04/        %%%
%%%********************************************************%%%

%% default values
ha=gca;
n=3;
defRightDigit=1;
GapMode=0;
yTickMarginMode=1.1;
yLim=[];

if nargin>=1 && ~isempty(varargin{1})
    ha=varargin{1};
end
if nargin>=2 && ~isempty(varargin{2})
    n=varargin{2};
end
if nargin>=3 && ~isempty(varargin{3})
    defRightDigit=varargin{3};
end
if nargin>=4 && ~isempty(varargin{4})
    GapMode=varargin{4};
end

if nargin>=5 && ~isempty(varargin{5})
    yTickMarginMode=varargin{5};
end

if nargin>=6 && ~isempty(varargin{6})
    yLim=varargin{6};
else
    yLim=get(ha,'YLim');
end

n2=2*n;

yMax=yLim(2);
yMin=yLim(1);
dY=yMax-yMin;
%  conditionning, when no difference
if dY==0
    yMax=yMax+1;
    dY=1;
end



% find the power of ratio factor
rn = floor(log10(dY));
pr = realpow(10,rn);


step=dY/n2;
%% step list
fStep=[0.1, 0.125, 0.15, 0.2, 0.25, 0.4, 0.5, 0.75, 1.0, 1.2, 1.5, 1.6, 2.0]*pr;
 
% test whether ylimit/step are integers and step is favorite choice value?
if mod(yMin,step)+mod(yMax,step)+min(abs(step-fStep))<eps % y tick is ok
else % modify the y tick
    zoomfactor=1.1;
    if yTickMarginMode==0
        zoomfactor=1.05;
        if n == 3
            zoomfactor=1.1;
        elseif n == 5
            zoomfactor = 1.05;
        end
    elseif yTickMarginMode==1
        zoomfactor=1.1;
        if n == 3
            zoomfactor=1.3;
        elseif n == 5
            zoomfactor = 1.1;
        end
    elseif yTickMarginMode==2
        zoomfactor=1.2;
        if n == 3
            zoomfactor=1.4;
        elseif n == 5
            zoomfactor = 1.2;
        end
    end
    
    step = zoomfactor * dY / n2;
    Index=1;
    while (fStep(Index) <= step) && Index<length(fStep)
        Index = Index+1;
    end
    
    step = fStep(Index);
    
    %% grid on zero
    %% tick is two times of step
    
    adjustfactor=0.01;
    if abs(yMax)>=abs(yMin)
        iNumber=floor(yMin/step-adjustfactor);
        if mod(iNumber,2)==0  % odd times
            yMin=floor(yMin/step-adjustfactor)*step-step;
            yMax=yMin+n2*step;
        else
            yMin=floor(yMin/step-adjustfactor)*step;
            yMax=yMin+n2*step;
        end
    elseif abs(yMax)<abs(yMin)
        iNumber=floor(yMax/step-adjustfactor);
        if mod(iNumber,2)==0  % odd times
            yMax=ceil(yMax/step+adjustfactor)*step+step;
            yMin=yMax-n2*step;
        else
            yMax=ceil(yMax/step+adjustfactor)*step;
            yMin=yMax-n2*step;
        end
    end

end


%% set Y from yMin and yMax

Y=zeros(1,n);
if GapMode~=1  %control the YTick mode song mode or conventional mode
    
    for i=1:n
        Y(i)=yMin+(2*i-1)*step;  %first half, last half, middle one mode
    end
    
elseif GapMode==1 % general grid
    for i=1:n+1
        Y(i)=yMin+2*(i-1)*step;
    end
end




set(ha,'YLim',[yMin, yMax]);
set(ha,'YTick',[Y(:)],'TickDir', 'in');


if rn<-2
    r=2;
    format=strcat('%','.',num2str(r),'g');
    sYLabel=cell(1,n);
    for i=1:length(Y)
        [sYL,errs]=sprintf(format,Y(i));
        sYL=[sYL,'       '];
        sYLabel{i}=sYL(1:7);
    end
elseif rn>3
    r=2;
    format=strcat('%','.',num2str(r),'g');
    sYLabel=cell(1,n);
    for i=1:length(Y)
        [sYL,errs]=sprintf(format,Y(i));
        sYL=[sYL,'        '];
        sYLabel{i}=sYL(1:7);
    end
elseif rn==3 || rn==2
    format=strcat('%','d');
    sYLabel=cell(1,n);
    for i=1:length(Y)
        [sYLabel{i},errs]=sprintf(format,Y(i));
    end
elseif rn==0 || rn==1
    r=2-rn;
    format=strcat('%','.',num2str(r),'f');
    sYLabel=cell(1,n);
    for i=1:length(Y)
        [sYL,errs]=sprintf(format,Y(i));
        sYLabel{i}=sYL;
    end
elseif rn==-1
    r=defRightDigit;
    format=strcat('%','.',num2str(r),'f');
    sYLabel=cell(1,n);
    for i=1:length(Y)
        [sYL,errs]=sprintf(format,Y(i));
        sYLabel{i}=sYL;
    end
elseif rn==-2
    r=defRightDigit+1;
    format=strcat('%','.',num2str(r),'f');
    sYLabel=cell(1,n);
    for i=1:length(Y)
        [sYL,errs]=sprintf(format,Y(i));
        sYLabel{i}=sYL;
    end
end

set(ha,'YTickLabel',sYLabel)
Yy=1;
return


