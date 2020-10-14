function DPF=GetDPF(CurrentShot)
DPF=[];
if exist('z:')
    path='z:\backup\dpf\';
%     dpf='z:\dpf\hl2a.dpf';
%make sure the string is 5 digit
myFile=strcat('00000',num2str(CurrentShot));
n=length(myFile);
myFile=myFile(n-4:n);%stem of shotnumber for filename
dpf=[path myFile 'ctl.dpf'];
    
    
    
    
    
    
    fid = fopen(dpf,'r');
    if fid==-1
%         WarningString=strcat('File/',dpf,' does not exist!');%promt the need to update configuration
%         set(handles.lbWarning,'String',WarningString);
        return
    end

    DPF={3};%装置编号
    DPF{length(DPF)+1}=CurrentShot;%放电序号
 

    %  begin read data
    DPF{length(DPF)+1}=fread(fid,1,'int16');
    %   FileType(1 To 4) As Byte  '4 文件类型
    temp=fread(fid,4);
    %   Ver(1 To 4)      As Byte  '4  version number
    DPF{length(DPF)+1}=char(temp');
    temp=fread(fid,4);
    DPF{length(DPF)+1}=char(temp');
    
    temp=fread(fid,444,'int16');
    celltemp=mat2cell(temp',1,ones(1,length(temp)));
    DPF(length(DPF)+1:length(DPF)+length(temp))=celltemp(:);
    %   ShotNum(1 To 6)      As Byte  '6 炮号
    temp=fread(fid,6);
    temp=char(temp');
    temp=strtok(temp,char(0));
    DPF{length(DPF)+1}=temp;
    
    temp=fread(fid,1,'int16');
    DPF{length(DPF)+1}=temp;
    temp=fread(fid,1,'int16');
    DPF{length(DPF)+1}=temp;
    
    temp=fread(fid,1,'uint16');  %iShotNum  As Integer   '整型炮号
    DPF{length(DPF)+1}=temp;
    
    
    temp=fread(fid,36,'int16');
    celltemp=mat2cell(temp',1,ones(1,length(temp)));
    DPF(length(DPF)+1:length(DPF)+length(temp))=celltemp(:);
    
    
   temp=fread(fid,1,'int32');  %lShotNum  As Long   '4 长整型炮号
    DPF{length(DPF)+1}=temp;
    
    temp=fread(fid,19,'int16');
    celltemp=mat2cell(temp',1,ones(1,length(temp)));
    DPF(length(DPF)+1:length(DPF)+length(temp))=celltemp(:);
    
    status = fclose('all');

end
