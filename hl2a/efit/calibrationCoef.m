function [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(CurrentShot,CurrentTime,zdTstart,zdTend,calibrationMode,varargin)
%% get experiment data from data base and calibration the B field
% smooth the experimental data

% Bn: 4 5 11 12 13 with wrong data for VF
% Bn: 5 11 with wrong data for E1

% initial value
gFit=getappdata(0,'gFit');


calibrationRatioFlux=[];
calibrationRatioBn=[];
calibrationRatioBt=[];

upperLimit=1.3;
lowerLimit=0.8;

disp(['upperLimit=' num2str(upperLimit) '/lowerLimit=' num2str(lowerLimit)])

load([gFit.pathEF '\exp\GreenFluxBnBtDiag'],'greenPlasma','greenPF','Bn','Bt','Bnp','Btp')
greenPF=gFit.greenPF;  %
Bn=gFit.Bn;  %
Bt=gFit.Bt;  %
% for comparing
load([gFit.pathEF '\exp\RatioFluxBnBtDiag'],'calibrationRatioFlux','calibrationRatioBn','calibrationRatioBt')


calibrationRatioFluxRef=calibrationRatioFlux;
calibrationRatioBnRef=calibrationRatioBn;
calibrationRatioBtRef=calibrationRatioBt;

% calibrationRatioFluxRef=1;
% calibrationRatioBnRef=1;
% calibrationRatioBtRef=1;



switch calibrationMode
    case 'OH'
        % zero drift 
        zdIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},zdTstart,zdTend,1,'FBC');
        zdFlux=hl2azd(CurrentShot,{'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d'},zdTstart,zdTend,1,'FBC');
        % measuring value
        delT=zdTend-zdTstart;
        meanIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},CurrentTime,CurrentTime+delT,1,'FBC');
        meanFlux=hl2azd(CurrentShot,{'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d'},CurrentTime,CurrentTime+delT,1,'FBC');
        % cancel zero drift from measuring mean value
        meanIex=meanIex-zdIex;
        meanFlux=meanFlux-zdFlux;
        
        index=[1 4];
        meanIex(index)=-meanIex(index); %the sign of current Ioh and Imp1 is reversed

        Iex=[meanIex(1) 0 0 0 0 0 0 0 0 0 0]*1e3; % OH only
        fluxCalculation=greenPF*reshape(Iex,numel(Iex),1);
        
        
