function [jPlasma,betap,varargout]=jEFIT(j,gFit,Fit)
%%
%       This program is to solve the Grad-Shafranov equation in Green Function way  (integration way)                  
%       Developed by Song xianming 2013.8.30           
%%
Iex=Fit.Iex;
fluxMeasured=reshape(Fit.fluxMeasured,numel(Fit.fluxMeasured),1);
BnMeasured=reshape(Fit.BnMeasured,numel(Fit.BnMeasured),1);
BtMeasured=reshape(Fit.BtMeasured,numel(Fit.BtMeasured),1);

% get the PF contribution
% get the plasma contribution by cancelling the PF contribution

fluxMeasuredPlasma=fluxMeasured-gFit.greenPF*reshape(Iex,length(Iex),1); % get the plasma contribution by cancelling the PF contribution
BnMeasuredPlasma=BnMeasured-gFit.Bn*reshape(Iex,numel(Iex),1);
BtMeasuredPlasma=BtMeasured-gFit.Bt*reshape(Iex,numel(Iex),1);

X1=gFit.X1;  % Matrix, X1 in grid
Y1=gFit.Y1;  % Matrix, Y1 in grid

Flux=gFit.fluxPF*reshape(Iex,length(Iex),1); % PF contribution
jPlasma=j*Fit.Ip;

%% flux in grid
%  up down symmetry is mandatory for DN
if strcmpi(gFit.shapeType,'DN')
    jPlasma1=reshape(jPlasma,size(X1));
    jPlasma1=(jPlasma1+flipud(jPlasma1))/2;
    jPlasma=jPlasma1;  %grid
end
jPlasma=reshape(jPlasma,[numel(X1) 1]);  %grid

Flux=Flux+gFit.fluxPlasma*jPlasma;  % PF+plasma contribution  // flux at grid
M=reshape(Flux,size(X1));%

%% 
% calculate the flux of limiter need Iex and jPlasma, limiter position
% Point=getLimiter(limiterRadius);
% pointType=1;
% [fluxPlasmaLimiter,fluxPFLimiter]=getBoundaryGreenFn(Point,pointType); % smart enough to know whether it is needed to update.
% MLimiter=fluxPFLimiter*Iex'+fluxPlasmaLimiter*jPlasma;

fluxPlasmaLimiter=gFit.fluxPlasmaLimiter; % green function for flux in limiter contributed by plasma
fluxPFLimiter=gFit.fluxPFLimiter; % green function for flux in limiter contributed by PF

MLimiter=fluxPFLimiter*Iex'+fluxPlasmaLimiter*jPlasma;

if nargout>=3
    [M,index,C,C1,v,phiCenter]=IdentifyPlasma(gFit,M,MLimiter);
else
    [M,index,C]=IdentifyPlasma(gFit,M,MLimiter);
end%% draw contour for flux

Xp=(min(C(1,2:end))+max(C(1,2:end)))/2;  % geometric center


PhiN=M(index);
R=X1(index);
xN=1-PhiN;
xN2=xN.^2;
xN3=xN.*xN2; % power is 3
% u0/4*pi^2 is absorbed into coefficient
% j=R.*(a0+a1*xN+a2*xN2-(a0+a1+a2)*xN3)+(c0+c1*xN+c2*xN2-(c0+c1+c2)*xN3)./R
% A1=[R.*(1-xN3) R.*(xN-xN3) R.*(xN2-xN3) (1-xN3)./R (xN-xN3)./R (xN2-xN3)./R];

% less term
A1=[R.*PhiN PhiN./R]; % only one term for P and FF


% dJ/dZ*delZ for vertical movement



% dMpv=diff(Mpv,1,1);
% dMpv(end+1,:,:)=0; % half step down
% dMpv=(dMpv+circshift(dMpv,[1 0 0]))/2; % average





%% flux contribution
bf=reshape(fluxMeasuredPlasma,numel(fluxMeasuredPlasma),1);
Af=gFit.greenPlasma(:,index)*A1;


%% find the Bn and Bt Green function


% array times --> diag matrix times
bn=reshape(BnMeasuredPlasma,numel(BnMeasuredPlasma),1);
An=gFit.Bnp(:,index)*A1;
% weighted to cancel the wrong signal

myWeightVector=ones(18,1);
cancelIndex=[3 4 5 11 12 13];
myWeightVector(cancelIndex)=0;
weightedMatrix=diag(myWeightVector);

