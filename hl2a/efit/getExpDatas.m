function gFit=getExpDatas(CurrentShot,tStart,tEnd,gFit,varargin)
%% get experiment data from data base
% and smooth the experimental data

% Bn: 4 5 11 12 13 with wrong data
%% zero drift is ok

%         there are 4 
if nargin>=4
    isOK=varargin{1};
else
    isOK=1;
end



% tic
dataFile=[gFit.pathEF '\exp\fluxBfield' num2str(CurrentShot) '.mat'];
if  exist(dataFile,'file')==2  &&  isOK %0%
    load(dataFile,'fluxMeasured','BnMeasured','BtMeasured','Ip','iPF','betap','tf','tv','tm','te')
else
    percentageSmooth=0.00002;
    methodSmooth='loess';
    
    [Point,theta]=getDiagnostic(1);
    fluxPoint=Point(:,end-3:end);
    BPoint=Point(:,1:end-4);
    
    % green function preparation

    t0=tStart; % start time
    t1=tEnd;  % end time
    
    
    [RZMeasured,tf]=hl2adb(CurrentShot,{'fDh' 'fDv'},t0,t1,1,'fbc');
    parfor i=1:size(RZMeasured,2)
        RZMeasured(:,i)=smooth(RZMeasured(:,i),percentageSmooth*10,methodSmooth);
    end
    
    
    [fluxMeasured,tf]=hl2adb(CurrentShot,{'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d' 'FEx_Ip'},t0,t1,1,'fbc');
    
    parfor i=1:size(fluxMeasured,2)
        fluxMeasured(:,i)=smooth(fluxMeasured(:,i),percentageSmooth*10,methodSmooth);
    end
    
    Ip=fluxMeasured(:,end);
    fluxMeasured(:,end)=[];
    % null drift    
     zdFlux=hl2azd(CurrentShot,{'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d'},gFit.zdTstart,gFit.zdTend,1,'FBC');
     fluxMeasured=fluxMeasured-repmat(zdFlux,[size(fluxMeasured,1) 1]); %cancel the null drift
    [BnMeasured,tv]=hl2adb(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},t0,t1,1,'vax');
    parfor i=1:size(BnMeasured,2)
        BnMeasured(:,i)=smooth(BnMeasured(:,i),percentageSmooth,methodSmooth);
    end
    % null drift    
    zdBnMeasured=hl2azd(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},gFit.zdTstart,gFit.zdTend,1,'vax');
    BnMeasured=BnMeasured-repmat(zdBnMeasured,[size(BnMeasured,1) 1]); %cancel the null drift
    BtMeasured=BnMeasured(:,19:36);
    BnMeasured(:,19:36)=[];
    
%     [iPF,tm]=hl2adb(CurrentShot,{'Ioh' 'Iv' 'Ir' 'Imp1_3' 'Imp2_mc'},t0,t1,1,'mmd');
    [iPF,tm]=hl2adb(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},t0,t1,1,'FBC');
    index=[1 4];   % OH MP1
    iPF(:,index)=-iPF(:,index); %the sign of current Ioh and Imp1 is reversed

    
    parfor i=1:size(iPF,2)
        iPF(:,i)=smooth(iPF(:,i),percentageSmooth*10,methodSmooth);
    end
    % null drift    
    zdIex=hl2azd(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},gFit.zdTstart,gFit.zdTend,1,'FBC');
    iPF=iPF-repmat(zdIex,[size(iPF,1) 1]); %cancel the null drift

    
    [betap,te]=hl2adb(CurrentShot,'Beta_p',t0,t1,1,'emd');
    parfor i=1:size(betap,2)
        betap(:,i)=smooth(betap(:,i),percentageSmooth*20,methodSmooth);
    end
    save(dataFile,'fluxMeasured','BnMeasured','BtMeasured','Ip','iPF','betap','tf','tv','tm','te')
end
 

gFit.RZMeasured=RZMeasured;  % 4  vectors
gFit.fluxMeasured=fluxMeasured;  % 4  vectors
gFit.BnMeasured=BnMeasured;  % 18  vectors 
gFit.BtMeasured=BtMeasured;% 18  vectors 
gFit.Ip=Ip;  %  1 vector
gFit.Iex=iPF;  % 18 element vector 
gFit.betap=betap;% 18 element vector 
gFit.tf=tf;  % 1 vector
gFit.tv=tv;  % 1 vector
gFit.tm=tm;% 1 vector
gFit.te=te;% 1 vector

return

%% calibration B field

    

%% view1
figure
plot(te,betap)
%% view2
figure
plot(tf,Ip)
%% view3
figure
plot(tv,BnMeasured(:,1))
%% view4

figure
hold on
plot(tm,iPF1(:,2))
plot(tm,iPF(:,2),'r')
plot(tm,iPF1(:,3))
plot(tm,iPF(:,3),'r')


iPF2=iPF1-iPF;
plot(tm,iPF2(:,2))



 