function TF=isFTP_FolderExist(dirStruct,myDir)
% test if the myDir exist
if isempty(dirStruct)
    TF=false;
else
    Folder={dirStruct(:).name};
    TF=strcmpi(myDir,Folder);
    % TF(1)=true;
    cDir=dirStruct(TF);
    
    
    if length(cDir)>1
        isDir={cDir(:).isdir};
        isDir=cell2mat(isDir);
        cDir=cDir(isDir);
    elseif length(cDir)==1
        isDir=cDir.isdir;
        cDir=cDir(isDir);
    end
    
    if isempty(cDir)
        TF=false;
    else
        TF=true;
    end
end
