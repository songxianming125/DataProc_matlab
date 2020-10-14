%��VEC�����Ϣ�ļ�
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
LenInfo=24; %ͨ����Ϣ����                               %filesize = ftell(fid)
                               %fclose(fid);
ChnlCount=FileSize/LenInfo;

for i=1:ChnlCount
mystr=fread(fid,2);  
VECInfo(i).ChannelName=strcat('#',char(mystr'));  %As Byte       '2 ͨ����,�ַ���
VECInfo(i).ChannelNumber=fread(fid,1,'int16');  %As Integer           '2  ͨ���� 1=OH,2=VF,3=RF,4=E1,5=E2,6=E3,7=E4,8=IP,...21=LH
VECInfo(i).DataLength=fread(fid,1,'int16');  %As Integer                 '2  ���ݳ��� ����ڵ����������XY�����������
VECInfo(i).DataType=fread(fid,1,'int16');  %As Integer                '2  ���ͣ�1=bytes integer  2=4 bytes single
VECInfo(i).DataAddress=fread(fid,1,'int16');  %As Integer                '2  ���ݵ�ַ������C���Թ淶����һ������λ���� 0��
VECInfo(i).XSumCheck=fread(fid,1,'float32'); %As Single             '4 �����ͨ������Xֵ��͡�������֤���ݵ���ȷ�ԡ�
VECInfo(i).YSumCheck=fread(fid,1,'float32'); %As Single             '4 �����ͨ������Yֵ��͡�������֤���ݵ���ȷ�ԡ�
VECInfo(i).Frequency=fread(fid,1,'float32'); %As Single             '4 ���� �����ĵ�����   1/f
mystr=fread(fid,2);  
VECInfo(i).YUnit=char(mystr');  %As Byte 2          'Y �������������ĵ�λ��
%                 Total  Sum=24

end
status = fclose(fid);
y=VECInfo;
n=ChnlCount;
