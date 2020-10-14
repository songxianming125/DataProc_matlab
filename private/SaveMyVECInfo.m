function y=SaveMyVECInfo(MyFiles,VECInfo);
[MyPath, MyFile, ext] = fileparts(MyFiles);
%if not the path then create it
if ~exist(MyPath,'dir')
    mkdir(MyPath)
end



fid = fopen(MyFiles,'a'); % 'a' mean :Open file, or create new file, for writing; append data to the end of the file.
    fwrite(fid,VECInfo.ChannelName','char');         %As Byte       '2 通道名,字符串
    fwrite(fid,VECInfo.ChannelNumber,'int16');       %As Integer           '2  通道号 1=OH,2=VF,3=RF,4=E1,5=E2,6=E3,7=E4,8=IP,...21=LH
    fwrite(fid,VECInfo.DataLength,'int16');       %As Integer                 '2  数据长度 代表节点个数，即（XY）坐标对数。
    fwrite(fid,VECInfo.DataType,'int16');      %As Integer                '2  类型，1=bytes integer  2=4 bytes single
    fwrite(fid,VECInfo.DataAddress,'int16');    %As Integer                '2  数据地址，采用C语言规范，第一个数的位置是 0。
    fwrite(fid,VECInfo.XSumCheck,'float32');         %As Single             '4 代表该通道所有X值求和。用于验证数据的正确性。
    fwrite(fid,VECInfo.YSumCheck,'float32');        %As Single             '4 代表该通道所有Y值求和。用于验证数据的正确性。
    fwrite(fid,VECInfo.Frequency,'float32');        %As Single             '4 代表 步长的倒数。   1/f
    fwrite(fid,VECInfo.YUnit','char');        %As Byte 2          'Y 轴代表的物理量的单位。
            %                 Total  Sum=24
status = fclose(fid);
y=1;
