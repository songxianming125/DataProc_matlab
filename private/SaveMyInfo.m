function y=SaveMyInfo(MyFile,DasInfo)
fid = fopen(MyFile,'a+');
fwrite(fid,DasInfo.FileType','char');        %10 �ļ�����,�ַ���
fwrite(fid,DasInfo.ChnlId,'int16');         %2  ͨ����(����)
fwrite(fid,DasInfo.ChnlName','char');       %12 ͨ����,�ַ���
fwrite(fid,DasInfo.Addr,'int32');           %4  ���ݵ�ַ(������)
fwrite(fid,DasInfo.Freq,'float32');         %4  ����Ƶ��(������)
fwrite(fid,DasInfo.Len,'int32');            %4  ���ݳ���(������)
fwrite(fid,DasInfo.Post,'int32');           %4  �����󳤶�(������)
fwrite(fid,DasInfo.MaxDat,'int16');         %2  ������ʱ��A/Dת��(����)
fwrite(fid,DasInfo.LowRang,'float32');      %4  ��������(������)
fwrite(fid,DasInfo.HighRang,'float32');     %4  ��������(������)
fwrite(fid,DasInfo.Factor,'float32');       %4  ϵ������(������)
fwrite(fid,DasInfo.Offset,'float32');       %4  �ź�ƫ����(������)
fwrite(fid,DasInfo.Unit','char');           %8  ��������λ,�ַ���
fwrite(fid,DasInfo.Dly,'float32');          %4  �ӳ�(������)
fwrite(fid,DasInfo.AttribDt,'int16');       %2  ��������(����)
fwrite(fid,DasInfo.DatWth,'int16');         %2  ���ݿ��(����)
                                            %Sum=74
                                            %sparing for later use
fwrite(fid,DasInfo.SparI1,'int16');         %2  �����ֶ�1 ���� (����)
fwrite(fid,DasInfo.SparI2,'int16');         %2  �����ֶ�2 ���� (����)
fwrite(fid,DasInfo.SparI3,'int16');         %2  �����ֶ�3 ���� (����)
fwrite(fid,DasInfo.SparF1,'float32');       %4  �����ֶ�1 ���� (������)
fwrite(fid,DasInfo.SparF2,'float32');       %4  �����ֶ�2 ���� (������)
fwrite(fid,DasInfo.SparC1','char');         %8  �����ֶ�1 ���� (�ַ���)
fwrite(fid,DasInfo.SparC2','char');         %16 �����ֶ�2 ���� (�ַ���)
fwrite(fid,DasInfo.SparC3','char');         %10 �����ֶ�3 ���� (�ַ���)
status = fclose(fid);
                                            %Total  Sum=122
y=DasInfo;
