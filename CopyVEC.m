function [varargout] = CopyVEC(hObject, eventdata,handles)
%% local dir 
rootDP=p2a;
temp=[rootDP filesep 'temp'];
cd(temp);


%% ftp
user='acq';
psw='acqget';
% mw=ftp('www.swip.ac.cn',user,psw);

% sxDriver='\\hl';
sxDriver='192.168.10.11';
try
    ccs=ftp(sxDriver,user,psw);
catch err
    msgbox(['hl is not available!' err.identifier])
    return
end

% come to the 2mdas folder
cd(ccs,'..\2MDAS');



subFolders={'INF','DATA','DPF','TCN'};


%% we need shot information
MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end




CurrentInfoFile=[MyShot,'*.inf'];
CurrentDataFile=[MyShot,'*.dat'];
CurrentDPF=[MyShot,'DPF.XML'];
CurrentTCN=[MyShot,'*.XML'];

getFile={CurrentInfoFile,CurrentDataFile,CurrentDPF,CurrentTCN};
%% default plus one
CurrentShot=str2num(MyShot);
myDir = GetDir(CurrentShot); %Folder for the shot
MyShot1=num2str(CurrentShot+1);


%% you can change the target shot number
dlg_title = ['source shot is :' MyShot];
prompt = {[MyShot '->  new shot']};
def   = {MyShot1};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    ShowWarning(0,'no property change',handles)
    return
end
MyShot1=answer{1};
CurrentShot1=str2num(MyShot1);
CurrentInfoFile1=[MyShot1,'*.inf'];
CurrentDataFile1=[MyShot1,'*.dat'];
CurrentDPF1=[MyShot1,'DPF.XML'];
CurrentTCN1=[MyShot1,'*.XML'];



putFile={CurrentInfoFile1,CurrentDataFile1,CurrentDPF1,CurrentTCN1};
dirStructBase=dir(ccs);

%% preparing the folder, if not exist, make it
TF=isFTP_FolderExist(dirStructBase,myDir);

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


cd(ccs,'INF'); % no practical use but for FOR cycle.

%% source file
for i=1:length(subFolders)
    cd(ccs,['..' filesep subFolders{i}]);
    mget(ccs,getFile{i});
end



% cd(ccs,'INF');
% mget(ccs,CurrentInfoFile);
% cd(ccs,['..' filesep 'DATA']);
% mget(ccs,CurrentDataFile);
% cd(ccs,['..' filesep 'DPF']);
% mget(ccs,CurrentDPF);
% cd(ccs,['..' filesep 'TCN']);
% mget(ccs,CurrentDPF);




dir_struct = dir(temp);

%% following line is the copy process
for i=1:length(dir_struct)
    
    name=dir_struct(i).name;
    if ~isempty(strfind(name,MyShot))
        name1=regexprep(name,MyShot,MyShot1);
        movefile(name,name1)
    end
end


%% rename file

%% return to root dir
cd(ccs,'..');
cd(ccs,'..'); % root


myDir1 = GetDir(CurrentShot1); %Folder for the shot

%% preparing the folder, if not exist, make it
TF=isFTP_FolderExist(dirStructBase,myDir1);
% subFolders={'DATA','INF','DPF','TCN'};

if TF
    cd(ccs,myDir1);
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
    mkdir(ccs,myDir1);
    cd(ccs,myDir1);
    for i=1:length(subFolders)
        mkdir(ccs,subFolders{i}); %make subFolder
    end
end


%% get File
% mget(mw,c(1).name,'D:\')
%% put File
cd(ccs,'INF'); % no practical use but for FOR cycle.

% new shot ready for mput
for i=1:length(subFolders)
    cd(ccs,['..' filesep subFolders{i}]);
    mput(ccs,putFile{i});
    delete(putFile{i})
end

% CurrentTCN=[MyShot1,'OUT.XML'];
% mput(ccs,CurrentTCN);




close(ccs)
cd(p2a)