function Flux4PF=spmdSetCoef(coreNum)

%%
%       labindex =8  
%       Green Fucntion for unit current in PF and Plasma
%       current in Ampere
%%


% Numcoils=18; % 2M
Numcoils=11; % 2A


Iex=ones(Numcoils,1);
[xNum,yNum,XStart,XStep,XEnd,YStart,YStep,YEnd]=getGridPara(2); % 1=32*64;8= 256*512
% labindex=1;
elementNum=yNum/coreNum;


if labindex<coreNum
    [Xg,Yg] = meshgrid(XStart:XStep:XEnd,YStart+YStep*(labindex-1)*elementNum:YStep:YStart+YStep*labindex*elementNum-YStep);  %field point
else
     [Xg,Yg] = meshgrid(XStart:XStep:XEnd,YStart+YStep*(labindex-1)*elementNum:YStep:YStart+YStep*labindex*elementNum);  %field point, one more element
end
Flux4PF=gridFlux(Xg,Yg,Iex);



