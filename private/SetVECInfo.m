function y=SetVECInfo
mystr=zeros(1,2);
VECInfo.ChannelName=char(mystr);  %As Byte       '2 ͨ����,�ַ���
VECInfo.ChannelNumber=0; %As Integer           '2  ͨ���� 1=OH,2=VF,3=RF,4=E1,5=E2,6=E3,7=E4,8=IP,...21=LH
VECInfo.DataLength=0; %As Integer                 '2  ���ݳ��� ����ڵ����������XY�����������
VECInfo.DataType=0; %As Integer                '2  ���ͣ�1=bytes integer  2=4 bytes single
VECInfo.DataAddress=0; %As Integer                '2  ���ݵ�ַ������C���Թ淶����һ������λ���� 0��
VECInfo.XSumCheck=0; %As Single             '4 �����ͨ������Xֵ��͡�������֤���ݵ���ȷ�ԡ�
VECInfo.YSumCheck=0; %As Single             '4 �����ͨ������Yֵ��͡�������֤���ݵ���ȷ�ԡ�
VECInfo.Frequency=0; %As Single             '4 ���� �����ĵ�����   1/f
mystr=zeros(1,2);
VECInfo.YUnit=char(mystr);  %As Byte 2          'Y �������������ĵ�λ��
%                 Total  Sum=24
y=VECInfo;
