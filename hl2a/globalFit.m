
function gFit=globalFit(varargin)
if nargin==0
    gFit.limiterRadius=0.40;
end
if nargin==1
    gFit.limiterRadius=varargin{1};
end

% change to HL-2A machine
setappdata(0,'MachineCode','2A')
%% set parallel computing
% coreNum=12;
% y=startPara(coreNum);

% gFit.pathEF='C:\Users\songxm\data\hl2a';
% gFit.pathEF='C:\data\hl2a';
gFit.pathEF='d:\data\hl2a';

gFit.Ip=0.15e6;%A
gFit.ap=0.4;% max=0.5  minor radius a
gFit.chi=1;%elongation
gFit.tri=0;%triangularity
gFit.Xp=1.65;
gFit.Yp=0;
gFit.delta=0.02;%shafranov shift


gFit.Lsol=0.03;% SOL thickness for parabolic distribution
gFit.alpha=pi/4; % point angle
gFit.Rstep=0.1; % flux contour spacing

gFit.IpLimit=50; % Ip should greater than 50kA for efit



gFit.isMovie=0;
gFit.Numcoils=11; % PF coil Number
gFit.delay=1;  % delay for view in ms
gFit.isDraw=1;
gFit.shapeType='SN';

[X1,Y1]=getGrid;
gFit.X1=X1;  % Matrix, X1 in grid
gFit.Y1=Y1;  % Matrix, Y1 in grid
gFit.Point=getLimiter(gFit.limiterRadius);% Matrix, point in limiter
gFit.zdTstart=2900;  % Iv null drift
gFit.zdTend=2920;  % Iv null drift
gFit.zdTime=2500;  % Iv at the top


pointType=1;
[fluxPlasmaLimiter,fluxPFLimiter]=getBoundaryGreenFn(gFit.Point,pointType); % smart enough to know whether it is needed to update.
gFit.fluxPlasmaLimiter=fluxPlasmaLimiter; % green function for flux in limiter contributed by plasma
gFit.fluxPFLimiter=fluxPFLimiter; % green function for flux in limiter contributed by PF

fluxPlasma=getappdata(0,'fluxPlasma');
fluxPF=getappdata(0,'fluxPF');
if isempty(fluxPlasma)
    load([gFit.pathEF '\equ\Flux4Plasma8_2A'],'fluxPlasma')
    load([gFit.pathEF '\equ\Flux4PF8_2A'],'fluxPF')
    setappdata(0,'fluxPlasma',fluxPlasma)
    setappdata(0,'fluxPF',fluxPF)
end


gFit.fluxPlasma=fluxPlasma; % Green function for flux contributed by Plasma
gFit.fluxPF=fluxPF; % Green function for flux contributed by PF

load([gFit.pathEF '\GreenFluxBnBtDiag'],'greenPlasma','greenPF','Bn','Bt','Bnp','Btp')% diag position

gFit.greenPlasma=greenPlasma;  %
gFit.greenPF=greenPF;  %
gFit.Bn=Bn;  %
gFit.Bt=Bt;  %
gFit.Bnp=Bnp;  %
gFit.Btp=Btp;  %
gFit.vStep=0.00005; % initial flux step for geting plasma boundary in V.S
gFit.okStep=0.00001;  % minimum flux step for geting plasma boundary V.S



load([gFit.pathEF '\RatioFluxBnBtDiag'],'calibrationRatioFlux','calibrationRatioBn','calibrationRatioBt')

    
gFit.calibrationRatioFlux=calibrationRatioFlux;  % 4 element vector
gFit.calibrationRatioBn=calibrationRatioBn;  % 18 element vector 
gFit.calibrationRatioBt=calibrationRatioBt;% 18 element vector 

[~,~,Xp,~,~,~,~,~,alphaIndex]=getPlasma0D(gFit.shapeType);
gFit.alphaIndex=alphaIndex; % the index of equilibrium iteration for GAQ model


return



