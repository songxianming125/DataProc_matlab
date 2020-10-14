function y=SaveMyVECInfo(MyFiles,VECInfo);
[MyPath, MyFile, ext] = fileparts(MyFiles);
%if not the path then create it
if ~exist(MyPath,'dir')
    mkdir(MyPath)
end



fid = fopen(MyFiles,'a'); % 'a' mean :Open file, or create new file, for writing; append data to the end of the file.
    fwrite(fid,VECInfo.ChannelName','char');         %As Byte       '2 ͨ����,�ַ���
    fwrite(fid,VECInfo.ChannelNumber,'int16');       %As Integer           '2  ͨ���� 1=OH,2=VF,3=RF,4=E1,5=E2,6=E3,7=E4,8=IP,...21=LH
    fwrite(fid,VECInfo.DataLength,'int16');       %As Integer                 '2  ���ݳ��� ����ڵ����������XY�����������
    fwrite(fid,VECInfo.DataType,'int16');      %As Integer                '2  ���ͣ�1=bytes integer  2=4 bytes single
    fwrite(fid,VECInfo.DataAddress,'int16');    %As Integer                '2  ���ݵ�ַ������C���Թ淶����һ������λ���� 0��
    fwrite(fid,VECInfo.XSumCheck,'float32');         %As Single             '4 �����ͨ������Xֵ��͡�������֤���ݵ���ȷ�ԡ�
    fwrite(fid,VECInfo.YSumCheck,'float32');        %As Single             '4 �����ͨ������Yֵ��͡�������֤���ݵ���ȷ�ԡ�
    fwrite(fid,VECInfo.Frequency,'float32');        %As Single             '4 ���� �����ĵ�����   1/f
    fwrite(fid,VECInfo.YUnit','char');        %As Byte 2          'Y �������������ĵ�λ��
            %                 Total  Sum=24
status = fclose(fid);
y=1;
