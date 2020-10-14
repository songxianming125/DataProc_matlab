%读VEC多道信息文件
function [y,n]=GetVECInfoN(st)
y=[];
n=[];
fid = fopen(st,'r');
if fid==-1
    %warnstr=strcat('File/',st,' does not exist!');%promt the need to update configuration
    %warndlg(warnstr)
    return
end

s = dir(st);         %fid = fopen('myfile.dat');
FileSize = s.bytes;             %fseek(fid, 0, 'eof');
if FileSize<24
    return
end
LenInfo=24; %通道信息长度                               %filesize = ftell(fid)
                               %fclose(fid);
ChnlCount=FileSize/LenInfo;

for i=1:ChnlCount
mystr=fread(fid,2);  
VECInfo(i).ChannelName=strcat('#',char(mystr'));  %As Byte       '2 通道名,字符串
VECInfo(i).ChannelNumber=fread(fid,1,'int16');  %As Integer           '2  通道号 1=OH,2=VF,3=RF,4=E1,5=E2,6=E3,7=E4,8=IP,...21=LH
VECInfo(i).DataLength=fread(fid,1,'int16');  %As Integer                 '2  数据长度 代表节点个数，即（XY）坐标对数。
VECInfo(i).DataType=fread(fid,1,'int16');  %As Integer                '2  类型，1=bytes integer  2=4 bytes single
VECInfo(i).DataAddress=fread(fid,1,'int16');  %As Integer                '2  数据地址，采用C语言规范，第一个数的位置是 0。
VECInfo(i).XSumCheck=fread(fid,1,'float32'); %As Single             '4 代表该通道所有X值求和。用于验证数据的正确性。
VECInfo(i).YSumCheck=fread(fid,1,'float32'); %As Single             '4 代表该通道所有Y值求和。用于验证数据的正确性。
VECInfo(i).Frequency=fread(fid,1,'float32'); %As Single             '4 代表 步长的倒数。   1/f
mystr=fread(fid,2);  
VECInfo(i).YUnit=char(mystr');  %As Byte 2          'Y 轴代表的物理量的单位。
%                 Total  Sum=24

end
status = fclose(fid);
y=VECInfo;
n=ChnlCount;
