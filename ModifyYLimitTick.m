function [yMin,yMax]=ModifyYLimitTick(yMin,yMax,n)
%%%********************************************************%%%
%%%       This program is setting the favorite yTick       %%%
%%%      Developed by Dr SONG Xianming 2020/05/04/         %%%
%%%********************************************************%%%


global MyPicStruct  % can run for both w/o DP
if isempty(MyPicStruct)
    MyPicStruct.yTickMarginMode=0;
end


n2=2*n;  % n is the yTickNumber


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
fStep=[0.1, 0.125, 0.15, 0.2, 0.25, 0.4, 0.5, 0.75, 1.0, 1.2, 1.5, 1.6, 2.0]*pr;
 
% test whether ylimit/step are integers and step is favorite choice value?
if mod(yMin,step)+mod(yMax,step)+min(abs(step-fStep))<eps % y tick is ok
else % modify the y tick
    zoomfactor=1.1;
    if MyPicStruct.yTickMarginMode==0
        zoomfactor=1.05;
        
        if n == 3
            zoomfactor=1.1;
        elseif n == 5
            zoomfactor = 1.05;
        end
    elseif MyPicStruct.yTickMarginMode==1
        zoomfactor=1.1;
        if n == 3
            zoomfactor=1.3;
        elseif n == 5
            zoomfactor = 1.1;
        end
    elseif MyPicStruct.yTickMarginMode==2
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
return

