function efitSimulation(handles,CurrentShot)
%% test the simulation result
% global Ip Xp Yp betap alphaIndex
% global Iex %shapeType limiterRadius

% profile on
gFit=getappdata(0,'gFit');
outFile=[gFit.pathEF '\exp\outFit' num2str(CurrentShot) '.mat'];
if 0 % exist(outFile,'file')==2   % 0 %
    load(outFile,'outFit')
    setappdata(0,'outFit',outFit)
    Fit=outFit.Fit;
    setappdata(0,'Fit',Fit)
    fbcTime=outFit.fbcTime;
    fbcCurves=outFit.fbcCurves;
    
    outDh=outFit.Dh;
    outDv=outFit.Dv;
    outIp=outFit.Ip;
    outTime=outFit.outTime;
    set(handles.Info,'String',['shot:' num2str(CurrentShot) ' is ready!']);
    set(handles.Info,'Value',1);
else

    set(handles.Info,'String',['shot:' num2str(CurrentShot) ' is processing, please wait a few minutes!']);
    set(handles.Info,'Value',1);
    
    xStart=fix(str2double(get(handles.Start,'String')));
    xEnd=fix(str2double(get(handles.End,'String')));
    xStep=fix(str2double(get(handles.Step,'String')));
    
    numData=(xEnd-xStart)+1;
    
    
    fbcDh=zeros(numData,1);
    fbcDv=zeros(numData,1);
    fbcIp=zeros(numData,1);
    fbcT=xStart:xEnd;
    Fit(1:numData)=struct();
    
    
    X1=gFit.X1;
    [row,col]=size(X1);
    
    
    outM=cell(1,numData);
    outFit.Dh=zeros([1 numData]);
    outFit.Dv=zeros([1 numData]);
    outFit.Ip=zeros([1 numData]);

    
    outV=zeros([1 numData]);
    
    
    outPhiCenter=zeros([1 numData]);
    outC = cell(1,numData);
    outIndex = cell(1,numData);
    
    
    [fbcCurves,fbcTime]=hl2adb(CurrentShot,{'FDh' 'FDv' 'FEx_Ip'},xStart,xEnd,1,'fbc');
    % hDh(2)=line('Parent',handles.RDh,'XData',fbcTime,'YData',fbcCurves(:,1));
    % hDv(2)=line('Parent',handles.ZDv,'XData',fbcTime,'YData',fbcCurves(:,2));
    % hIp(2)=line('Parent',handles.Ip,'XData',fbcTime,'YData',fbcCurves(:,3));
    outFit.fbcTime=fbcTime;
    outFit.fbcCurves=fbcCurves;
    
    alphaIndex=1; %power in normalized phi
    gFit.alphaIndex=alphaIndex; % the index of equilibrium iteration for GAQ model
    
    % dataFile=['d:\data\hl2a\exp\calibrationRatio' '20833' '.mat'];
    % load(dataFile,'calibrationRatioBn','calibrationRatioBt')
    
    %% preparing the Green function
    %************************************************************************************************
    %************************************************************************************************
    
    dataFile=[gFit.pathEF '\exp\RatioFluxBnBtDiag' num2str(CurrentShot) '.mat'];
    if  exist(dataFile,'file')==2   %0%
        %     load('d:\data\hl2a\exp\RatioFluxBnBtDiag','calibrationRatioFlux','calibrationRatioBn','calibrationRatioBt')
        load(dataFile,'calibrationRatioFlux','calibrationRatioBn','calibrationRatioBt')
    else