%         Iex=[0 meanIex(1) 0 0 0 0 0 0 0 0 0]*1e3; % VF only
%         fluxCalculation=greenPF*reshape(Iex,numel(Iex),1);
        
        
        
        
        
        
        
        
        calibrationRatioFlux=fluxCalculation'./meanFlux;
        disp(['s=' num2str(CurrentShot) '/t=' num2str(CurrentTime) '/rFlux=' num2str(calibrationRatioFlux)])
        
        indexGT=find(abs(calibrationRatioFlux)>upperLimit);
        indexLT=find(abs(calibrationRatioFlux<lowerLimit));
        
        index=union(indexGT,indexLT);

         if ~isempty(index)
                           disp(['index=' num2str(index) '/rFlux=' num2str(calibrationRatioFlux(index))])
        end
        
        
    case 'VF'
        % zero drift 
        zdIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},zdTstart,zdTend,1,'FBC');
        zdBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},zdTstart,zdTend,1,'vax');
        
        
        % measuring value
        delT=zdTend-zdTstart;
        meanIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},CurrentTime,CurrentTime+delT,1,'FBC');
        meanBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},CurrentTime,CurrentTime+delT,1,'vax');
        % cancel zero drift from measuring value
        meanIex=meanIex-zdIex;
        meanBnMeasured=meanBnMeasured-zdBnMeasured;
        
        BtMeasured=meanBnMeasured(19:36);
        BnMeasured=meanBnMeasured(1:18);  % only 18

        
        index=[1 4];
        meanIex(index)=-meanIex(index); %the sign of current Ioh and Imp1 is reversed
        Iex=[0 meanIex(2) 0 0 0 0 0 0 0 0 0]*1e3; % VF only
        
        BnCalculationPF=Bn*reshape(Iex,numel(Iex),1);
        BtCalculationPF=Bt*reshape(Iex,numel(Iex),1);
        calibrationRatioBn=BnCalculationPF'./BnMeasured;
        calibrationRatioBt=BtCalculationPF'./BtMeasured;
        % for VF power supply
        cancelBnIndex=[4 5 11 12 13];  
        calibrationRatioBn(cancelBnIndex)=1;
        
        
        disp(['cancelBnIndex=' num2str(cancelBnIndex)])
        disp(['s=' num2str(CurrentShot) '/rBn=' num2str(calibrationRatioBn)])
        disp(['t=' num2str(CurrentTime) '/rBt=' num2str(calibrationRatioBt)])
        
        
        
    case 'E2'
        % zero drift 
        zdIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},zdTstart,zdTend,1,'FBC');
        zdBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},zdTstart,zdTend,1,'vax');
        
        
        % measuring value
        delT=zdTend-zdTstart;
        meanIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},CurrentTime,CurrentTime+delT,1,'FBC');
        meanBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},CurrentTime,CurrentTime+delT,1,'vax');
        % cancel zero drift from measuring value
        meanIex=meanIex-zdIex;
        meanBnMeasured=meanBnMeasured-zdBnMeasured;
        
        BtMeasured=meanBnMeasured(19:36);
        BnMeasured=meanBnMeasured(1:18);  % only 18

        
        index=[1 4];
        meanIex(index)=-meanIex(index); %the sign of current Ioh and Imp1 is reversed
        Iex=[0 0 0 0 0 0 0 meanIex(4) 0 meanIex(4) 0]*1e3; % E2 or mp1 and mp3

        BnCalculationPF=Bn*reshape(Iex,numel(Iex),1);
        BtCalculationPF=Bt*reshape(Iex,numel(Iex),1);
        calibrationRatioBn=BnCalculationPF'./BnMeasured;
        calibrationRatioBt=BtCalculationPF'./BtMeasured;
        % for E2 power supply
        cancelBnIndex=[5 11];
        calibrationRatioBn(cancelBnIndex)=1;
        disp(['cancelBnIndex=' num2str(cancelBnIndex)])
        
        disp(['s=' num2str(CurrentShot) '/rBn=' num2str(calibrationRatioBn)])
        disp(['t=' num2str(CurrentTime) '/rBt=' num2str(calibrationRatioBt)])
    case 'E3MP1'
         % zero drift 
        zdIex=hl2azd(CurrentShot,'LFE3A',zdTstart,zdTend,1,'LFB');
        zdBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},zdTstart,zdTend,1,'vax');
        
        
        % measuring value
        delT=zdTend-zdTstart;
        meanIex=hl2azd(CurrentShot,'LFE3A',CurrentTime,CurrentTime+delT,1,'LFB');
        meanBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},CurrentTime,CurrentTime+delT,1,'vax');
        % cancel zero drift from measuring value
        meanIex=meanIex-zdIex;
        meanBnMeasured=meanBnMeasured-zdBnMeasured;
        
        BtMeasured=meanBnMeasured(19:36);
        BnMeasured=meanBnMeasured(1:18);  % only 18

        
        
        
        %% E3 Power for MP1
        Iex=[0 0 0 0 0 0 0 meanIex 0 0 0]*1e3; % 

        BnCalculationPF=Bn*reshape(Iex,numel(Iex),1);
        BtCalculationPF=Bt*reshape(Iex,numel(Iex),1);
        
        
        calibrationRatioBn=BnCalculationPF'./BnMeasured;
        calibrationRatioBt=BtCalculationPF'./BtMeasured;
        cancelBnIndex=[4 5 11];
        calibrationRatioBn(cancelBnIndex)=1;
        disp(['cancelBnIndex=' num2str(cancelBnIndex)])
        
        disp(['s=' num2str(CurrentShot) '/rBn=' num2str(calibrationRatioBn)])
        disp(['t=' num2str(CurrentTime) '/rBt=' num2str(calibrationRatioBt)])   
    case 'E3MP2'
         % zero drift 
        zdIex=hl2azd(CurrentShot,'LFE3A',zdTstart,zdTend,1,'LFB');
        zdBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},zdTstart,zdTend,1,'vax');
        
        
        % measuring value
        delT=zdTend-zdTstart;
        meanIex=hl2azd(CurrentShot,'LFE3A',CurrentTime,CurrentTime+delT,1,'LFB');
        meanBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},CurrentTime,CurrentTime+delT,1,'vax');
        % cancel zero drift from measuring value
        meanIex=meanIex-zdIex;
        meanBnMeasured=meanBnMeasured-zdBnMeasured;
        
        BtMeasured=meanBnMeasured(19:36);
        BnMeasured=meanBnMeasured(1:18);  % only 18

        
        
        
        %% E3 Power for MP2
        Iex=[0 0 0 0 0 0 0 0 meanIex 0 0]*1e3; % 

        BnCalculationPF=Bn*reshape(Iex,numel(Iex),1);
        BtCalculationPF=Bt*reshape(Iex,numel(Iex),1);
        
        
        calibrationRatioBn=BnCalculationPF'./BnMeasured;
        calibrationRatioBt=BtCalculationPF'./BtMeasured;
        cancelBnIndex=[4 5 11];
        calibrationRatioBn(cancelBnIndex)=1;
        disp(['cancelBnIndex=' num2str(cancelBnIndex)])
        
        disp(['s=' num2str(CurrentShot) '/rBn=' num2str(calibrationRatioBn)])
        disp(['t=' num2str(CurrentTime) '/rBt=' num2str(calibrationRatioBt)])   
    case 'E3MP3'
         % zero drift 
        zdIex=hl2azd(CurrentShot,'LFE3A',zdTstart,zdTend,1,'LFB');
        zdBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},zdTstart,zdTend,1,'vax');
        
        
        % measuring value
        delT=zdTend-zdTstart;
        meanIex=hl2azd(CurrentShot,'LFE3A',CurrentTime,CurrentTime+delT,1,'LFB');
        meanBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},CurrentTime,CurrentTime+delT,1,'vax');
        % cancel zero drift from measuring value
        meanIex=meanIex-zdIex;
        meanBnMeasured=meanBnMeasured-zdBnMeasured;
        
        BtMeasured=meanBnMeasured(19:36);
        BnMeasured=meanBnMeasured(1:18);  % only 18

        
        
        
        
        %% E3 Power for MP3
        Iex=[0 0 0 0 0 0 0 0 0 meanIex 0]*1e3; % 

        BnCalculationPF=Bn*reshape(Iex,numel(Iex),1);
        BtCalculationPF=Bt*reshape(Iex,numel(Iex),1);
        calibrationRatioBn=BnCalculationPF'./BnMeasured;
        calibrationRatioBt=BtCalculationPF'./BtMeasured;
        cancelBnIndex=[5 11];
        calibrationRatioBn(cancelBnIndex)=1;
        disp(['cancelBnIndex=' num2str(cancelBnIndex)])
        
        disp(['s=' num2str(CurrentShot) '/rBn=' num2str(calibrationRatioBn)])
        disp(['t=' num2str(CurrentTime) '/rBt=' num2str(calibrationRatioBt)])      
    case 'EX'
        %% flux by OH
        if nargin>5 % with CurrentTimeOH
            CurrentTimeOH=varargin{1};
        else 
            CurrentTimeOH=-25;
        end

        
        
        
        % zero drift 
        zdIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},zdTstart,zdTend,1,'FBC');
        zdFlux=hl2azd(CurrentShot,{'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d'},zdTstart,zdTend,1,'FBC');
        % measuring value
        delT=zdTend-zdTstart;
        
        meanIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},CurrentTimeOH,CurrentTimeOH+delT,1,'FBC');
        meanFlux=hl2azd(CurrentShot,{'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d'},CurrentTimeOH,CurrentTimeOH+delT,1,'FBC');
        % cancel zero drift from measuring value
        meanIex=meanIex-zdIex;
        meanFlux=meanFlux-zdFlux;
        
        index=[1 4];
        meanIex(index)=-meanIex(index); %the sign of current Ioh and Imp1 is reversed

        Iex=[meanIex(1) 0 0 0 0 0 0 0 0 0 0]*1e3; % OH only
        fluxCalculation=greenPF*reshape(Iex,numel(Iex),1);
        calibrationRatioFlux=fluxCalculation'./meanFlux./calibrationRatioFluxRef;
        disp(['s=' num2str(CurrentShot) '/t=' num2str(CurrentTime) '/rFlux=' num2str(calibrationRatioFlux)])
        
        
        %% BnBt by VF after discharge
        % zero drift 
        zdIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},zdTstart,zdTend,1,'FBC');
        zdBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},zdTstart,zdTend,1,'vax');
        
        
        % measuring value
        delT=zdTend-zdTstart;
        meanIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},CurrentTime,CurrentTime+delT,1,'FBC');
        meanBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},CurrentTime,CurrentTime+delT,1,'vax');
        % cancel zero drift from measuring value
        meanIex=meanIex-zdIex;
        meanBnMeasured=meanBnMeasured-zdBnMeasured;
        
        BtMeasured=meanBnMeasured(19:36);
        BnMeasured=meanBnMeasured(1:18);  % only 18

        
        index=[1 4];
        meanIex(index)=-meanIex(index); %the sign of current Ioh and Imp1 is reversed
        Iex=[0 meanIex(2) 0 0 0 0 0 0 0 0 0]*1e3; % VF only
        
        BnCalculationPF=Bn*reshape(Iex,numel(Iex),1);
        BtCalculationPF=Bt*reshape(Iex,numel(Iex),1);
        calibrationRatioBn=BnCalculationPF'./BnMeasured./calibrationRatioBnRef;
        calibrationRatioBt=BtCalculationPF'./BtMeasured./calibrationRatioBtRef;
        % for VF power supply
        cancelBnIndex=[4 5 11 12 13];  
        calibrationRatioBn(cancelBnIndex)=1;
        disp(['cancelBnIndex=' num2str(cancelBnIndex)])
        
        disp(['s=' num2str(CurrentShot) '/rBn=' num2str(calibrationRatioBn)])
        disp(['t=' num2str(CurrentTime) '/rBt=' num2str(calibrationRatioBt)])
        
       save([gFit.pathEF '\exp\RatioFluxBnBtDiag' num2str(CurrentShot)],'calibrationRatioFlux','calibrationRatioBn','calibrationRatioBt')

