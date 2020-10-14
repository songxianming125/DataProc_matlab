function y=SetMyInfoHelp;

y={'10 bytes string'};%10 文件类型,字符串
y(2)={'2 bytes integer'};%2  通道号(整型)
y(3)={'12 bytes string'}; %12 通道名,字符串
y(4)={'4 bytes long'}; %4  数据地址(长整型)
y(5)={'4 bytes float'};        %4  采数频率(单精度)
y(6)={'4 bytes long'};         %4  数据长度(长整型)
y(7)={'4 bytes long'};           %4  触发后长度(长整型)
y(8)={'2 bytes integer'};       %2  满量程时的A/D转换(整型)
y(9)={'4 bytes float'};      %4  量程下限(单精度)
y(10)={'4 bytes float'};;     %4  量程上限(单精度)
y(11)={'4 bytes float'};     %4  系数因子(单精度)
y(12)={'4 bytes float'};      %4  信号偏移量(单精度)
y(13)={'8 bytes string'};  %8  物理量单位,字符串
y(14)={'4 bytes float'};         %4  延迟(单精度)
y(15)={'2 bytes integer'};       %2  数据属性(整型)
y(16)={'2 bytes integer'};     %2  数据宽度(整型)
                                            %Sum=74
                                            %sparing for later use
y(17)={'2 bytes integer'};         %2  备用字段1 数字 (整型)
y(18)={'2 bytes integer'};       %2  备用字段2 数字 (整型)
y(19)={'2 bytes integer'};        %2  备用字段3 数字 (整型)
y(20)={'4 bytes float'};     %4  备用字段1 数字 (单精度)
y(21)={'4 bytes float'};     %4  备用字段2 数字 (单精度)
y(22)={'8 bytes string'};       %8  备用字段1 数字 (字符串)
y(23)={'16 bytes string'};         %16 备用字段2 数字 (字符串)
y(24)={'10 bytes string'};         %10 备用字段3 数字 (字符串)
                                            %Total  Sum=122

