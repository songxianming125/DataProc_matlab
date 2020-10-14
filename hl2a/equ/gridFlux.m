function Flux=gridFlux(Xg,Yg,Iex)
%%********************************************************
%       This program is to calculate                    
%       the Magnetic flux of PF coils and Plasma
%      Developed by Song xianming 2014/2/15/            
%********************************************************
%********************************************************
%*******************************************************
%%*******************************************************
% Numcoils=18; % 2M
Numcoils=11; % 2A


[m,n]=size(Xg);
Flux=zeros(m,n,Numcoils);

for i=1:Numcoils
    index=i;
    [X2,Y2,ATurnCoil,gapX]=getLocation(index);
    Flux(:,:,i)=Iex(index).*MMutInductance(Xg,Yg,X2,Y2,ATurnCoil,gapX);
end





%%
