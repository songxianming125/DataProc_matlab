function del2Mfile
[user, psw]=getPSW;
defUser='songxm';
defPsw='';
[~,code]=logindlg(defUser,defPsw);

if ~strcmp(psw,code)
  msgbox('You have no power to delete the DB file!')
  return  
end


if 1
    [user, psw]=get2mPSW;
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
end


% input the shot number
dlg_title = 'select the shot number';
prompt = {'input the shot number'};
def   = {'80001'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    ShowWarning(0,'no property change',handles)
    return
end


CurrentShot=str2double(answer{1});
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
dirStruct=dir(ccs);
Files={dirStruct(:).name};
% pattern match
k = strfind(Files, num2str(CurrentShot));
Files=Files(~cellfun(@isempty,k));


if ~isempty(Files)
    Indexs=selectIndexs(Files);
    Files=Files(Indexs);
end

if isempty(Files)
    msgbox('no inf file for this shot!')
end

% input the shot number


for i=1:length(Files)
    CurrentInfoFile=Files{i};
    delete(ccs,CurrentInfoFile);
end
cd(ccs,['..' filesep 'DATA']);

dirStruct=dir(ccs);
Files={dirStruct(:).name};
% pattern match
k = strfind(Files, num2str(CurrentShot));
Files=Files(~cellfun(@isempty,k));

if ~isempty(Files)
    Indexs=selectIndexs(Files);
    Files=Files(Indexs);
end

if isempty(Files)
    msgbox('no data file for this shot!')
end
for i=1:length(Files)
    CurrentDataFile=Files{i};
    delete(ccs,CurrentDataFile);
end

close(ccs)
