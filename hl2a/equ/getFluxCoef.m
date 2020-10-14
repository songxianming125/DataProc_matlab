function [fluxPlasma,fluxPF]=getFluxCoef(Xg,Yg)
%%********************************************************
%       This program is to calculate                    
%    the Magnetic flux of PF coils and Plasma in specific position
%      Developed by Song xianming 2008/08/15/            
%********************************************************
%********************************************************
%*******************************************************
%% PF coef

Numcoils=18;
sourceLen=numel(Xg);
Xg=reshape(Xg,1,sourceLen);%
Yg=reshape(Yg,1,sourceLen);%

fluxPF=zeros(sourceLen,Numcoils);

for i=1:Numcoils
    index=i;
    [X2,Y2,ATurnCoil]=getLocation(index);
    fluxPF(:,i)=MMutInductance(Xg,Yg,X2,Y2,ATurnCoil);
end

%% plasma coef
[X1,Y1]=getGrid;
X2=reshape(Xg,1,sourceLen);%
Y2=reshape(Yg,1,sourceLen);%

[m,n]=size(X1);
fluxPlasma=zeros(m,n,sourceLen);

Cmu=2.0e-7*pi;% =mu/2
%点源坐标调整
% L=(mod(fix(1000.*X2),10)==0)&(mod(fix(1000.*Y2),10)==0);
% X2=X2+0.001.*L;
% M=zeros(size(X1));%初始化
quarterWidth=[];
factor=0.46;
%  factor=0.45;
for i=1:sourceLen  % X2 is scalar
    R1=sqrt((X1+X2(i)).^2+(Y1-Y2(i)).^2);
    m=4.*X2(i).*X1./R1.^2;
    index=find(abs(m-1)<1.0e-10); % for X1
    %avoiding the overlay of source and field
    if ~isempty(index)
        if isempty(quarterWidth)
            if length(X1)>1
                dX=diff(X1(:));
                index1=find(abs(dX)>1.0e-10);
                if ~isempty(index1)
                    quarterWidth=min(dX(index1))*factor;
                end
            end
        end
        if isempty(quarterWidth)
            if length(X2)>1
                dX=diff(X2);
                index1=find(abs(dX)>1.0e-10);
                if ~isempty(index1)
                    quarterWidth=min(dX(index1))*factor;
                end
            end
        end
        
        XX1=X1; % may modify, not exist outside [if ~isempty(index)]
        if isempty(quarterWidth) % % only X1(index) is modified
            XX1(index)=X1(index)+0.0001;% move 1 mm outside
        else
%               XX1(index)=X1(index)+0.000001;% move 1 mm outside
              XX1(index)=X1(index)+quarterWidth;% move quarterWidth outside
%                XX1(index)=X1(index)+0.01;% move quarterWidth outside
        end
        
        
        R1=sqrt((XX1+X2(i)).^2+(Y1-Y2(i)).^2);
        m=4.*X2(i).*XX1./R1.^2;
    end
    
    
%     R2=sqrt((X1-X2(i)).^2+(Y1-Y2(i)).^2);
%     k=sqrt(m);

    [myK,myE]=ellipke(m);
    fluxPlasma(:,:,i)=Cmu.*R1.*(2.*(myK-myE)-m.*myK);
%     M=M+ATurnCoil(i).*Cmu.*R1.*(2.*(myK-myE)-m.*myK);
end
fluxPlasma=reshape(fluxPlasma,[numel(X1) sourceLen]);%
fluxPlasma=fluxPlasma';%