end


% Flux
indexGT=find(abs(calibrationRatioFlux)>upperLimit);
indexLT=find(abs(calibrationRatioFlux<lowerLimit));

index=union(indexGT,indexLT);

if ~isempty(index)
    disp(['indexFluxWarnning=' num2str(index) '/rFlux=' num2str(calibrationRatioFlux(index))])
end
% Bn
indexGT=find(abs(calibrationRatioBn)>upperLimit);
indexLT=find(abs(calibrationRatioBn)<lowerLimit);
index=union(indexGT,indexLT);
if ~isempty(index)
    disp(['indexBnWarnning=' num2str(index) '/rBn=' num2str(calibrationRatioBn(index))])
end

% Bt
indexGT=find(abs(calibrationRatioBt)>upperLimit);
indexLT=find(abs(calibrationRatioBt)<lowerLimit);
index=union(indexGT,indexLT);
if ~isempty(index)
        disp(['indexBtWarnning=' num2str(index) '/rBt=' num2str(calibrationRatioBt(index))])
end


figure
cancelBnIndex=[4 5];

yCalculated=[BnCalculationPF' BtCalculationPF'];
yMeasured=[-BnMeasured BtMeasured];
% yMeasured(cancelBnIndex)=0;

hold on


yErr=zeros(1,length(cancelBnIndex));
yErr=yMeasured(cancelBnIndex);
hLines(1)=plot(yCalculated,'m.','MarkerSize',20);
hLines(2)=plot(yMeasured,'bo','MarkerSize',10);
hLines(3)=plot(cancelBnIndex,yErr,'r*','MarkerSize',12);
legendChannelNames={'calculated','measured','ErrProbe'};
title(['coil: ' calibrationMode(3:end)])

