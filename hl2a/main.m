
%  [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(27970,2500,2900,2920,'EX');
[calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(27974,1950,-10,0,'E3MP1');
[calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(27974,1950,-10,0,'E3MP2');
[calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(27974,1950,-10,0,'E3MP3');
% [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(27974,1950,-10,0,'E3MP1');
%   [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(23719,2500,2900,2920,'EX');
%   [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(23718,2500,2900,2920,'EX');
% [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(23719,-25,2900,2920,'OH');
%  [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(23716,2500,2900,2920,'VF');
% [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(23688,500,2900,2920,'E2');
return

27970





setappdata(0,'MachineCode','2A')


% CurrentShot=23628; % VF calibration
% CurrentShot=23118; % VF calibration
% setappdata(0,'calibrationMode','VF')
% CurrentShot=20833; % VF calibration
CurrentShot=23686; % VF calibration
CurrentTime=500; %  in the top 
setappdata(0,'calibrationMode','VF')


% CurrentShot=23630; % E2 calibration
% CurrentShot=23688; % E2 calibration
% setappdata(0,'calibrationMode','E2')
% CurrentTime=500; % 500ms  in the top 
disp(CurrentShot)
[fluxMeasured,BnMeasured,BtMeasured,Ip,Iex,betap]=calibrationExpData(CurrentShot,CurrentTime);
return
% y=setGSdata;
% return

% XY=0;
% [fluxPlasma,fluxPF]=getFluxCoefAtBoundary(XY);
% save('C:\2W\data\fluxLimiter.mat','fluxPlasma','fluxPF')

% M1=getML(1,1);
% M2=getML(1,2);
% M4=getML(2,2);
% M5=getML(3,3);
%  return
% 




% p=DrawBackground(0.4);
for index=1:11
    [X4,Y4,ATurnCoil]=getLocation(index);
        factor=(ATurnCoil/max(ATurnCoil(:)))';
        factor=abs(factor);
        factorthree=[factor factor/2 1-factor];
        mycolor=mat2cell(factorthree,[linspace(1,1,length(factor))],[3]);
        
        XX=[X4;X4];
        YY=[Y4;Y4+0.0001];
        h=plot(XX,YY,'.','LineWidth',1); %plasma
        set(h,{'Color'},mycolor)
end


%%
CurrentShot=23686; % VF calibration
[calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(CurrentShot,500,2900,2920,'OH');
%%
figure
hold on
CurrentShot=23686; % VF calibration
% CurrentChannel='FbBv';
% [y,t]=hl2aweb(CurrentShot,CurrentChannel,0,2000,1);
% plot(t,y)
CurrentChannel='Fay_I_u';
[y,t]=hl2aweb(CurrentShot,CurrentChannel,0,2000,1);
plot(t,y)

% CurrentChannel='(Fay_o_u,Fay_I_u)';
% [y,t]=hl2aweb(CurrentShot,CurrentChannel,0,2000,1);
% plot(t,y)

% CurrentChannel={'FbBv' 'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d'};
% [y,t]=hl2aweb(CurrentShot,CurrentChannel,0,2000,1);

%%




