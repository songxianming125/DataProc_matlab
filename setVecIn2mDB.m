function setVecIn2mDB(UD)
% developed by Dr SONG Xianming in 2020/11/10
% for curves with the same time window

U=UD.U; % unit V
I=UD.I;


t=UD.t; % in ms
indexTimeV=1:length(t);

iPFnamelist=UD.iChannels;
uPFnamelist=UD.uChannels;


%file build
%define local driver and server
myDriver='C:\das';

sShotNum=UD.MyShot;
sShotNum=strcat('00000',sShotNum);
sShotNum=sShotNum(end-4:end);%stem of shotnumber for filename
CurrentShot=str2num(sShotNum);


myDir = GetDir(CurrentShot); %Folder for the shot
myDriver=[myDriver filesep myDir];




%vec file
myPathInf=fullfile(myDriver,'inf');
if ~exist(myPathInf,'dir')
    mkdir(myPathInf);
end
myPathData=strrep(myPathInf,'inf','data');
if ~exist(myPathData,'dir')
    mkdir(myPathData);
end


myFileInf=strcat(sShotNum,'vec.inf');
myFileInf=fullfile(myPathInf,myFileInf);

if UD.saveInterruptive
    [FileName,PathName,FilterIndex]=uiputfile('*.inf','Save the DAS file!',myFileInf);
    MyInfFile=lower(strcat(PathName,FileName));
else
    MyInfFile=myFileInf;
end

