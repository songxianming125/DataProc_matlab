function y=SaveMyInfo(MyFile,DasInfo)
fid = fopen(MyFile,'a+');
fwrite(fid,DasInfo.FileType','char');        %10 文件类型,字符串
fwrite(fid,DasInfo.ChnlId,'int16');         %2  通道号(整型)
fwrite(fid,DasInfo.ChnlName','char');       %12 通道名,字符串
fwrite(fid,DasInfo.Addr,'int32');           %4  数据地址(长整型)
fwrite(fid,DasInfo.Freq,'float32');         %4  采数频率(单精度)
fwrite(fid,DasInfo.Len,'int32');            %4  数据长度(长整型)
fwrite(fid,DasInfo.Post,'int32');           %4  触发后长度(长整型)
fwrite(fid,DasInfo.MaxDat,'int16');         %2  满量程时的A/D转换(整型)
fwrite(fid,DasInfo.LowRang,'float32');      %4  量程下限(单精度)
fwrite(fid,DasInfo.HighRang,'float32');     %4  量程上限(单精度)
fwrite(fid,DasInfo.Factor,'float32');       %4  系数因子(单精度)
fwrite(fid,DasInfo.Offset,'float32');       %4  信号偏移量(单精度)
fwrite(fid,DasInfo.Unit','char');           %8  物理量单位,字符串
fwrite(fid,DasInfo.Dly,'float32');          %4  延迟(单精度)
fwrite(fid,DasInfo.AttribDt,'int16');       %2  数据属性(整型)
fwrite(fid,DasInfo.DatWth,'int16');         %2  数据宽度(整型)
                                            %Sum=74
                                            %sparing for later use
fwrite(fid,DasInfo.SparI1,'int16');         %2  备用字段1 数字 (整型)
fwrite(fid,DasInfo.SparI2,'int16');         %2  备用字段2 数字 (整型)
fwrite(fid,DasInfo.SparI3,'int16');         %2  备用字段3 数字 (整型)
fwrite(fid,DasInfo.SparF1,'float32');       %4  备用字段1 数字 (单精度)
fwrite(fid,DasInfo.SparF2,'float32');       %4  备用字段2 数字 (单精度)
fwrite(fid,DasInfo.SparC1','char');         %8  备用字段1 数字 (字符串)
fwrite(fid,DasInfo.SparC2','char');         %16 备用字段2 数字 (字符串)
fwrite(fid,DasInfo.SparC3','char');         %10 备用字段3 数字 (字符串)
status = fclose(fid);
                                            %Total  Sum=122
y=DasInfo;
