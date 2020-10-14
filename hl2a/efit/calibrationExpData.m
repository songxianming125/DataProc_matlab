function [fluxMeasured,BnMeasured,BtMeasured,Ip,Iex,betap]=calibrationExpData(CurrentShot,CurrentTime)
%% get experiment data from data base and calibration the B field
% smooth the experimental data

% Bn: 4 5 11 12 13 with wrong data
% Bn: 5 11 with wrong data
gFit=getappdata(0,'gFit');

betap=0.2;
% profile on
[Point,theta]=getDiagnostic(1);
fluxPoint=Point(:,end-3:end);
BPoint=Point(:,1:end-4);

%    % unit cm


NX=5;
NY=5;
numPoints=numel(theta);


% tic
% conditioning and preparing the data
dataFile=[gFit.pathEF '\exp\calibrationBfield' num2str(CurrentShot) '.mat'];
if exist(dataFile,'file')==2 %0 %
    load(dataFile)
else
    
    
    percentageSmooth=0.002;  % how much area for smooth
    methodSmooth='loess';
    
    % green function preparation
    [Bn,Bt,Bnp,Btp]=getBoundaryGreenFnBfield(BPoint,4); % take into account the probe area. BField green function for magnetic probe.
    t0=-1000; % start time
    t1=1600;  % end time
    
    [fluxMeasured,tf]=hl2adb(CurrentShot,{'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d' 'FEx_Ip'},t0,t1,1,'fbc');
    parfor i=1:size(fluxMeasured,2)
        fluxMeasured(:,i)=smooth(fluxMeasured(:,i),percentageSmooth,methodSmooth);
    end
    Ip=fluxMeasured(:,end);
    fluxMeasured(:,end)=[];
    
    [BnMeasured,tv]=hl2adb(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},t0,t1,1,'vax');
    parfor i=1:size(BnMeasured,2)
        BnMeasured(:,i)=smooth(BnMeasured(:,i),percentageSmooth,methodSmooth);
    end
    BtMeasured=BnMeasured(:,19:36);
    BnMeasured(:,19:36)=[];  % only 18
    
    %     [iPF,tm]=hl2adb(CurrentShot,{'Ioh' 'Iv' 'Ir' 'Imp1_3' 'Imp2_mc'},t0,t1,1,'mmd');
    [iPF,tm]=hl2adb(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},t0,t1,1,'FBC');
    index=[1 3 4];
    iPF(:,index)=-iPF(:,index); %the sign of current Ioh and Imp1 is reversed
    
    
    
    parfor i=1:size(iPF,2)
        iPF(:,i)=smooth(iPF(:,i),percentageSmooth,methodSmooth);
    end
    save(dataFile)
end
%
% return








%% calibration B field
calibrationTime=CurrentTime;


indexPF=find(calibrationTime==tm);



% zd=hl2azd(20833,{'Ioh' 'Iv' 'Ir' 'Imp1_3' 'Imp2_mc'},-600,-580,1,'mmd');
zd=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},-600,-580,1,'FBC');


index=[1 3 4];
zd(:,index)=-zd(:,index); %the sign of current Ioh and Imp1 is reversed




%cancel offset in the value at calibrationTime1
iPF(indexPF,:)=iPF(indexPF,:)-zd;  

Iex=[iPF(indexPF,1:3) 0 0 0 0 iPF(indexPF,4:5) iPF(indexPF,4:5)]*1e3; % kA

if strcmp(getappdata(0,'calibrationMode'),'E2')
    Iex=[0 0 0 0 0 0 0 iPF(indexPF,4) 0 iPF(indexPF,4) 0]*1e3; % E2 or mp1 and mp3
elseif strcmp(getappdata(0,'calibrationMode'),'VF')
    Iex=[0 iPF(indexPF,2) 0 0 0 0 0 0 0 0 0]*1e3; % VF only
end

BnCalculationPF=Bn*reshape(Iex,numel(Iex),1);
BtCalculationPF=Bt*reshape(Iex,numel(Iex),1);

BnCalculationPF=reshape(BnCalculationPF,[numPoints NX*NY]);
BtCalculationPF=reshape(BtCalculationPF,[numPoints NX*NY]);


% 13 is the center of probe, indicate the mean value
oldBn=BnCalculationPF(:,13);
oldBt=BtCalculationPF(:,13);


BnCalculationPF=mean(BnCalculationPF,2);
BtCalculationPF=mean(BtCalculationPF,2);
%



errN=abs(BnCalculationPF-oldBn)./BnCalculationPF;
errT=abs(BtCalculationPF-oldBt)./BtCalculationPF;




zd=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},1580,1590,1,'vax');


indexPF=find(calibrationTime==tv);

BnMeasured(indexPF,:)=BnMeasured(indexPF,:)-zd(1:18);  %cancel offset in the value at calibrationTime1
BtMeasured(indexPF,:)=BtMeasured(indexPF,:)-zd(19:36);  %cancel offset in the value at calibrationTime1




calibrationRatioBn=BnCalculationPF'./BnMeasured(indexPF,:);
calibrationRatioBt=BtCalculationPF'./BtMeasured(indexPF,:);


disp(['t=' num2str(calibrationTime) '/r=' num2str(calibrationRatioBn)])
disp(['t=' num2str(calibrationTime) '/r=' num2str(calibrationRatioBt)])
%% 
%% 
dataFile=[gFit.pathEF '\exp\calibrationRatio' num2str(CurrentShot) '.mat'];
save(dataFile,'calibrationRatioBn','calibrationRatioBt')
% profile viewer
%% 
return


% get the value at CurrentTime
fluxMeasured=fluxMeasured(CurrentTime==tf,:).*calibrationRatio;
BnMeasured=BnMeasured(CurrentTime==tv,:)'; % Tesla
BtMeasured=BtMeasured(CurrentTime==tv,:)'; % Tesla
indexPF=find(CurrentTime==tm);
Iex=[iPF(indexPF,1:3) 0 0 0 0 iPF(indexPF,4:5) iPF(indexPF,4:5)]*1e3; % kA


return

