function TF=isFTP_FileExist(dirStruct,myFile)
% test if the myDir exist
if isempty(dirStruct)
    TF=false;
else
    existFiles={dirStruct(:).name};
    TF=strcmpi(myFile,existFiles);
    % TF(1)=true;
    FileStruct=dirStruct(TF); % get the file attribute
    
    
    if length(FileStruct)>1
        isFile={FileStruct(:).isdir};
        isFile=cell2mat(isFile);
        FileStruct=FileStruct(~isFile); % not dir mean file
    elseif length(FileStruct)==1
        isFile=FileStruct.isdir;
        FileStruct=FileStruct(~isFile); % not dir mean file
    end
    
    if isempty(FileStruct)
        TF=false;
    else
        TF=true;
    end
end
