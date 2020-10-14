function InfFileName = getInfFileName(CurrentShot,CurrentSysName)
    global  newServer oldServer
    sxDriver=newServer;
    if exist(sxDriver,'dir')~=7
        sxDriver=getDriver;
    end

    sShot=num2str(CurrentShot);
    L=length(sShot);
    if L<5
        strZeros='00000';
        sShot=[strZeros(1:(5-L)) sShot];
    end
    myFile=strcat(sShot,CurrentSysName,'.INF'); %linux
    
    myDir = GetDir(CurrentShot);
    InfFileName=fullfile(newServer,myDir,'inf',myFile);
    
    if ~exist(InfFileName,'file')
        InfFileName=fullfile(oldServer,myDir,'inf',myFile);
    end
    
end