function M=MMutInductance(X1,Y1,X2,Y2,ATurnCoil,varargin) 
%% ********************************************************%%%
%  This program is to calculate the mutual inductance      %%%
% or flux in more field points 1 by more source points 2   %%%
% Developed by Song xianming in 2004 modified in 2008/08   %%%
%********************************************************%%%
%********************************************************%%%
%********************************************************%%%
%********************************************************%%%
%********************************************************%%%
%flux in weber
%size(X2,1)=1 
% X1, Y1 are array,X2,Y2 are also array   X1>0 x2>0
% 1 indicates field, 2 indicates source 
% X1 and X2 can have many dimensions (more than 2)
% size(X1)=size(Y1)
% ATurnCoil is ampere turn number
% size(ATurnCoil)=size(X2)=size(Y2)


% prepare the involved coefficient
%Song Xianming 2k4 April
%very important function for calculation the mutual inductance or flux
% 1 indicates field, 2 indicates source 
%upper case indicates vector, lower case indicates scalar, X1, Y1 are matrix,X2,Y2 are also matrix   X1>0 X2>0

if nargin>5
    gapX=varargin{1};
else
    gapX=[];
end


Cmu=2.0e-7*pi;% =mu/2
numSource=numel(X2);
M=zeros(size(X1));%≥ı ºªØ

for i=1:numSource  % X2 is scalar
    R1=sqrt((X1+X2(i)).^2+(Y1-Y2(i)).^2);
    m=4.*X2(i).*X1./R1.^2;
    index=find(abs(m-1)<1.0e-10); % for X1
    %avoiding the overlay of source and field
    if ~isempty(index)
        XX1=X1; % may modify, not exist outside [if ~isempty(index)]
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
    M=M+ATurnCoil(i).*Cmu.*R1.*(2.*(myK-myE)-m.*myK);
end
return