str = strrep(MyInfFile,'\inf\','\data\');
MyDataFile=strrep(str,'.inf','.dat');




if exist(MyDataFile,'file')
    delete(MyDataFile);
end

if exist(MyInfFile,'file')
    delete(MyInfFile);  %delete the old one for save new one
end


istep=1;%1 s  very important step control period
[ChnlNames,ChnlNums,Units]=SetVECChnlNameNum2M;
VECInfo=SetVECInfo;
VECInfo.DataAddress=0; %As Integer                '2  数据地址，采用C语言规范，第一个数的位置是 0。

maxNodePoints=UD.numNodeInWaveform;
if length(iPFnamelist)>=1
    for i=1:length(iPFnamelist)
        
        num=4;
        indexInflection=getInflexionIndex(t,I(:,i),maxNodePoints,num);
        %     x=t(indexTime);
        %     y=I(indexTime,i);
        %% use the Ip nodes to interpolation
        % indexInflection=[];
        %% should have the first and last point
        if indexInflection(1)>1
            indexInflection=[1 indexInflection];
        end
        
        if indexInflection(end)< length(t)% should have the first and last point
            indexInflection=[indexInflection length(t)];
        end
        
        x=t(indexInflection)/1000;  %ms->s
        y=I(indexInflection,i);
        
        
        
        myName=iPFnamelist{i};
        VECInfo.ChannelName=myName;  %As Byte       '2 通道名,字符串
        
        index=strmatch(myName, ChnlNames, 'exact');
        myNum=ChnlNums(index);
        
        VECInfo.ChannelNumber=myNum; %As Integer           '2  通道号 1=OH,2=VF,3=RF,4=E1,5=E2,6=E3,7=E4,8=IP,...21=LH
        VECInfo.DataLength=length(x); %As Integer                 '2  数据长度 代表节点个数，即（XY）坐标对数。
        VECInfo.DataType=2; %As Integer                '2  类型，1=2 bytes integer  2=4 bytes single
        %VECInfo.DataAddress=VECInfo.DataAddress; %As Integer                '2  数据地址，采用C语言规范，第一个数的位置是 0。
        
        VECInfo.XSumCheck=sum(x); %As Single             '4 代表该通道所有X值求和。用于验证数据的正确性。
        VECInfo.YSumCheck=sum(y); %As Single             '4 代表该通道所有Y值求和。用于验证数据的正确性。
        
        VECInfo.Frequency=1/istep; %  Hz, As Single             '4 代表 步长的倒数。   1/f
        
        %if i==24
        %   jjj=1;
        %end
        myUnit=Units{index};%songxm change cell to char
        myUnit=myUnit(1:2);
        VECInfo.YUnit=myUnit;  %As Byte 2          'Y 轴代表的物理量的单位。
        %                 Total  Sum=24
        s=SaveMyVECInfo(MyInfFile,VECInfo);
        VECInfo.DataAddress=VECInfo.DataAddress+VECInfo.DataLength* VECInfo.DataType*4; %As Integer                '2  数据地址，采用C语言规范，第一个数的位置是 0。
        myData=[];
        myData(1,:)=x;
        myData(2,:)=y;
        s=SaveMyVECData(MyDataFile,myData);
    end
end
%    maxNodePoints=UD.numNodeInWaveform;
if length(uPFnamelist)>=1
    for i=1:length(uPFnamelist)
        
        %% find the inflexion point
        
        num=2;
        indexInflection=getInflexionIndex(t,U(:,i),maxNodePoints,num);
        %     indexInflection=[];
        
        
        if indexInflection(1)>1 % should have the first and last point
            indexInflection=[1 indexInflection];
        end
        
        if indexInflection(end)< length(t)% should have the first and last point
            indexInflection=[indexInflection length(t)];
        end
        x=t(indexInflection)/1000; % ms
        y=U(indexInflection,i);
        
        %% Head and Tail for PS
        % time is second
        tDelay=20/1000; % ms-s
        tReady=1/1000; % ms-s
        uVersion=100; %V
        noVersion=0; %V
        if UD.isIM
            x=[x(1)-tDelay x(1)-tReady x' x(end)+tReady x(end)+tDelay];
            if sum(abs(y))>1
                y=[-uVersion -uVersion y' uVersion uVersion]; %   + - or both positive and negative PS
            else
                y=[-noVersion -noVersion y' noVersion noVersion]; % for both positive and negative PS
            end
            % inversion for keep the current zero
        else
            x=[x(1)-tDelay x(1)-tReady x' x(end)+tReady x(end)+tDelay];
            if sum(abs(y))>1
                y=[uVersion uVersion y' uVersion uVersion];  % for negative PS
            else
                y=[noVersion noVersion y' noVersion noVersion];  % for negative PS
            end
            % inversion for keep the current zero
        end
        %%
        
        
        myName=uPFnamelist{i};
        VECInfo.ChannelName=myName;  %As Byte       '2 通道名,字符串
        
        index=strmatch(myName, ChnlNames, 'exact');
        myNum=ChnlNums(index);
        
        VECInfo.ChannelNumber=myNum; %As Integer           '2  通道号 1=OH,2=VF,3=RF,4=E1,5=E2,6=E3,7=E4,8=IP,...21=LH
        VECInfo.DataLength=length(x); %As Integer                 '2  数据长度 代表节点个数，即（XY）坐标对数。
        VECInfo.DataType=2; %As Integer                '2  类型，1=2 bytes integer  2=4 bytes single
        %VECInfo.DataAddress=VECInfo.DataAddress; %As Integer                '2  数据地址，采用C语言规范，第一个数的位置是 0。
        
        VECInfo.XSumCheck=sum(x); %As Single             '4 代表该通道所有X值求和。用于验证数据的正确性。
        VECInfo.YSumCheck=sum(y); %As Single             '4 代表该通道所有Y值求和。用于验证数据的正确性。
        
        VECInfo.Frequency=1/istep; % Hz, As Single             '4 代表 步长的倒数。   1/f
        
        %if i==24
        %   jjj=1;
        %end
        myUnit=Units{index};%songxm change cell to char
        myUnit=myUnit(1:2);
        VECInfo.YUnit=myUnit;  %As Byte 2          'Y 轴代表的物理量的单位。
        %                 Total  Sum=24
        s=SaveMyVECInfo(MyInfFile,VECInfo);
        VECInfo.DataAddress=VECInfo.DataAddress+VECInfo.DataLength* VECInfo.DataType*4; %As Integer                '2  数据地址，采用C语言规范，第一个数的位置是 0。
        myData=[];
        myData(1,:)=x;
        myData(2,:)=y;
        s=SaveMyVECData(MyDataFile,myData);
    end
end

%% upload to HL-2M database
% return

if 0 % ~strfind(FileName,UD.ext)
else
    [user, psw]=get2mPSW;
    % mw=ftp('www.swip.ac.cn',user,psw);
    
    sxDriver='192.168.20.11';
    try
        ccs=ftp(sxDriver,user,psw);
    catch err
        msgbox(['hl is not available!' err.identifier])
        return
    end
    % come to the 2mdas folder
    cd(ccs,'..\2MDAS');
    
    dirStruct=dir(ccs);
    myDir = GetDir(CurrentShot); %Folder for the shot
    
    %% preparing the folder, if not exist, make it
    TF=isFTP_FolderExist(dirStruct,myDir);
    subFolders={'DATA','INF','DPF','TCN'};
    
    if TF
        cd(ccs,myDir);
        for i=1:length(subFolders)
            dirStruct=dir(ccs);
            subFolder =subFolders{i};
            subTF=isFTP_FolderExist(dirStruct,subFolder);
            if subTF
            else
                mkdir(ccs,subFolder);  %make subFolder
            end
        end
    else
        mkdir(ccs,myDir);
        cd(ccs,myDir);
        for i=1:length(subFolders)
            mkdir(ccs,subFolders{i}); %make subFolder
        end
    end
    
    
    cd(ccs,'INF');
    mput(ccs,MyInfFile);
    cd(ccs,['..' filesep 'DATA']);
    mput(ccs,MyDataFile);
    close(ccs)
    
end
return