% adjust the v and A
bn=bn.*myWeightVector;
An=weightedMatrix*An;






% array times --> diag matrix times
bt=reshape(BtMeasuredPlasma,numel(BtMeasuredPlasma),1);
At=gFit.Btp(:,index)*A1;


%% more situation
% flux
% b=bf;
% A=Af;
% 
% ac=A\b;
% y=norm(A*ac-b);
% 
% jP=A1*ac;
% totalJ=sum(jP);
% yf=totalJ-Ip;
% 
% 
% 
% 
% b=bn;
% A=An;
% 
% ac=A\b;
% y=norm(A*ac-b);
% 
% jP=A1*ac;
% totalJ=sum(jP);
% yn=totalJ-Ip;
% 
% 
% b=bt;
% A=At;
% 
% ac=A\b;
% y=norm(A*ac-b);
% 
% jP=A1*ac;
% totalJ=sum(jP);
% yt=totalJ-Ip;
% 
% 
% b=[bn;bt];
% A=[An;At];
% 
% ac=A\b;
% y=norm(A*ac-b);
% 
% jP=A1*ac;
% totalJ=sum(jP);
% yB=totalJ-Ip;
% 

b=[bf;bn;bt];
A=[Af;An;At];
% b=[bf;bn];
% A=[Af;An];


ac=A\b;

% betap=(ac(1)*Xp)/(ac(1)*Xp+ac(2)/Xp);
% 
% if betap>0.3
%     betap=0.1;
% elseif betap<0
%     betap=0.1;
% end
betap=0.2;


y=norm(A*ac-b);

jP=A1*ac;
totalJ=sum(jP);
yTotal=totalJ-Fit.Ip;

%% over



jPlasma=zeros(size(M));
jPlasma(index)=jP/totalJ;
jPlasma=reshape(jPlasma,numel(jPlasma),1);



% Fit
if nargout>=3
    varargout{1}=M;
end
if nargout>=4
    varargout{2}=C;
end

if nargout>=5
    varargout{3}=C1;
end
if nargout>=6
    varargout{4}=v;
end
if nargout>=7
    varargout{5}=index;
end
if nargout>=8
    varargout{6}=phiCenter;
end
if nargout>=9
    varargout{7}=totalJ;
end
return

%% draw jPlasma

sourceLen=numel(index);
X2=reshape(X1(index),1,sourceLen);%
Y2=reshape(Y1(index),1,sourceLen);%
jPlasma4Draw=reshape(jPlasma(index),sourceLen,1);%

factor=jPlasma4Draw/max(jPlasma4Draw(:));
factorthree=[factor factor/2 1-factor];
mycolor=mat2cell(factorthree,[linspace(1,1,sourceLen)],[3]);

% draw the same number vertical line
XX=[X2;X2];
YY=[Y2;Y2+0.0001];


h=plot(XX,YY,'.','LineWidth',1); %plasma
set(h,{'Color'},mycolor)
%% j distribution
 
jj=reshape(j,size(X1));
[C,h] = contour(X1,Y1,jj,300);
colorbar;

%% j curve
jj=reshape(j,size(X1));
iindex=65:129:65+129*64;
figure
plot(X1(iindex),jj(iindex))
%% j curve
jj=reshape(j,size(X1));
figure
plot(X1(64,:),jj(64,:))

%% update picture
figure
clf
p=DrawBackground(0.4);
[M,C,index,C1]=IdentifyPlasma(X1,Y1,M,MLimiter,Point,isDraw);
%%test
BB=Bnp-Btp;
tB=sum(BB(:));
t=tB
ii=BB==0

%% the effect of probe size


[Bn,Bt,Bnp,Btp]=getBoundaryGreenFnBfield([],3); % 2=normal and tangential

BnPlasma=Bnp*jPlasma;
BtPlasma=Btp*jPlasma;

BnPlasma=reshape(BnPlasma,[18 25]);
BtPlasma=reshape(BtPlasma,[18 25]);

oldBn=BnPlasma(:,13);
oldBt=BtPlasma(:,13);


BnPlasma=mean(BnPlasma,2);
BtPlasma=mean(BtPlasma,2);


errN=abs(BnPlasma-oldBn)./BnPlasma
errT=abs(BtPlasma-oldBt)./BtPlasma




