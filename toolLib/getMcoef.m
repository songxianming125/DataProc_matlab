function M = getMcoef(X1,Y1,X2,Y2,varargin)
%% get the mutual inductance
% % X1, Y1 are array,X2,Y2 are also array   X1>0 x2>0
% 1 indicates field, 2 indicates source 
%
% field and source can exchange!
% 2 is plasma as source, 1 is field
% source


if nargin<5
    gapX=[];
elseif nargin==5
    gapX=varargin{1};
end
sourceLen=numel(X2);
X2=reshape(X2,1,sourceLen);
Y2=reshape(Y2,1,sourceLen);
% field
fieldLen=numel(X1);
X1=reshape(X1,1,fieldLen);%
Y1=reshape(Y1,1,fieldLen);%
M=zeros(fieldLen,sourceLen);

Cmu=2.0e-7;
Cmu=Cmu*pi;  % Flux  C=mu/2, flux is pi times large than Bfield


parfor i=1:sourceLen  % X2 is scalar
    %     for i=1:sourceLen  % X2 is scalar
    R1=sqrt((X1+X2(i)).^2+(Y1-Y2(i)).^2);
    m=4.*X2(i).*X1./R1.^2;
    index=find(abs(m-1)<1.0e-10); % for X1
    %avoiding the overlay of source and field
    
    XX1=X1; % may modify, not exist outside [if ~isempty(index)]
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
    
    [myK,myE]=ellipke(m);
    M(:,i)=Cmu.*R1.*(2.*(myK-myE)-m.*myK);
end

