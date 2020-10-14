function Flux4Plasma=spmdPlasmaCoef(coreNum)

%%
%       labindex =4 is best  
%       Flux Green Fucntion for unit current in PF and Plasma
%       current in Ampere
%%
[xNum,yNum,XStart,XStep,XEnd,YStart,YStep,YEnd]=getGridPara(2); % 1=32*64;8= 256*512
% %  labindex=1;
elementNum=yNum/coreNum;

if labindex<coreNum
    [X1,Y1] = meshgrid(XStart:XStep:XEnd,YStart+YStep*(labindex-1)*elementNum:YStep:YStart+YStep*labindex*elementNum-YStep);  %field point
else
     [X1,Y1] = meshgrid(XStart:XStep:XEnd,YStart+YStep*(labindex-1)*elementNum:YStep:YStart+YStep*labindex*elementNum);  %field point, one more element
end

[X2,Y2] = meshgrid(XStart:XStep:XEnd,YStart:YStep:YEnd);  %field point


sourceLen=numel(X2);

X2=reshape(X2,1,sourceLen);%
Y2=reshape(Y2,1,sourceLen);%

[m,n]=size(X1);
Flux4Plasma=zeros(m,n,sourceLen);




Cmu=2.0e-7*pi;% =mu/2

factor=0.23; %optimized coef for statistic results
gapX=(X1(1,2)-X1(1,1))*factor;  %grid gap

for i=1:sourceLen  % X2 is scalar
    R1=sqrt((X1+X2(i)).^2+(Y1-Y2(i)).^2);
    m=4.*X2(i).*X1./R1.^2;
    index=find(abs(m-1)<1.0e-10); % for X1
    %avoiding the overlay of source and field
    if ~isempty(index)
        XX1=X1; % may modify, not exist outside [if ~isempty(index)]
        XX1(index)=X1(index)+gapX;% move 1 mm outside
        R1=sqrt((XX1+X2(i)).^2+(Y1-Y2(i)).^2);
        m=4.*X2(i).*XX1./R1.^2;
    end

    [myK,myE]=ellipke(m);
    Flux4Plasma(:,:,i)=Cmu.*R1.*(2.*(myK-myE)-m.*myK);  % ATurnCoil=1
end







