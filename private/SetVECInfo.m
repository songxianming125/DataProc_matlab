function y=SetVECInfo
mystr=zeros(1,2);
VECInfo.ChannelName=char(mystr);  %As Byte       '2 通道名,字符串
VECInfo.ChannelNumber=0; %As Integer           '2  通道号 1=OH,2=VF,3=RF,4=E1,5=E2,6=E3,7=E4,8=IP,...21=LH
VECInfo.DataLength=0; %As Integer                 '2  数据长度 代表节点个数，即（XY）坐标对数。
VECInfo.DataType=0; %As Integer                '2  类型，1=bytes integer  2=4 bytes single
VECInfo.DataAddress=0; %As Integer                '2  数据地址，采用C语言规范，第一个数的位置是 0。
VECInfo.XSumCheck=0; %As Single             '4 代表该通道所有X值求和。用于验证数据的正确性。
VECInfo.YSumCheck=0; %As Single             '4 代表该通道所有Y值求和。用于验证数据的正确性。
VECInfo.Frequency=0; %As Single             '4 代表 步长的倒数。   1/f
mystr=zeros(1,2);
VECInfo.YUnit=char(mystr);  %As Byte 2          'Y 轴代表的物理量的单位。
%                 Total  Sum=24
y=VECInfo;
