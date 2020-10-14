function [BX,BY,varargout]=getFieldAtBoundary(XY,varargin)
%%********************************************************
%       This program is to calculate
%       the Magnetic field of PF current and plasma current at plasma boundary
%       Developed by Song xianming 2013/11/22
%********************************************************
%% PF coef

if nargin==1 % in two row array
    Xg=XY(1,:);
    Yg=XY(2,:);
elseif nargin==2 % in two variable
    Xg=XY;
    Yg=varargin{1};
end

if strcmp(getappdata(0,'MachineCode'),'2A')
    Numcoils=11;  % 2A
elseif strcmp(getappdata(0,'MachineCode'),'2M')
    Numcoils=18;  % 2M
end
% Numcoils=20;

m=numel(Xg);
BX=zeros(m,Numcoils);
BY=zeros(m,Numcoils);

parfor i=1:Numcoils  % for source
% for i=1:Numcoils
    index=i;
    [X2,Y2,ATurnCoil,gapX]=getLocation(index);
    [BX(:,i),BY(:,i)]=MMagneticField(Xg,Yg,X2,Y2,ATurnCoil,gapX);% g mean field, 2 mean source
end

if nargout>3
    
    %% plasma coef
    
    % field and source can not exchange!
    % 1 indicate field point, 2 is plasma as source
    % source
    [X2,Y2]=getGrid;
    factor=0.23;
    gapX=abs((X2(1,2)-X2(1,1))*factor); %if overlay of source and field, move quarterWidth of source.
    
    X2=reshape(X2,1,numel(X2));
    Y2=reshape(Y2,1,numel(Y2));
    % field for flux
    fieldLen=numel(Xg);
    X1=reshape(Xg,1,fieldLen);%
    Y1=reshape(Yg,1,fieldLen);%
    sourceLen=numel(X2);
    DX=zeros(fieldLen,sourceLen);
    DY=zeros(fieldLen,sourceLen);
    ATurnCoil=ones(1,sourceLen); % field for unit source 
    
    
    
    Cmu=2.0e-7; % uo/(2*pi)
    parfor i=1:fieldLen % for field point
%    for i=1:fieldLen % for field point
        R1=sqrt((X1(i)+X2).^2+(Y1(i)-Y2).^2);
        m=4.*X1(i).*X2./R1.^2;
        
        index=find(abs(m-1)<1.0e-10);
        %avoiding the overlay of source and field
        XX2=X2;  % may modify
        if ~isempty(index)
            XX2(index)=X2(index)+gapX;% move quarterWidth outside
            R1=sqrt((X1(i)+XX2).^2+(Y1(i)-Y2).^2);
            m=4.*X1(i).*XX2./R1.^2;
        end
        
        % ellipke(m) convergence is ok, do not need to modify X1 in expression
        
        R2=sqrt((X1(i)-XX2).^2+(Y1(i)-Y2).^2);
        %     k=sqrt(m);
        [myK,myE]=ellipke(m);
        DX(i,:)=-ATurnCoil.*Cmu.*(Y1(i)-Y2).*(myK-myE-2.*XX2.*X1(i).*myE./R2.^2)./R1./X1(i); % 1 mean field, 2 mean source
        DY(i,:)=ATurnCoil.*Cmu.*(myK-myE+2.*XX2.*(XX2-X1(i)).*myE./R2.^2)./R1;
    end
 % no need to reshape   
    
    varargout{1}=DX; % plasma area
    varargout{2}=DY; % plasma area
end
