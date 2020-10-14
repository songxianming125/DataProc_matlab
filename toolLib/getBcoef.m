function [BX,BY] = getBcoef(X1,Y1,X2,Y2,varargin)
%% 
% % X1, Y1 are array,X2,Y2 are also array   X1>0 x2>0
% 1 indicates field, 2 indicates source 
%
% field and source can not exchange!
% 2 is plasma as source, 1 is field
% source


if nargin==0
    gapX=[];
elseif nargin==1
    gapX=varargin{1};
end
sourceLen=numel(X2);
X2=reshape(X2,1,sourceLen);
Y2=reshape(Y2,1,sourceLen);
% field
fieldLen=numel(X1);
X1=reshape(X1,1,fieldLen);%
Y1=reshape(Y1,1,fieldLen);%

BX=zeros(fieldLen,sourceLen);
BY=zeros(fieldLen,sourceLen);
ATurnCoil=ones(1,sourceLen); % field for unit source

% for magnetic coefficient

Cmu=2.0e-7; % For B field  C=uo/(2*pi)
parfor i=1:fieldLen % for field point
    %    for i=1:fieldLen % for field point
    R1=sqrt((X1(i)+X2).^2+(Y1(i)-Y2).^2);
    m=4.*X1(i).*X2./R1.^2;
    
    index=find(abs(m-1)<1.0e-10);
    %avoiding the overlay of source and field
    XX2=X2;  % may modify
    if ~isempty(index)
        if isempty(gapX)
            XX2(index)=X2(index)+0.0001;% move 1 mm outside
        elseif numel(gapX)==1
            XX2(index)=X2(index)+gapX;% move quarterWidth outside
        elseif numel(gapX)==numel(X2)
              XX2(index)=X2(index)+gapX(i);% move quarterWidth outside
        end
        
        R1=sqrt((X1(i)+XX2).^2+(Y1(i)-Y2).^2);
        m=4.*X1(i).*XX2./R1.^2;
    end
    
    % ellipke(m) convergence is ok, do not need to modify X1 in expression
    
    R2=sqrt((X1(i)-XX2).^2+(Y1(i)-Y2).^2);
    %     k=sqrt(m);
    [myK,myE]=ellipke(m);
    BX(i,:)=-ATurnCoil.*Cmu.*(Y1(i)-Y2).*(myK-myE-2.*XX2.*X1(i).*myE./R2.^2)./R1./X1(i);
    BY(i,:)=ATurnCoil.*Cmu.*(myK-myE+2.*XX2.*(XX2-X1(i)).*myE./R2.^2)./R1;
end