%% shot involved data



% dataFile=['d:\data\hl2a\exp\calibrationRatio' '20833' '.mat'];
% load(dataFile,'calibrationRatioBn','calibrationRatioBt')

%% preparing the Green function
%************************************************************************************************
if 1
    %diagnostic location
    [Point,theta]=getDiagnostic(1);
    % theta=reshape(theta,numel(theta),1);
    fluxPoint=Point(:,end-3:end);
    BPoint=Point(:,1:end-4);
    % green function preparation
    [greenPlasma,greenPF]=getBoundaryGreenFn(fluxPoint,2); % 2=flux diagnostic position
    % [Bn,Bt,Bnp,Btp]=getBoundaryGreenFnBfield(BPoint,2); % 2=normal and tangential
    [Bn,Bt,Bnp,Btp]=getBoundaryGreenFnBfield(BPoint,3); % 2=normal and tangential
    save([gFit.pathEF '\exp\GreenFluxBnBtDiag'],'greenPlasma','greenPF','Bn','Bt','Bnp','Btp')
else
        load([gFit.pathEF '\exp\GreenFluxBnBtDiag'],'greenPlasma','greenPF','Bn','Bt','Bnp','Btp')% diag position
end
%************************************************************************************************
 return      
dataFile=[gFit.pathEF '\exp\RatioFluxBnBtDiag' num2str(CurrentShot) '.mat'];
if  exist(dataFile,'file')==2   %0%
    load(dataFile,'calibrationRatioFlux','calibrationRatioBn','calibrationRatioBt')
