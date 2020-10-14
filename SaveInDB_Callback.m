function SaveInDB_Callback(hObject, eventdata, handles)
global   MyCurves PicDescription
if isempty(MyCurves)
    MyCurves=get(handles.lbCurves,'UserData');
end


cw=cd;
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

%we need shot information
MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end
CurrentShot=str2num(MyShot);

subFolders={'DATA','INF'};
root='c:\das';
myDir = GetDir(CurrentShot); %Folder for the shot
myDir=[root filesep myDir];


if exist(myDir,'dir')==7
    for i=1:length(subFolders)
        subFolder =[myDir filesep subFolders{i}];
        if exist(subFolder,'dir')==7
        else
            mkdir(subFolder);  %make subFolder
        end
    end
else
    mkdir(myDir);
    for i=1:length(subFolders)
        subFolder =[myDir filesep subFolders{i}];
        mkdir(subFolders{i}); %make subFolder
    end
end





dataFile=[myDir filesep,'INF',filesep,MyShot,'sim.inf'];
[FileName,PathName,FilterIndex]=uiputfile('*.inf','Save the DAS file!',dataFile);

CurrentInfoFile=lower(strcat(PathName,FileName));
str = strrep(CurrentInfoFile,'\inf\','\data\');
CurrentDataFile=strrep(str,'.inf','.dat');
if exist(CurrentInfoFile,'file') && exist(CurrentDataFile,'file')
    delete(CurrentInfoFile)
    delete(CurrentDataFile)
    currentAddress=int32(0);
else
    currentAddress=int32(0);
end
% MyCurves=get(handles.lbCurves,'UserData');%
[m,n]=size(MyCurves);
if n>0
    DasInfo(n)=SetMyInfo;
    for i=1:n
        DasInfo(i)=SetMyInfo;
        t=[];
        x=[];
        y=[];
        z=[];
        
        
        myVar=strtok(MyCurves(i).ChnlName,'%');
        myVar=deblank((myVar));

%         myVar=strtok(MyCurves(i).ChnlName,'%');
%         myVar=strrep(myVar,'-','');
%         myVar=strrep(myVar,'#','');
%         myVar=strrep(myVar,'+','');
%         myVar=strrep(myVar,'*','');
%         myVar=strrep(myVar,'/','');
%         myVar=strrep(myVar,'\','');
%         myVar=strrep(myVar,'@','c');
%         
        
        
        %         myVar=genvarname(myVar,who);
        
        
        %  signal modify
        
        if isempty(PicDescription)
            t=MyCurves(i).x;
            z=MyCurves(i).y;
        else
            t=MyCurves(i).x+PicDescription(i).XOffset;
            z=PicDescription(i).Factor*MyCurves(i).y+PicDescription(i).YOffset;
        end
        
        %
        %         x(ii)={MyCurves(index(ii)).x+PicDescription(index(ii)).XOffset};
        %         y(ii)={PicDescription(index(ii)).Factor*MyCurves(index(ii)).y+PicDescription(index(ii)).YOffset};
        %
        
        %% for modify
%         t=t+1;
        
        t0=find(t>=T0,1);
        t1=find(t<=T1,1, 'last');
        x=t(t0:t1);
        CurrentLength=t1-t0+1;
        
        if CurrentLength<1
            break
        end
        y=z(t0:t1);
        
        DasInfo(i).FileType='swip_das01';        %10 
        myVar = changeChnlName(myVar);
        ChnlId=getId4Name(myVar);
        if isempty(ChnlId)
            msgbox(['ChnlName=' myVar ' is not valid, Please check!'])
            return
        end
        
     
        DasInfo(i).ChnlId=ChnlId;         %2  
        %mystr=zeros(1,12);
        
        DasInfo(i).ChnlName(1:length(myVar))=myVar;       %12 
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
        Unit=MyCurves(i).Unit;
        if iscell(Unit)
            Unit=Unit{1};
            DasInfo(i).Unit(1:length(Unit))=Unit;
        else
            DasInfo(i).Unit(1:length(Unit))=Unit;
        end%8
        
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
        w=SaveMyInfo(CurrentInfoFile,DasInfo(i));
        w=SaveMyData(CurrentDataFile,DasInfo(i),y,'a');
        currentAddress=currentAddress+DasInfo(i).Len*DasInfo(i).DatWth;
    end
end


cd(cw) %return to old path


if ~strfind(FileName,'SIM')
else
    
    
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
    %% get File
    % mget(mw,c(1).name,'D:\')
    %% put File
    
    
    
    cd(ccs,'INF');
    mput(ccs,CurrentInfoFile);
    cd(ccs,['..' filesep 'DATA']);
    mput(ccs,CurrentDataFile);
    
    close(ccs)
    
end
