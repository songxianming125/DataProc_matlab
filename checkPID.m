function checkPID(hObject, eventdata, handles)
newMyPicStruct=View2Struct(handles);
samplingTime=1; %ms





MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end
CurrentShot=str2num(MyShot);


rootDP=p2a;
temp=[rootDP filesep 'temp'];
cd(temp);

% delete('*.*')

dataFile=[temp filesep,MyShot,'PID.inf'];
[FileName,PathName,FilterIndex]=uiputfile('*.inf','Save the DAS file!',dataFile);
CurrentInfoFile=lower(strcat(PathName,FileName));
% str = strrep(CurrentInfoFile,'\inf\','\data\');
CurrentDataFile=strrep(CurrentInfoFile,'.inf','.dat');
currentAddress=int32(0); % first channel data address

if 0
    %input the function name
    dlg_title = 'input your check PID system';
    prompt = {'PF1U=1,PF1L=2...PF5U=9,PF5L=A...PF8U=F,PF8L=G'};
    % def   = {'ep[a-z]?[0-9][0-9]','EPC','EPD','1'};
    def   = {'1'};
    num_lines= 1;
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    
    if isempty(answer)
        disp('no PID system to check')
        return
    end
    channelName=answer{1};
end
%% read the signal
%% CS
if 1
    ii=-1;
    channelName= 'P'; % plasma
    
    
    % goal signal
    SignalName=['ccI' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    % goal
    cmd=['goalSignal=' yName ';'];
    eval(cmd)
    
    % Proportional coef
    SignalName=['ccK' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    cmd=['signal_P=' yName ';'];
    eval(cmd)
    
    % integral Time signal
    SignalName=['ccJ' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    cmd=['signal_J=' yName ';'];
    eval(cmd)
    
    % derivative Time signal
    SignalName=['ccD' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    cmd=['signal_D=' yName ';'];
    eval(cmd)
    
    % experimental or simulation signal
    SignalName=getSignalName(channelName);
    sysName='sim';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    % experiment
    cmd=['expSignal=' yName ';'];
    eval(cmd)
    cmd=['goalSignal_t=' tName ';'];
    eval(cmd)
    
    
    
    
    
    errSignal0=goalSignal-expSignal;
    errSignal1= circshift(errSignal0,1);
    errSignal2=circshift(errSignal1,1);
    
    %% signal conditionning
    signal_J=samplingTime./signal_J;
    signal_J(isinf(signal_J))=0;
    
    
    a0=signal_P.*(1+signal_J+signal_D/samplingTime);
    a1=-signal_P.*(1+2*signal_D/samplingTime);
    a2=signal_P.*(signal_D/samplingTime);
    
    
    dU=errSignal0.*a0+errSignal1.*a1+errSignal2.*a2;
    dSumU=zeros(size(dU));
    
    for i=2:length(dU)
        %     dSumU(i)=sum(dU(1:i));
        dSumU(i)=dSumU(i-1)+dU(i);
    end
    
    
    
    %
    % iPF=[goalSignal expSignal errSignal0 dU dSumU];
    % Names={'goalSingal','expSignal','errSignal','dU','dSumU'};
    % Units={'kA','kA','kA','V','V'};
    % s = putIntoDP(goalSignal_t,iPF,Names,Units);
    
    
    
    
    Names={['dI' channelName],['dU' 'I' channelName],['dSumU' 'I' channelName]};
    iPF=[errSignal0 dU dSumU];
    Units={'kA','V','V'};
    %     Names={['dI' channelName],['dU' channelName],['dSumU' channelName],['t1dI' channelName],['t2dI' channelName]};
    %     iPF=[errSignal0 dU dSumU errSignal1 errSignal2];
    %     Units={'kA','V','V','kA','kA'};
    for i=1:length(Names)
        cmd=[Names{i} '_t=' tName ';'];  %tName is experiment
        eval(cmd)
        cmd=[Names{i} '_y=iPF(:,i);'];  %tName is experiment
        eval(cmd)
    end
    
    
    
    
    if 0
        s = putIntoDP(goalSignal_t,iPF,Names,Units);
    end
    
    
    sT0=get(handles.xLeft,'String');
    if iscell(sT0)
        T0=str2num(sT0{get(handles.xLeft,'Value')});
    else
        T0=str2num(sT0);
    end
    
    
    sT1=get(handles.xRight,'String');
    if iscell(sT1)
        T1=str2num(sT1{get(handles.xRight,'Value')});
    else
        T1=str2num(sT1);
    end
    
    
    
    
%     Channels={['ccI' channelName] ['ccK' channelName] ['ccJ' channelName] ['ccD' channelName] getSignalName(channelName) ['dI' channelName] ['dU' channelName] ['dSumU' channelName]};
    Channels={['ccI' channelName] ['ccK' channelName] ['ccJ' channelName] ['ccD' channelName] getSignalName(channelName) Names{:}};
    Units={'kA' 'au' 'au' 'au'  'kA' 'kA' 'V' 'V'};
    
    %     Channels={['ccI' channelName] ['ccK' channelName] ['ccJ' channelName] ['ccD' channelName] getSignalName(channelName) ['dI' channelName] ['dU' channelName] ['dSumU' channelName] ['t1dI' channelName] ['t2dI' channelName]};
    %     Units={'kA' 'au' 'au' 'au'  'kA' 'kA' 'V' 'V' 'kA' 'kA'};
    
    
    
    n=length(Channels);
    DasInfo(n)=SetMyInfo;
    
    for i=1:n
        DasInfo(i)=SetMyInfo;
        cmd=['t=' Channels{i} '_t;'];
        eval(cmd)
        cmd=['z=' Channels{i} '_y;'];
        eval(cmd)
        myVar=Channels{i};
        
        
        t0=find(t>=T0,1);
        t1=find(t<=T1,1, 'last');
        x=t(t0:t1);
        CurrentLength=t1-t0+1;
        
        if CurrentLength<1
            break
        end
        y=z(t0:t1);
        
        DasInfo(i).FileType='swip_das01';        %10 
        %         ChnlId=90000+str2num(channelName);
        ChnlId=90000+ii*10+i;
        
        
        DasInfo(i).ChnlId=ChnlId;         %2  
        %mystr=zeros(1,12);
        
        DasInfo(i).ChnlName(1:length(myVar)+1)=['p' myVar];       %12 
        DasInfo(i).Addr=int32(currentAddress);           %4  
        DasInfo(i).Freq=single(1000*(CurrentLength-1)/(t(t1)-t(t0)));     %4
        DasInfo(i).Len=int32(CurrentLength);            %4
        
        
        if t(t0)>=0
            DasInfo(i).Dly=t(t0);          %4  
            DasInfo(i).Post=DasInfo(i).Len;           %4
        else
            DasInfo(i).Dly=0;
            % iStep=(CurrentLength-1)/(t(t1)-t(t0))  
            DasInfo(i).Post=int32(t(t1)*(CurrentLength-1)/(t(t1)-t(t0)))+1;           %4  
        end
        
        DasInfo(i).MaxDat=0;         %2  
        DasInfo(i).LowRang=0;      %4  
        DasInfo(i).HighRang=0;     %4  
        DasInfo(i).Factor=1;       %4  
        DasInfo(i).Offset=0;       %4  
        Unit=Units{i};
        DasInfo(i).Unit(1:length(Unit))=Unit;
        DasInfo(i).AttribDt=int16(3);       %2  
        DasInfo(i).DatWth=int32(4);         %2  
        %Sum=74
        %sparing for later use
        %DasInfo(i).SparI1=0;         %2  
        %DasInfo(i).SparI2=0;         %2  
        %DasInfo(i).SparI3=0;         %2  
        %DasInfo(i).SparF1=0;       %4  
        %DasInfo(i).SparF2=0;       %4  
        %mystr=zeros(1,8);
        %DasInfo(i).SparC1=char(mystr);         %8  
        %DasInfo(i).SparC2='Developed by SXM';         %16 
        %mystr=zeros(1,10);
        %DasInfo(i).SparC3=char(mystr);         %10 3 
        %Total  Sum=122
        %begin to save das
        w=SaveMyInfo(CurrentInfoFile,DasInfo(i));  % save method a+
        w=SaveMyData(CurrentDataFile,DasInfo(i),y,'a');
        currentAddress=currentAddress+DasInfo(i).Len*DasInfo(i).DatWth;
    end
    ii=0;
    
    channelName1= '0';
    channelName= 'P';
    
    % goal signal
    SignalName=['ccI' channelName1];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    % goal
    cmd=['goalSignal=' yName ';'];
    eval(cmd)
    
    % Proportional coef
    
    % use P instead of 0  (CS)
    SignalName=['ccK' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    cmd=['signal_P=' yName ';'];
    eval(cmd)
    
    % integral Time signal
    SignalName=['ccJ' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    cmd=['signal_J=' yName ';'];
    eval(cmd)
    
    % derivative Time signal
    SignalName=['ccD' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    cmd=['signal_D=' yName ';'];
    eval(cmd)
    
    % experimental or simulation signal
    SignalName=getSignalName(channelName1);
    sysName='sim';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    % experiment
    cmd=['expSignal=' yName ';'];
    eval(cmd)
    cmd=['goalSignal_t=' tName ';'];
    eval(cmd)
    
    
    
    
    
    errSignal0=goalSignal-expSignal;
    errSignal1= circshift(errSignal0,1);
    errSignal2=circshift(errSignal1,1);
    
    %% signal conditionning
    signal_J=samplingTime./signal_J;
    signal_J(isinf(signal_J))=0;
    
    
    a0=signal_P.*(1+signal_J+signal_D/samplingTime);
    a1=-signal_P.*(1+2*signal_D/samplingTime);
    a2=signal_P.*(signal_D/samplingTime);
    
    
    dU=errSignal0.*a0+errSignal1.*a1+errSignal2.*a2;
    dSumU=zeros(size(dU));
    
    for i=2:length(dU)
        %     dSumU(i)=sum(dU(1:i));
        dSumU(i)=dSumU(i-1)+dU(i);
    end
    
    
    
    %
    % iPF=[goalSignal expSignal errSignal0 dU dSumU];
    % Names={'goalSingal','expSignal','errSignal','dU','dSumU'};
    % Units={'kA','kA','kA','V','V'};
    % s = putIntoDP(goalSignal_t,iPF,Names,Units);
    
    
    
    
    Names={['dI' channelName1],['dU' channelName1],['dSumU' channelName1]};
    iPF=[errSignal0 dU dSumU];
    Units={'kA','V','V'};
    %     Names={['dI' channelName],['dU' channelName],['dSumU' channelName],['t1dI' channelName],['t2dI' channelName]};
    %     iPF=[errSignal0 dU dSumU errSignal1 errSignal2];
    %     Units={'kA','V','V','kA','kA'};
    for i=1:length(Names)
        cmd=[Names{i} '_t=' tName ';'];  %tName is experiment
        eval(cmd)
        cmd=[Names{i} '_y=iPF(:,i);'];  %tName is experiment
        eval(cmd)
    end
    
    
    
    
    if 0
        s = putIntoDP(goalSignal_t,iPF,Names,Units);
    end
    
    
    sT0=get(handles.xLeft,'String');
    if iscell(sT0)
        T0=str2num(sT0{get(handles.xLeft,'Value')});
    else
        T0=str2num(sT0);
    end
    
    
    sT1=get(handles.xRight,'String');
    if iscell(sT1)
        T1=str2num(sT1{get(handles.xRight,'Value')});
    else
        T1=str2num(sT1);
    end
    
    
    
    
    Channels={['ccI' channelName1] ['ccK' channelName] ['ccJ' channelName] ['ccD' channelName] getSignalName(channelName1) ['dI' channelName1] ['dU' channelName1] ['dSumU' channelName1]};
    Units={'kA' 'au' 'au' 'au'  'kA' 'kA' 'V' 'V'};
    
    %     Channels={['ccI' channelName] ['ccK' channelName] ['ccJ' channelName] ['ccD' channelName] getSignalName(channelName) ['dI' channelName] ['dU' channelName] ['dSumU' channelName] ['t1dI' channelName] ['t2dI' channelName]};
    %     Units={'kA' 'au' 'au' 'au'  'kA' 'kA' 'V' 'V' 'kA' 'kA'};
    
    
    
    n=length(Channels);
    DasInfo(n)=SetMyInfo;
    
    for i=1:n
        DasInfo(i)=SetMyInfo;
        cmd=['t=' Channels{i} '_t;'];
        eval(cmd)
        cmd=['z=' Channels{i} '_y;'];
        eval(cmd)
        myVar=Channels{i};
        
        
        t0=find(t>=T0,1);
        t1=find(t<=T1,1, 'last');
        x=t(t0:t1);
        CurrentLength=t1-t0+1;
        
        if CurrentLength<1
            break
        end
        y=z(t0:t1);
        
        DasInfo(i).FileType='swip_das01';        %10 
        %         ChnlId=90000+str2num(channelName);
        ChnlId=90000+ii*10+i;
        
        
        DasInfo(i).ChnlId=ChnlId;         %2  
        %mystr=zeros(1,12);
        
        DasInfo(i).ChnlName(1:1+length(myVar))=['p' myVar];       %12 
        DasInfo(i).Addr=int32(currentAddress);           %4  
        DasInfo(i).Freq=single(1000*(CurrentLength-1)/(t(t1)-t(t0)));     %4
        DasInfo(i).Len=int32(CurrentLength);            %4
        
        
        if t(t0)>=0
            DasInfo(i).Dly=t(t0);          %4  
            DasInfo(i).Post=DasInfo(i).Len;           %4
        else
            DasInfo(i).Dly=0;
            % iStep=(CurrentLength-1)/(t(t1)-t(t0))  
            DasInfo(i).Post=int32(t(t1)*(CurrentLength-1)/(t(t1)-t(t0)))+1;           %4  
        end
        
        DasInfo(i).MaxDat=0;         %2  
        DasInfo(i).LowRang=0;      %4  
        DasInfo(i).HighRang=0;     %4  
        DasInfo(i).Factor=1;       %4  
        DasInfo(i).Offset=0;       %4  
        Unit=Units{i};
        DasInfo(i).Unit(1:length(Unit))=Unit;
        DasInfo(i).AttribDt=int16(3);       %2  
        DasInfo(i).DatWth=int32(4);         %2  
        %Sum=74
        %sparing for later use
        %DasInfo(i).SparI1=0;         %2  
        %DasInfo(i).SparI2=0;         %2  
        %DasInfo(i).SparI3=0;         %2  
        %DasInfo(i).SparF1=0;       %4  
        %DasInfo(i).SparF2=0;       %4  
        %mystr=zeros(1,8);
        %DasInfo(i).SparC1=char(mystr);         %8  
        %DasInfo(i).SparC2='Developed by SXM';         %16 
        %mystr=zeros(1,10);
        %DasInfo(i).SparC3=char(mystr);         %10 3 
        %Total  Sum=122
        %begin to save das
        w=SaveMyInfo(CurrentInfoFile,DasInfo(i));  % save method a+
        w=SaveMyData(CurrentDataFile,DasInfo(i),y,'a');
        currentAddress=currentAddress+DasInfo(i).Len*DasInfo(i).DatWth;
    end
    
    
end
%%

for ii=1:16
    if ii<10
        channelName=num2str(ii);
    else
        if ii<16
            channelName= dec2hex(ii);
        elseif ii==16
            channelName= 'G';
        end
    end
    
    % goal signal
    SignalName=['ccI' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    % goal
    cmd=['goalSignal=' yName ';'];
    eval(cmd)
    
    % Proportional coef
    SignalName=['ccK' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    cmd=['signal_P=' yName ';'];
    eval(cmd)
    
    % integral Time signal
    SignalName=['ccJ' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    cmd=['signal_J=' yName ';'];
    eval(cmd)
    
    % derivative Time signal
    SignalName=['ccD' channelName];
    sysName='ccs';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    cmd=['signal_D=' yName ';'];
    eval(cmd)
    
    % experimental or simulation signal
    SignalName=getSignalName(channelName);
    sysName='sim';
    yName=[SignalName '_y'];
    tName=[SignalName '_t'];
    cmd=['[' yName ',' tName ']=hl2adb(CurrentShot,SignalName,' 'sysName);'];
    eval(cmd)
    
    % experiment
    cmd=['expSignal=' yName ';'];
    eval(cmd)
    cmd=['goalSignal_t=' tName ';'];
    eval(cmd)
    
    
    
    
    
    errSignal0=goalSignal-expSignal;
    errSignal1= circshift(errSignal0,1);
    errSignal2=circshift(errSignal1,1);
    
    %% signal conditionning
    signal_J=samplingTime./signal_J;
    signal_J(isinf(signal_J))=0;
    
    
    a0=signal_P.*(1+signal_J+signal_D/samplingTime);
    a1=-signal_P.*(1+2*signal_D/samplingTime);
    a2=signal_P.*(signal_D/samplingTime);
    
    
    dU=errSignal0.*a0+errSignal1.*a1+errSignal2.*a2;
    dSumU=zeros(size(dU));
    
    for i=2:length(dU)
        %     dSumU(i)=sum(dU(1:i));
        dSumU(i)=dSumU(i-1)+dU(i);
    end
    
    
    
    %
    % iPF=[goalSignal expSignal errSignal0 dU dSumU];
    % Names={'goalSingal','expSignal','errSignal','dU','dSumU'};
    % Units={'kA','kA','kA','V','V'};
    % s = putIntoDP(goalSignal_t,iPF,Names,Units);
    
    
    
    
    Names={['dI' channelName],['dU' channelName],['dSumU' channelName]};
    iPF=[errSignal0 dU dSumU];
    Units={'kA','V','V'};
    %     Names={['dI' channelName],['dU' channelName],['dSumU' channelName],['t1dI' channelName],['t2dI' channelName]};
    %     iPF=[errSignal0 dU dSumU errSignal1 errSignal2];
    %     Units={'kA','V','V','kA','kA'};
    for i=1:length(Names)
        cmd=[Names{i} '_t=' tName ';'];  %tName is experiment
        eval(cmd)
        cmd=[Names{i} '_y=iPF(:,i);'];  %tName is experiment
        eval(cmd)
    end
    
    
    
    
    if 0
        s = putIntoDP(goalSignal_t,iPF,Names,Units);
    end
    
    
    sT0=get(handles.xLeft,'String');
    if iscell(sT0)
        T0=str2num(sT0{get(handles.xLeft,'Value')});
    else
        T0=str2num(sT0);
    end
    
    
    sT1=get(handles.xRight,'String');
    if iscell(sT1)
        T1=str2num(sT1{get(handles.xRight,'Value')});
    else
        T1=str2num(sT1);
    end
    
    
    
    
    Channels={['ccI' channelName] ['ccK' channelName] ['ccJ' channelName] ['ccD' channelName] getSignalName(channelName) ['dI' channelName] ['dU' channelName] ['dSumU' channelName]};
    Units={'kA' 'au' 'au' 'au'  'kA' 'kA' 'V' 'V'};
    
    %     Channels={['ccI' channelName] ['ccK' channelName] ['ccJ' channelName] ['ccD' channelName] getSignalName(channelName) ['dI' channelName] ['dU' channelName] ['dSumU' channelName] ['t1dI' channelName] ['t2dI' channelName]};
    %     Units={'kA' 'au' 'au' 'au'  'kA' 'kA' 'V' 'V' 'kA' 'kA'};
    
    
    
    n=length(Channels);
    DasInfo(n)=SetMyInfo;
    
    for i=1:n
        DasInfo(i)=SetMyInfo;
        cmd=['t=' Channels{i} '_t;'];
        eval(cmd)
        cmd=['z=' Channels{i} '_y;'];
        eval(cmd)
        myVar=Channels{i};
        
        
        t0=find(t>=T0,1);
        t1=find(t<=T1,1, 'last');
        x=t(t0:t1);
        CurrentLength=t1-t0+1;
        
        if CurrentLength<1
            break
        end
        y=z(t0:t1);
        
        DasInfo(i).FileType='swip_das01';        %10 
        %         ChnlId=90000+str2num(channelName);
        ChnlId=90000+ii*10+i;
        
        
        DasInfo(i).ChnlId=ChnlId;         %2  
        %mystr=zeros(1,12);
        
        DasInfo(i).ChnlName(1:1+length(myVar))=['p' myVar];       %12 
        DasInfo(i).Addr=int32(currentAddress);           %4  
        DasInfo(i).Freq=single(1000*(CurrentLength-1)/(t(t1)-t(t0)));     %4
        DasInfo(i).Len=int32(CurrentLength);            %4
        
        
        if t(t0)>=0
            DasInfo(i).Dly=t(t0);          %4  
            DasInfo(i).Post=DasInfo(i).Len;           %4
        else
            DasInfo(i).Dly=0;
            % iStep=(CurrentLength-1)/(t(t1)-t(t0))  
            DasInfo(i).Post=int32(t(t1)*(CurrentLength-1)/(t(t1)-t(t0)))+1;           %4  
        end
        
        DasInfo(i).MaxDat=0;         %2  
        DasInfo(i).LowRang=0;      %4  
        DasInfo(i).HighRang=0;     %4  
        DasInfo(i).Factor=1;       %4  
        DasInfo(i).Offset=0;       %4  
        Unit=Units{i};
        DasInfo(i).Unit(1:length(Unit))=Unit;
        DasInfo(i).AttribDt=int16(3);       %2  
        DasInfo(i).DatWth=int32(4);         %2  
        %Sum=74
        %sparing for later use
        %DasInfo(i).SparI1=0;         %2  
        %DasInfo(i).SparI2=0;         %2  
        %DasInfo(i).SparI3=0;         %2  
        %DasInfo(i).SparF1=0;       %4  
        %DasInfo(i).SparF2=0;       %4  
        %mystr=zeros(1,8);
        %DasInfo(i).SparC1=char(mystr);         %8  
        %DasInfo(i).SparC2='Developed by SXM';         %16 
        %mystr=zeros(1,10);
        %DasInfo(i).SparC3=char(mystr);         %10 3 
        %Total  Sum=122
        %begin to save das
        w=SaveMyInfo(CurrentInfoFile,DasInfo(i));  % save method a+
        w=SaveMyData(CurrentDataFile,DasInfo(i),y,'a');
        currentAddress=currentAddress+DasInfo(i).Len*DasInfo(i).DatWth;
    end
    
end



%% ftp
user='acq';
psw='acqget';
% mw=ftp('www.swip.ac.cn',user,psw);

sxDriver='192.168.10.11';
try
    ccs=ftp(sxDriver,user,psw);
catch err
    msgbox(['hl is not available!' err.identifier])
    return
end
% come to the 2mdas folder
cd(ccs,'..\2MDAS');

%% provided folder is ready
myDir = GetDir(CurrentShot); %Folder for the shot
cd(ccs,myDir);
cd(ccs,'INF'); % no practical use but for FOR cycle.
% new shot ready for mput
subFolders={'INF','DATA'};

infoFileName=FileName;
dataFileName=strrep(infoFileName,'.inf','.dat');
putFile={infoFileName,dataFileName};

for i=1:length(subFolders)
    cd(ccs,['..' filesep subFolders{i}]);
    dirStruct=dir(ccs);
    myFile=putFile{i};
    if isFTP_FileExist(dirStruct,myFile)
        delete(ccs,myFile)
    end
    mput(ccs,myFile);
    delete(myFile)
end



function SignalName=getSignalName(channelName)
switch channelName
    case 'P'  % plasma
        SignalName=['sIP'];
    case '0'  % CS
        SignalName=['sICSU'];
    case '1'
        SignalName=['sIPF1U'];
    case '2'
        SignalName=['sIPF1L'];
    case '3'
        SignalName=['sIPF2U'];
    case '4'
        SignalName=['sIPF2L'];
    case '5'
        SignalName=['sIPF3U'];
    case '6'
        SignalName=['sIPF3L'];
    case '7'
        SignalName=['sIPF4U'];
    case '8'
        SignalName=['sIPF4L'];
    case '9'
        SignalName=['sIPF5U'];
    case 'A'
        SignalName=['sIPF5L'];
    case 'B'
        SignalName=['sIPF6U'];
    case 'C'
        SignalName=['sIPF6L'];
    case 'D'
        SignalName=['sIPF7U'];
    case 'E'
        SignalName=['sIPF7L'];
    case 'F'
        SignalName=['sIPF8U'];
    case 'G'
        SignalName=['sIPF8L'];
end
