function [DX,DY]=MMagneticField(X1,Y1,X2,Y2,ATurnCoil,varargin)  
%%%********************************************************%%%
%%%  This program is to calculate the magnetic field       %%%
%%%   in more field points 1 by more source points 2       %%%
%%%Developed by Song xianming in 2004 modified in2008/08   %%%
%%%********************************************************%%%
%%%********************************************************%%%
%%%********************************************************%%%
%%%********************************************************%%%
%%%********************************************************%%%
%current in ampere
%field in tesla
% X1, Y1 are array,X2,Y2 are also array   X1>0 x2>0
% 1 indicates field, 2 indicates source 
% X1 and X2 can have many dimensions (more than 2)
% size(X1)=size(Y1)
% ATurnCoil is ampere turn number
% size(ATurnCoil)=size(X2)=size(Y2)

%with for statement
% gapX should be used when the field and source is too close to each other. 
if nargin>5
    gapX=varargin{1};
else
    gapX=[];
end


% Cmu=2.0e-7;
% prepare the involved coefficient

% [m1,n1]=size(X2); %make sure m1=1
% DX=zeros(size(X1));%初始化
% DY=zeros(size(X1));%初始化
% quarterWidth=[];
% factor=0.23;
Cmu=2.0e-7; % uo/(2*pi)

numSource=numel(X2);
DX=zeros(size(X1));%初始化
DY=zeros(size(X1));%初始化



for i=1:numSource
    R1=sqrt((X1+X2(i)).^2+(Y1-Y2(i)).^2);
    m=4.*X2(i).*X1./R1.^2;
    
    index=find(abs(m-1)<1.0e-10);
    %avoiding the overlay of source and field
    XX1=X1;  % may modify //not inside the if end
    if ~isempty(index)
        if isempty(gapX)
            XX1(index)=X1(index)+0.0001;% move 1 mm outside
        elseif numel(gapX)==1
            XX1(index)=X1(index)+gapX;% move 1 mm outside
        elseif numel(gapX)==numel(X2)
              XX1(index)=X1(index)+gapX(i);% move quarterWidth outside
        end
        
        R1=sqrt((XX1+X2(i)).^2+(Y1-Y2(i)).^2);
        m=4.*X2(i).*XX1./R1.^2;
    end
    

%%
% ellipke(m) convergence is ok, do not need to modify X1 in expression
    R2=sqrt((XX1-X2(i)).^2+(Y1-Y2(i)).^2);
%   k=sqrt(m);
    [myK,myE]=ellipke(m);
    DX=DX-ATurnCoil(i).*Cmu.*(Y1-Y2(i)).*(myK-myE-2.*X2(i).*XX1.*myE./R2.^2)./R1./XX1;
    DY=DY+ATurnCoil(i).*Cmu.*(myK-myE+2.*X2(i).*(X2(i)-XX1).*myE./R2.^2)./R1;
end
