function [y,iPF]=getFieldNullConfC(C,varargin)
%%
%       This program get the PF configuration for field Null                  
%       Developed by Song xianming 2013.11.22 
%
% input description
% C contour data

%%  at accurate boundary 
Numcoils=18;

% pointNum=100;
% % [Ip,ap1,Xp1,Yp1,elong1,tri,betap,li,alphaIndex]=getPlasma0D;
% [Xb,Yb]=getClosedBoundary(Xp,Yp,ap,elong,pointNum);
% 
% fieldNullXY=[];
% fieldNullXY(1,:)=Xb;
% fieldNullXY(2,:)=Yb;

[~,fieldNullXY]=getBoundaryByC(C);
fluxPF2=getappdata(0,'fluxPF2');

if isempty(fluxPF2)
    fluxPF2=getPFfluxAtBoundary(fieldNullXY);
    setappdata(0,'fluxPF2',fluxPF2)
    save('fluxNullPF','fluxPF2')
end
pointNum=length(fieldNullXY);
% calculate the flux consumption needed
delPhi=1;  % inductance and resistance consumption
delPhi=ones(pointNum,1)*delPhi;  % constraint condition =b

if nargin>1 % without constraint
    iCS=varargin{1};
    iPF=varargin{2};

    fluxInBoundaryByCS=fluxPF2(:,1:2)*[iCS;iCS]; %1A flux
    fluxInBoundaryByPF=fluxPF2(:,9:10)*[iPF;iPF]; %1A flux
    
    
    b=delPhi-fluxInBoundaryByCS-fluxInBoundaryByPF; % constraint condition =b
%     index=[3:14 17 18];
    index=[3:8 11:18];
    A=fluxPF2(:,index); % find the PF current without CS
else
    bConstraint=zeros(Numcoils,1);
    constraintVector=zeros(Numcoils,1);
    constraintIndex=3:10;  % the coils to be constrained
    constraintVector(constraintIndex)=1;
    constraintMatrix=diag(constraintVector);
    constraintMatrix=setConstraintMatrix(constraintMatrix);
    
    b=[delPhi;bConstraint];  % constraint condition =b
    A=[fluxPF2;constraintMatrix];
end



iPF=A\b;
y=norm(A*iPF-b);

return

