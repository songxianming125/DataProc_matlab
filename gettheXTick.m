function [L,S,R]=gettheXTick(xLeft,xRight); 
%songxm

delX=xRight-xLeft;
orderOfMagnitude = floor(log10(delX));
if orderOfMagnitude<0
    rate = 10^(-orderOfMagnitude+1);
else
    rate=1;
end

xLeft=xLeft*rate;
xRight=xRight*rate;


delX=xRight-xLeft;
orderOfMagnitude = ceil(log10(delX));
baseStep = 10^(orderOfMagnitude-1);
%    if baseStep>1
%     R=ceil(ceil(xRight)*baseStep)/baseStep;
%     L=floor(floor(xLeft)*baseStep)/baseStep;
%    else
%     R=ceil(xRight/baseStep)*baseStep;
%     L=floor(xLeft/baseStep)*baseStep;
%    end
   if baseStep>1
    R=round(round(xRight)*baseStep)/baseStep;
    L=round(round(xLeft)*baseStep)/baseStep;
   else
    R=round(xRight/baseStep)*baseStep;
    L=round(xLeft/baseStep)*baseStep;
   end
   
   
   delX=R-L;
   if baseStep>=1
       if (delX/baseStep)<=0.01
           S = baseStep/100;
       elseif (delX/baseStep)<=0.1
           S = baseStep/10;
       elseif (delX/baseStep)<=1
           S = baseStep/10;
       elseif (delX/baseStep)<=2
           S = baseStep/5;
       elseif (delX/baseStep)<=5
           S = baseStep/2;
       elseif (delX/baseStep)<=10
           S = baseStep;
       elseif (delX/baseStep)>=20
           S = baseStep*2;
       else
           S = baseStep;
       end
   elseif baseStep<1 && baseStep>0.01
       if (delX/baseStep)<0.01
           S = baseStep/200;
       elseif (delX/baseStep)<0.1
           S = baseStep/20;
       elseif (delX/baseStep)<1
           S = baseStep/10;
       elseif (delX/baseStep)<2
           S = baseStep/5;
       elseif (delX/baseStep)<5
           S = baseStep/2;
       elseif (delX/baseStep)>50
           S = baseStep*2;
       else
           S = baseStep;
       end
   elseif baseStep<=0.01
       if (delX/baseStep)<0.01
           S = baseStep/200;
       elseif (delX/baseStep)<0.1
           S = baseStep/20;
       elseif (delX/baseStep)<1
           S = baseStep/10;
       elseif (delX/baseStep)<2
           S = baseStep/5;
       elseif (delX/baseStep)<5
           S = baseStep/2;
       elseif (delX/baseStep)>50
           S = baseStep*2;
       else
           S = baseStep;
       end
   else
       if (delX/baseStep)<0.01
           S = baseStep/200;
       elseif (delX/baseStep)<0.1
           S = baseStep/20;
       elseif (delX/baseStep)<1
           S = baseStep/10;
       elseif (delX/baseStep)<2
           S = baseStep/5;
       elseif (delX/baseStep)<5
           S = baseStep/2;
       elseif (delX/baseStep)>50
           S = baseStep*2;
       else
           S = baseStep;
       end
   end
   
   
   if round(S)~=0
       S=round(S);
   end
   R=L+ceil((R-L)/S)*S;
   L=L/rate;
   S=S/rate;
   R=R/rate;
