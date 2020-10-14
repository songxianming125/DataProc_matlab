function [varargout]=getFluxCoefAtBoundary(XY)
%%********************************************************
%       This program is to calculate                    
%    the Magnetic flux of PF coils and Plasma in specific position
%      Developed by Song xianming 2008/08/15/            
%      modified by Song xianming 2014/05/15/            
%********************************************************
%********************************************************
%*******************************************************
%% PF coef
Xg=XY(1,:);
Yg=XY(2,:);

if strcmp(getappdata(0,'MachineCode'),'2A')
    Numcoils=11;  % 2A
elseif strcmp(getappdata(0,'MachineCode'),'2M')
    Numcoils=18;  % 2M
end




m=length(Xg);
fluxPF=zeros(m,Numcoils);

parfor i=1:Numcoils
    index=i;
    [X2,Y2,ATurnCoil,gapX]=getLocation(index);
    fluxPF(:,i)=MMutInductance(Xg,Yg,X2,Y2,ATurnCoil,gapX);
end


if nargout>1
    %% plasma coef
    %exchange the source and field to accelerate the calculation
    
    % source
    sourceLen=numel(Xg);
    X2=reshape(Xg,1,sourceLen);%
    Y2=reshape(Yg,1,sourceLen);%
    % field for flux
    [X1,Y1]=getGrid;
    % prepare the gap
    factor=0.23; %optimized coef for statistic results
    gapX=(X1(1,2)-X1(1,1))*factor;  %grid gap

    % reshape X1 and Y1
    fieldLen=numel(X1);
    X1=reshape(X1,1,fieldLen);%
    Y1=reshape(Y1,1,fieldLen);%
    fluxPlasma=zeros(sourceLen,fieldLen);
    
    Cmu=2.0e-7;  
    Cmu=Cmu*pi;  % =mu/2, flux is pi times large than Bfield
    

    parfor i=1:sourceLen  % X2 is scalar
%     for i=1:sourceLen  % X2 is scalar
        R1=sqrt((X1+X2(i)).^2+(Y1-Y2(i)).^2);
        m=4.*X2(i).*X1./R1.^2;
        index=find(abs(m-1)<1.0e-10); % for X1
        %avoiding the overlay of source and field
        
        XX1=X1; % may modify, not exist outside [if ~isempty(index)]
        if ~isempty(index)
            XX1(index)=X1(index)+gapX;% move 1 mm outside
            R1=sqrt((XX1+X2(i)).^2+(Y1-Y2(i)).^2);
            m=4.*X2(i).*XX1./R1.^2;
        end
        
        [myK,myE]=ellipke(m);
        fluxPlasma(i,:)=Cmu.*R1.*(2.*(myK-myE)-m.*myK);
    end
    
%     fluxPlasma=reshape(fluxPlasma,[numel(X1) sourceLen]);%
%     fluxPlasma=fluxPlasma';%
end

% OUTPUT PARAMETERS
if nargout==1
    varargout{1}=fluxPF;
elseif nargout==2
    varargout{1}=fluxPF;
    varargout{2}=fluxPlasma;
elseif nargout>2
    disp('too many output parameter for function getFluxComp')
end%