%         [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(CurrentShot,2500,2900,2920,'EX');
        [calibrationRatioFlux,calibrationRatioBn,calibrationRatioBt]=calibrationCoef(CurrentShot,gFit.zdTime,gFit.zdTstart,gFit.zdTend,'EX');  %
    end
    gFit.calibrationRatioFlux=calibrationRatioFlux;  % 4 element vector
    gFit.calibrationRatioBn=calibrationRatioBn;  % 18 element vector
    gFit.calibrationRatioBt=calibrationRatioBt;% 18 element vector
    
    
    gFit=getExpDatas(CurrentShot,10,1800,gFit);
    
    
    %% draw curves
    
    
    
 %%  measured times the calibration coefficient   
    % for CurrentTime=xStart:xEnd
    for CurrentTime=1:xEnd-xStart+1
        [fluxMeasured,BnMeasured,BtMeasured,Ip,Iex,betap]=getExpData(CurrentTime+xStart,gFit);
        % measured after calibration
        Fit(CurrentTime).fluxMeasured=fluxMeasured.*calibrationRatioFlux;
        Fit(CurrentTime).BnMeasured=BnMeasured.*calibrationRatioBn';
        Fit(CurrentTime).BtMeasured=BtMeasured.*calibrationRatioBt';
        Fit(CurrentTime).vStep=gFit.vStep*10; % initial flux step for geting plasma boundary in V.S
        Fit(CurrentTime).okStep=gFit.okStep*10;  % minimum flux step for geting plasma boundary V.S
        %
        %      disp(['fluxMeasured=' num2str(fluxMeasured)])
        %      disp(['BnMeasured=' num2str(BnMeasured')])
        %      disp(['BtMeasured=' num2str(BtMeasured')])
        %      disp(['Ip=' num2str(Ip)])
        %      disp(['Iex=' num2str(Iex)])
        %
        
        %         betap=0.2;
        %         if Iex(8)>5e3;
        %             Yp=-0.06; % divertor
        %         else
        %             Yp=0; % limiter
        %         end
        %         y=setPlasmaPosition(Xp,Yp);
        
        
        fluxByPF=gFit.fluxPF*Iex'; % should transpose
        
        Fit(CurrentTime).fluxByPF=fluxByPF; % flux contributed by PF
        Fit(CurrentTime).Iex=Iex; % PF current
        
        Fit(CurrentTime).Ip=Ip; % plasma current
        if Iex(8)>1e3
            Fit(CurrentTime).Xp=gFit.Xp; % plasma geo center radial position
            Fit(CurrentTime).Yp=-0.05; % plasma geo center vertical position
        else
            Fit(CurrentTime).Xp=gFit.Xp; % plasma geo center radial position
            Fit(CurrentTime).Yp=gFit.Yp; % plasma geo center vertical position
        end
        Fit(CurrentTime).betap=betap; % plasma betap
        
    end
    
    setappdata(0,'Fit',Fit);
  %% parallel computing  for equilibrium reconstruction
    for CurrentTime=1:xEnd-xStart+1
        %     if ~mod(CurrentTime,xStep)
        if ~mod(CurrentTime,1)
            j=[];
            [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
            [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
            [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
%             hShow=ShowShape(gFit,M,v,phiCenter,C,index);
            
            nLoop=1;
            for ii=1:nLoop
                [j,beta]=jEFIT(j,gFit,Fit(CurrentTime));
                [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime),betap);
%                 hShow=ShowShape(gFit,M,v,phiCenter,C,index);
            end
            
            nLoop=3;
            for ii=1:nLoop
                [j,beta,M,C,C1,v,index,phiCenter,totalJ]=jEFIT(j,gFit,Fit(CurrentTime));
%                 [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime),betap);
%                 hShow=ShowShape(gFit,M,v,phiCenter,C,index);
            end

            
            outDh(CurrentTime)=((min(C(1,2:end))+max(C(1,2:end)))/2);
            outDv(CurrentTime)=((min(C(2,2:end))+max(C(2,2:end)))/2);
            outIp(CurrentTime)=totalJ;          
                 
            
            outM(CurrentTime)={M};
            outC(CurrentTime)={C};
            outV(CurrentTime)=v;
            outPhiCenter(CurrentTime)=phiCenter;
            outIndex(CurrentTime) = {index};
        end
    end
    
    outFit.C=outC;
    
    outFit.Dh=outDh;
    outFit.Dv=outDv;
    outFit.Ip=outIp;
    
    outFit.M=outM;
    outFit.v=outV;
    outFit.phiCenter=outPhiCenter;
    outFit.index=outIndex;
%     outFit.gFit=gFit;
    outFit.Fit=Fit;
    outTime=xStart+1:xEnd+1;

    outFit.outTime=outTime;

    setappdata(0,'outFit',outFit)
    save(outFile,'outFit')
    set(handles.Info,'String',['shot:' num2str(CurrentShot) ' is ready!']);
    set(handles.Info,'Value',1);
%     msgbox('data ready!',num2str(CurrentShot),'warn','modal');
end
%%
cla(handles.RDh)
cla(handles.ZDv)
cla(handles.Ip)

% change from m to cm
outDh=(outDh-1.65)*100;
outDv=outDv*100;
outIp=outIp/1000; % A->kA
fbcCurves(:,1)=fbcCurves(:,1)*2;
fbcCurves(:,2)=fbcCurves(:,2)*3;
% fbcCurves(:,1)=fbcCurves(:,1);


hRZIP(1)=line('Parent',handles.RDh,'XData',fbcTime,'YData',fbcCurves(:,1),'Marker','.','Color','k');
hRZIP(2)=line('Parent',handles.ZDv,'XData',fbcTime,'YData',fbcCurves(:,2),'Marker','.','Color','k');
hRZIP(3)=line('Parent',handles.Ip,'XData',fbcTime,'YData',fbcCurves(:,3),'Marker','.','Color','k');
haxes(1)=line('Parent',handles.RDh,'XData',outTime,'YData',outDh,'Marker','.','Color','r');
haxes(2)=line('Parent',handles.ZDv,'XData',outTime,'YData',outDv,'Marker','.','Color','r');
haxes(3)=line('Parent',handles.Ip,'XData',outTime,'YData',outIp,'Marker','.','Color','r');


RDhmax=max(max(fbcCurves(:,1)),max(outDh));
RDhmin=min(min(fbcCurves(:,1)),min(outDh));
RDvmax=max(max(fbcCurves(:,2)),max(outDv));
RDvmin=min(min(fbcCurves(:,2)),min(outDv));
Ipmax=max(max(fbcCurves(:,3)),max(outIp));
Iphmin=min(min(fbcCurves(:,3)),min(outIp));


set(handles.RDh,'YLim',[RDhmin RDhmax]);
set(handles.ZDv,'YLim',[RDvmin RDvmax]);
set(handles.Ip,'YLim',[Iphmin Ipmax]);






MyYTick(handles.RDh,3,2);
MyYTick(handles.ZDv,3,2);
MyYTick(handles.Ip,3,1);



set(handles.RDh,'XGrid','on','YGrid','on')
set(handles.ZDv,'XGrid','on','YGrid','on')
set(handles.Ip,'XGrid','on','YGrid','on')
setappdata(0,'haxes',haxes)
setappdata(0,'hRZIP',hRZIP)

return
%************************************************************************************************
% profile viewer
%% view
close all
figure
% CurrentShot=20985;  %divertor  0.4
ts=1:1500;

[Dhv,tf]=hl2adb(CurrentShot,{'FDh' 'FDv'},1,1500,1,'fbc');
% plot(tf,Dhv(:,1)*2,'.r')

% figure
hold on
plot(tf,Dhv(:,1)*5,'.r')
plot(tf,Dhv(:,2)*5,'.b')

% figure
% hold on
plot(ts,Dh,'.m')
plot(ts,Dv,'.c')

% matlabpool close
%%
close all
Init2A
setappdata(0,'MachineCode','2A')

limiterRadius=0.40;
p=DrawBackground(limiterRadius);


% [X,Y]=PFQuiver(1,2,3,8,9,10,11);
[X,Y]=PFQuiver(11);
%%
isDraw=1;



