function fluxPF=getPFfluxAtBoundary(XY,varargin)
%%********************************************************
%       This program is to calculate                    
%    the Magnetic flux of PF coils at plasma boundary
%      Developed by Song xianming 2013/11/22            
%********************************************************
%% PF coef

if nargin==1 % in two row array
    Xg=XY(1,:);
    Yg=XY(2,:);
elseif nargin==2 % in two variable
    Xg=XY;
    Yg=varargin{1};
end


Numcoils=18;
m=numel(Xg);
fluxPF=zeros(m,Numcoils);

for i=1:Numcoils
    index=i;
    [X2,Y2,ATurnCoil]=getLocation(index);
    fluxPF(:,i)=MMutInductance(Xg,Yg,X2,Y2,ATurnCoil);
end
