% function [y,t,varargout]=getELMProperty(CurrentShot,varargin);
function [type,frequency]=getELMProperty(CurrentShot,varargin)
if nargin>=3
    Tstart1=varargin{1};
    Tend1=varargin{2};
    if  ~isempty(Tstart1) && ~isempty(Tend1)
        if Tstart1<=Tend1
            Tstart=Tstart1;
            Tend=Tend1;
        elseif Tstart1>Tend1
            Tstart=Tend1;
            Tend=Tstart1;
        end
    end
else
    Tstart=500;
    Tend=1100;
    
end

% initilization


tTop=[];
yTop=[];
tMiddleRise=[];
tMiddleDown=[];


tBottom=[];
yBottom=[];
iELMWidth=ceil(100);
iELMInterval=ceil(200);
fMiddle=1.15; % factor of Middle


[y,t]=hl2adb(CurrentShot,'ha',Tstart,Tend);


figure
hold on
plot(t,y)

yAverage=sum(y)/length(y);
yMiddle=fMiddle*yAverage;


indexMiddleRise=find(y>yMiddle,1,'first');


tMiddleRise=[tMiddleRise t(indexMiddleRise)];

yTemp=y(indexMiddleRise+iELMWidth:end);
tTemp=t(indexMiddleRise+iELMWidth:end);


indexMiddleDown=find(yTemp<yMiddle,1,'first');

% Middle
while ~isempty(indexMiddleDown)
    
    tMiddleDown=[tMiddleDown tTemp(indexMiddleDown)];
    yTemp=yTemp(indexMiddleDown+iELMInterval:end);
    tTemp=tTemp(indexMiddleDown+iELMInterval:end);
    
    indexMiddleRise=find(yTemp>yMiddle,1,'first');
    
    if ~isempty(indexMiddleRise)
        tMiddleRise=[tMiddleRise tTemp(indexMiddleRise)];
        yTemp=yTemp(indexMiddleRise+iELMWidth:end);
        tTemp=tTemp(indexMiddleRise+iELMWidth:end);
        indexMiddleDown=find(yTemp<yMiddle,1,'first');
    else
        indexMiddleDown=[];
    end
    
    
end



for i=1:length(tMiddleRise)-1
    % top
    tRise=tMiddleRise(i);
    tDwon=tMiddleDown(i);
    

    
    indexMiddleRise=find(t>tRise,1,'first');
    indexMiddleDown=find(t<tDwon,1,'last');
    
    yTemp=y(indexMiddleRise:indexMiddleDown);
    tTemp=t(indexMiddleRise:indexMiddleDown);
    
    [yMax,indexMax]=max(yTemp);
    
    tTop=[tTop tTemp(indexMax)];
    yTop=[yTop yMax];
    
    % bottom
    
    tRise=tMiddleRise(i+1);

    
    indexMiddleRise=find(t>tRise,1,'first');
    indexMiddleDown=find(t<tDwon,1,'last');
    
    yTemp=y(indexMiddleDown:indexMiddleRise);
    tTemp=t(indexMiddleDown:indexMiddleRise);
    
    [yMin,indexMin]=min(yTemp);
    
    tBottom=[tBottom tTemp(indexMin)];
    yBottom=[yBottom yMin];
end


    numELM=min(length(tMiddleRise),length(tMiddleDown));
    tMiddleRise=tMiddleRise(1:numELM);
    tMiddleDown=tMiddleDown(1:numELM);
    
    widthELM=tMiddleDown-tMiddleRise;
    intervalELM=tMiddleRise(2:end)-tMiddleDown(1:end-1);
    
    ratioInterval2Width = mean(intervalELM)/mean(widthELM);
    
    

    plot([t(1) t(end)],[yMiddle yMiddle],'-oc')
    
    plot(tTop,yTop,'or')
    plot(tBottom,yBottom,'*m')
    
    if ratioInterval2Width>3
        type='isELM';
    elseif ratioInterval2Width<2
        type='isIPhase';
    else
        type='unknown';
    end
    
    frequency=1/(mean(widthELM)+mean(intervalELM))*1000;  %HZ
    
    
    
    
    


