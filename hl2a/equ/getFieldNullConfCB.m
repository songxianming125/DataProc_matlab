function [y,iPF]=getFieldNullConfCB(C,varargin)
%%
%       This program get the PF configuration for field Null                  
%       Developed by Song xianming 2013.11.22 
%
% input description
% C contour data
% global Iex

%%  at accurate boundary 
Numcoils=18;

[~,fieldNullXY]=getBoundaryByC(C);

% fieldNullXY(1,:)=fieldNullXY(1,:)+0.3;
% fieldNullXY(1,:)=fieldNullXY(1,:)-0.05;

BX=getappdata(0,'BX');
BY=getappdata(0,'BY');

% if isempty(BX)
    [BX,BY]=getFieldAtBoundary(fieldNullXY);
    setappdata(0,'BX',BX)
    setappdata(0,'BY',BY)
% end
pointNum=length(fieldNullXY);
% calculate the flux consumption needed
% delPhi=1;  % inductance and resistance consumption
% delPhi=ones(pointNum,1)*delPhi;  % constraint condition =b

if nargin>5 % without constraint
    iCS=varargin{1};
%     iPF=varargin{2};

    BXByCS=BX(:,1:2)*[iCS;iCS]; %1A B
    BYByCS=BY(:,1:2)*[iCS;iCS]; %1A B
%     fluxInBoundaryByPF7=fluxPF2(:,9:10)*[iPF;iPF]; %1A flux
    
    
%     b=[-BXByCS;-BYByCS]; % constraint condition =b
% %     index=[3:14 17 18];
%     index=3:18;
%     A=[BX(:,index);BY(:,index)]; % find the PF current without CS
%     
    iPF1=12620;
    iPF4=14100; %A
    
    
    BXByPF1=BX(:,3:4)*[iPF1;iPF1]; %1A B
    BYByPF1=BY(:,3:4)*[iPF1;iPF1]; %1A B
    
    BXByPF4=BX(:,9:10)*[iPF4;iPF4]; %1A B
    BYByPF4=BY(:,9:10)*[iPF4;iPF4]; %1A B

  
  
    b=[-BXByCS-BXByPF1-BXByPF4;-BYByCS-BYByPF1-BYByPF4]; % constraint condition =b
%     index=[3:14 17 18];
%     index=3:18;
%     index=[3:8 11:18];
    index=[5:8 11:18];
    A=[BX(:,index);BY(:,index)]; % find the PF current without CS
    
    
    
  
    
    
    
    
    
else
   iCS=varargin{1};
%     iPF=varargin{2};

    BXByCS=BX(:,1:2)*[iCS;iCS]; %1A B
    BYByCS=BY(:,1:2)*[iCS;iCS]; %1A B
%     fluxInBoundaryByPF7=fluxPF2(:,9:10)*[iPF;iPF]; %1A flux
    
    
%     b=[-BXByCS;-BYByCS]; % constraint condition =b
% %     index=[3:14 17 18];
%     index=3:18;
%     A=[BX(:,index);BY(:,index)]; % find the PF current without CS
%     
%     iPF1=12620;
%     iPF4=14100; %A
%     
%     
%     BXByPF1=BX(:,3:4)*[iPF1;iPF1]; %1A B
%     BYByPF1=BY(:,3:4)*[iPF1;iPF1]; %1A B
%     
%     BXByPF4=BX(:,9:10)*[iPF4;iPF4]; %1A B
%     BYByPF4=BY(:,9:10)*[iPF4;iPF4]; %1A B

  
  
%     b=[-BXByCS-BXByPF1-BXByPF4;-BYByCS-BYByPF1-BYByPF4]; % constraint condition =b
    b=[-BXByCS;-BYByCS]; % constraint condition =b
%     index=[3:14 17 18];
%     index=3:18;
%     index=[3:8 11:18];
     index=3:18;
%     index=9:18; % PF1-3=0 constraint
    A=[BX(:,index);BY(:,index)]; % find the PF current without CS
    
    
end
iPF=A\b;
y=norm(A*iPF-b);
% iPF=[iCS;iCS;iPF1;iPF1;iPF(1:4);iPF4;iPF4;iPF(5:12)]; % add iCS again
 iPF=[iCS;iCS;iPF(1:16)]; % add iCS again
% iPF=[iCS;iCS;0;0;0;0;0;0;iPF]; % add iCS again
return

