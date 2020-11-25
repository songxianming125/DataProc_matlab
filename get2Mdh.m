function dh= get2Mdh(shot)
close all
dh=1;
% shot=150;
[Ip,t0]=hl2adb(shot,'IP_IV');




if length(Ip)<10
    [Ip,t]=hl2adb(shot,'IP_VV_2M');
    index=interp1(t,[1:length(t)],t0,'nearest','extrap');
    Ip=Ip(index);
end

[Iv,t]=hl2adb(shot,'IP_OV');
Iv=Iv-Ip;

iPF_equilibrium=[100000 2505 489];
iPF_uni=iPF_equilibrium/iPF_equilibrium(1);  %coil current for 1A plasma  
Bv_request=-(iPF_uni(2)*23+iPF_uni(3)*156)*Ip;  %% field coef for kA

%% Bv required by Plasma
betap=0.2;
li=1.5;
lamdaBv=betap+li/2-1;

R0=1.78;
a=0.6;
muBy4pi=1.0e-7;  % mu/4pi

BvReq=-muBy4pi/R0*(log(8*R0/a)+lamdaBv-1/2)*1.0e7;
BvReq=BvReq*Ip; % T ->Gauss and Ip in A;

[iPFcs68,t]=hl2adb(shot,{'CS_I','PF6U_I','PF8U_I'});
[inFluxDiag,t]=hl2adb(shot,{'FL_IV05','FL_IV17','FL_IV20','FL_IV32'});



iPFcs68=iPFcs68;  
numTime=length(t);
Numcoils=18;

iPF=zeros(numTime,Numcoils);
iPF(:,1:2)=[iPFcs68(:,1)/2 iPFcs68(:,1)/2];
iPF(:,13:14)=[iPFcs68(:,2) iPFcs68(:,2)];
%%  eddy current  equal to IPF8 for flux and B field calculation 
factorEddy2IPF8=0.00221;
iPFcs68(:,3)=iPFcs68(:,3)+factorEddy2IPF8*Iv;

iPF(:,17:18)=[iPFcs68(:,3) iPFcs68(:,3)];

%setDiagnosticGreenFn;
GF=getDiagnosticGreenFn;

centerPoint=[1.58 1.78 1.98; 0 0 0];
[BX,BY,BXp,BYp,BXv,BYv]=getBoundaryGreenFnBfield(centerPoint,1);

% BYcs68=BY(2,[1 13 17]);
% iPFCS=[iPFcs68(:,1) iPFcs68(:,2)*2 iPFcs68(:,3)*2];
% iPFCS=iPFCS';

iPF=iPF';

% Bv=BY(2,:)*iPF*1.0e7; %% kA->Gauss
Bv=BY*iPF*1.0e7; %% kA->Gauss

% Bv1=BYcs68*iPFCS*1.0e7; %% kA->Gauss
% dBv=Bv-Bv1;

Bv=Bv';
% 

innerFluxPF=GF.innerFluxPF*iPF*1e3;  %% kA ->Vs

% cmd=['innerFluxPF'   '=GF.innerFluxPF*iPF''' ';'];
% eval(cmd)
indexDh=[5,17,20,32];

inFluxByPF=innerFluxPF(indexDh,:);
inFluxByPF=inFluxByPF';

inFluxByPlasma=inFluxDiag-inFluxByPF;

% figure;hold on;plot(t,inFluxDiag(:,1),'r');plot(t,inFluxDiag(:,2),'m');plot(t,inFluxDiag(:,3),'k');plot(t,inFluxDiag(:,4),'b')
% figure;hold on;plot(t,inFluxByPF(:,1),'r');plot(t,inFluxByPF(:,2),'m');plot(t,inFluxByPF(:,3),'k');plot(t,inFluxByPF(:,4),'b')
% figure; title('inFluxByPlasma');hold on;plot(t,inFluxByPlasma(:,1),'r');plot(t,inFluxByPlasma(:,2),'m');plot(t,inFluxByPlasma(:,3),'k');plot(t,inFluxByPlasma(:,4),'b')
dFay=inFluxByPlasma(:,2)+inFluxByPlasma(:,3)-inFluxByPlasma(:,1)-inFluxByPlasma(:,4);
index=Ip>20;
dH(~index)=0;
dH(index)=dFay(index)./Ip(index);
dH=dH';
% figure;hold on;title('dH ignore eddy current');plot(t,dH*10000,'r');plot(t,Ip,'b')
UD.saveInterruptive=0;
UD.MyShot=num2str(shot);
UD.t=t/1000; % time in second
UD.y=[inFluxByPlasma dFay dH Bv BvReq Bv_request Ip Iv]; % curves
UD.C1='';
UD.C2='';
UD.C3='';
UD.ChnlName={'FluxP05','FluxP17','FluxP20','FluxP32','dFay','dHByFay','Bv158','Bv178','Bv198','BvReq1','BvReq2','Ip','Iv'};
UD.Unit={'Vs','Vs','Vs','Vs','Vs','mm','Gauss','Gauss','Gauss','Gauss','Gauss','kA','kA'};
UD.ext='DHV';  
putIn2mDB(UD,0)
disp(['shot:' UD.MyShot ' is Ready!'])
dh=0;
end