[h1,h2,h3,h4]=legend(hLines,legendChannelNames,1);

box on


% save('d:\data\hl2a\exp\RatioFluxBnBtDiag','calibrationRatioFlux','calibrationRatioBn','calibrationRatioBt')
return







% BnCalculationPF=Bn*reshape(Iex,numel(Iex),1);
% BtCalculationPF=Bt*reshape(Iex,numel(Iex),1);
% 
% BnCalculationPF=reshape(BnCalculationPF,[numPoints NX*NY]);
% BtCalculationPF=reshape(BtCalculationPF,[numPoints NX*NY]);
% 
% 
% % 13 is the center of probe, indicate the mean value
% oldBn=BnCalculationPF(:,13);
% oldBt=BtCalculationPF(:,13);
% 
% 
% BnCalculationPF=mean(BnCalculationPF,2);
% BtCalculationPF=mean(BtCalculationPF,2);
% %
% 
% errN=abs(BnCalculationPF-oldBn)./BnCalculationPF;
% errT=abs(BtCalculationPF-oldBt)./BtCalculationPF;
% 
% 
% 
% 
% zd=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},1580,1590,1,'vax');
% 
% 
% indexPF=find(calibrationTime==tv);
% 
% BnMeasured(indexPF,:)=BnMeasured(indexPF,:)-zd(1:18);  %cancel offset in the value at calibrationTime1
% BtMeasured(indexPF,:)=BtMeasured(indexPF,:)-zd(19:36);  %cancel offset in the value at calibrationTime1
% 
% 
% 
% 
% calibrationRatioBn=BnCalculationPF'./BnMeasured(indexPF,:);
% calibrationRatioBt=BtCalculationPF'./BtMeasured(indexPF,:);
% 
% 
% disp(['t=' num2str(calibrationTime) '/r=' num2str(calibrationRatioBn)])
% disp(['t=' num2str(calibrationTime) '/r=' num2str(calibrationRatioBt)])
% %% 
% %% 
% dataFile=['d:\data\hl2a\exp\calibrationRatio' num2str(CurrentShot) '.mat'];
% save(dataFile,'calibrationRatioBn','calibrationRatioBt')
% % profile viewer
% %% 
% return
% 
% 
% % get the value at CurrentTime
% fluxMeasured=fluxMeasured(CurrentTime==tf,:).*calibrationRatio;
% BnMeasured=BnMeasured(CurrentTime==tv,:)'; % Tesla
% BtMeasured=BtMeasured(CurrentTime==tv,:)'; % Tesla
% indexPF=find(CurrentTime==tm);
% Iex=[iPF(indexPF,1:3) 0 0 0 0 iPF(indexPF,4:5) iPF(indexPF,4:5)]*1e3; % kA
% 
% 
% return

