dlg_title = 'Input shot number';
prompt = {'Input shot number'};
def   = {'20011'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
myShot=str2num(answer{1});
subFolders={'DATA','INF','DPF','TCN'};

root='D:';
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
        mkdir(ccs,subFolders{i}); %make subFolder
    end
end




return
dlg_title = 'Input shot number';
prompt = {'Input shot number'};
def   = {'20011'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);

myShot=str2num(answer{1});








% [user, psw]=getPSW;
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
myDir = GetDir(myShot); %Folder for the shot

%% preparing the folder, if not exist, make it
TF=isFTP_FolderExist(dirStruct,myDir);
subFolders={'DATA','INF','DPF','TCN'};

if TF
    cd(ccs,myDir)
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
    cd(ccs,myDir)
    for i=1:length(subFolders)
        mkdir(ccs,subFolders{i}); %make subFolder
    end
end
%% get File
% mget(mw,c(1).name,'D:\')
%% put File
cd(ccs,'DPF')
mput(ccs,'D:\10000\DPF\*.xml')

return

