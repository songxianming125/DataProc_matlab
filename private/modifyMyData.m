function y=modifyMyData(MyFile,DasInfo,myData,myAddress)

%y=0 mean wrong, y=1 mean right
y=0;
try

    fid = fopen(MyFile,'r+');  %MyMode= 'w', or 'a'
    %do according to the data type
    status = fseek(fid, myAddress, 'bof');  % locate the address for write data
%     position = ftell(fid);
    if DasInfo.AttribDt == 3 | DasInfo.AttribDt == 4 
        y=fwrite(fid,myData,'float32'); %�Ե����ȸ�����
    elseif DasInfo.AttribDt ==2 | DasInfo.AttribDt == 5    %ֱ��������
         y=fwrite(fid,myData,'int16');  
    %���� Ӧ���޸�    
    elseif (DasInfo.AttribDt == 1) & (DasInfo.DatWth == 2) & (DasInfo.MaxDat == 4095 | DasInfo.MaxDat == 65535) 
        %myData(i) = DasInfo.Factor * (DasInfo.LowRang + (myData) * (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
         y=fwrite(fid,myData,'int16');  
    elseif DasInfo.AttribDt == 1 & DasInfo.DatWth == 1    %And (DasInfo.MaxDat = 255)
        %myData(i) = DasInfo.Factor * (DasInfo.LowRang + (myData) * (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
         y=fwrite(fid,myData,'int8');  
    else
        msgbox('The data attribute, data width or maximum data have not been defined!')
    end
status = fclose(fid);
catch
%y=1;
end