else
    [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(CurrentShot,2500,2900,2920,'EX');
end



gFit.calibrationRatioFlux=calibrationRatioFlux;  % 4 element vector
gFit.calibrationRatioBn=calibrationRatioBn;  % 18 element vector 
gFit.calibrationRatioBt=calibrationRatioBt;% 18 element vector 




% htext=title('fit and iterative process','color','k','edge','b','BackgroundColor',[.7 .6 .9],'FontSize',16);
% if isempty(h0)
%     h0=line(1,1,'Color','b');
%     h1=line(1,1,'Color','m');
%     h2=line(1,1,'Color','r');
%     h3=line(1,1,'Color','r'); % second curve
% end








return

% change to HL-2A machine
setappdata(0,'MachineCode','2A')
% gFit.pathEF='C:\Users\songxm\data\hl2a';
gFit.pathEF='d:\data\hl2a';

if nargin<1
    gFit.limiterRadius=0.40;
end
if nargin==1
    gFit.limiterRadius=varargin{1};
end

gFit.isMovie=0;
gFit.Numcoils=11; % PF coil Number
gFit.delay=1;  % delay for view in ms
gFit.isDraw=1;
[X1,Y1]=getGrid;
gFit.X1=X1;  % Matrix, X1 in grid
gFit.Y1=Y1;  % Matrix, Y1 in grid
gFit.Point=getLimiter(gFit.limiterRadius);% Matrix, point in limiter

gFit.zdTstart=2900;  % Iv null drift
gFit.zdTend=2920;  % Iv null drift
gFit.zdTime=2500;  % Iv at the top
return

%         [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(CurrentShot,2500,2900,2920,'EX');











%% set parallel computing
coreNum=8;
y=startPara(coreNum);





%% all the same




gFit.Ip=0.15e6;%A
gFit.ap=0.4;% max=0.5  minor radius a
gFit.chi=1;%elongation
gFit.tri=0;%triangularity
gFit.Xp=1.65;
gFit.Yp=0;
gFit.delta=0.02;%shafranov shift


gFit.Lsol=0.03;% SOL thickness for parabolic distribution
gFit.alpha=pi/4; % point angle
gFit.Rstep=0.1; % flux contour spacing



gFit.shapeType='SN';



pointType=1;
[fluxPlasmaLimiter,fluxPFLimiter]=getBoundaryGreenFn(gFit.Point,pointType); % smart enough to know whether it is needed to update.
gFit.fluxPlasmaLimiter=fluxPlasmaLimiter; % green function for flux in limiter contributed by plasma
gFit.fluxPFLimiter=fluxPFLimiter; % green function for flux in limiter contributed by PF

fluxPlasma=getappdata(0,'fluxPlasma');
fluxPF=getappdata(0,'fluxPF');
if isempty(fluxPlasma)
    load([gFit.pathEF '\equ\Flux4Plasma8_2A'],'fluxPlasma')
    load([gFit.pathEF '\equ\Flux4PF8_2A'],'fluxPF')
    setappdata(0,'fluxPlasma',fluxPlasma)
    setappdata(0,'fluxPF',fluxPF)
end


gFit.fluxPlasma=fluxPlasma; % Green function for flux contributed by Plasma
gFit.fluxPF=fluxPF; % Green function for flux contributed by PF





load([gFit.pathEF '\exp\GreenFluxBnBtDiag'],'greenPlasma','greenPF','Bn','Bt','Bnp','Btp')% diag position

gFit.greenPlasma=greenPlasma;  %
gFit.greenPF=greenPF;  %
gFit.Bn=Bn;  %
gFit.Bt=Bt;  %
gFit.Bnp=Bnp;  %
gFit.Btp=Btp;  %
gFit.vStep=0.00005; % initial flux step for geting plasma boundary in V.S
gFit.okStep=0.00001;  % minimum flux step for geting plasma boundary V.S


return



%% shot involved data


[~,~,Xp,~,~,~,~,~,alphaIndex]=getPlasma0D(gFit.shapeType);
gFit.alphaIndex=alphaIndex; % the index of equilibrium iteration for GAQ model

% dataFile=['d:\data\hl2a\exp\calibrationRatio' '20833' '.mat'];
% load(dataFile,'calibrationRatioBn','calibrationRatioBt')

%% preparing the Green function
%************************************************************************************************
if 0
    %diagnostic location
    [Point,theta]=getDiagnostic(1);
    % theta=reshape(theta,numel(theta),1);
    fluxPoint=Point(:,end-3:end);
    BPoint=Point(:,1:end-4);
    % green function preparation
    [greenPlasma,greenPF]=getBoundaryGreenFn(fluxPoint,2); % 2=flux diagnostic position
    % [Bn,Bt,Bnp,Btp]=getBoundaryGreenFnBfield(BPoint,2); % 2=normal and tangential
    [Bn,Bt,Bnp,Btp]=getBoundaryGreenFnBfield(BPoint,3); % 2=normal and tangential
    save([gFit.pathEF '\exp\GreenFluxBnBtDiag'],'greenPlasma','greenPF','Bn','Bt','Bnp','Btp')
else
        load([gFit.pathEF '\exp\GreenFluxBnBtDiag'],'greenPlasma','greenPF','Bn','Bt','Bnp','Btp')% diag position
end
%************************************************************************************************
       
dataFile=[gFit.pathEF '\exp\RatioFluxBnBtDiag' num2str(CurrentShot) '.mat'];
if  exist(dataFile,'file')==2   %0%
    load(dataFile,'calibrationRatioFlux','calibrationRatioBn','calibrationRatioBt')
else
    [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(CurrentShot,2500,2900,2920,'EX');
end



gFit.calibrationRatioFlux=calibrationRatioFlux;  % 4 element vector
gFit.calibrationRatioBn=calibrationRatioBn;  % 18 element vector 
gFit.calibrationRatioBt=calibrationRatioBt;% 18 element vector 




% htext=title('fit and iterative process','color','k','edge','b','BackgroundColor',[.7 .6 .9],'FontSize',16);
% if isempty(h0)
%     h0=line(1,1,'Color','b');
%     h1=line(1,1,'Color','m');
%     h2=line(1,1,'Color','r');
%     h3=line(1,1,'Color','r'); % second curve
% end

