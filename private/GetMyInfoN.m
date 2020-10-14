%读多道信息文件
function [y,n]=GetMyInfoN(st,varargin)
isChnlNameStandard=0;
%try
y=[];
n=[];
fid = fopen(st,'r');
if fid<0
    warnstr=strcat(st,' not found');%promt the need to update configuration
    setappdata(0,'MyErr',warnstr);
    return
end
%   varargin{1} isonlychannelname
if nargin>=2 && ~isempty(varargin{1})
    if  length(varargin{1})==1 && varargin{1}==0
        %read only the ChnlName
        offset=12;
        %     %METHOD ONE
        %     for i=1:ChnlCount
        %         status = fseek(fid, offset, 'bof');
        %         temp=fread(fid,12);
        %         DasInfo(i).ChnlName=char(temp');               %12 通道名,字符串
        %         offset=offset+122;
        %     end

        %METHOD TWO
        status = fseek(fid, offset, 'bof');
        temp=fread(fid,inf,'12*uchar=>uchar',122-12);
        ChnlCount=length(temp)/12;
        MyChanList=(char(reshape(temp,12,ChnlCount)))';
%        MyChanList=regexp(MyChanList,'^\w+','match','once');

        y=mat2cell(MyChanList,ones(1,size(MyChanList,1)),size(MyChanList,2));
        if isChnlNameStandard
            y=regexp(y,'^\w+','match','once');
        end
        y=ChannelsConditionning(y);
        n=ChnlCount;

    elseif length(varargin{1})==1 && varargin{1}>0
        %read only one DASINF
        i=varargin{1};
        n=i;
        status = fseek(fid, 122*(i-1), 'bof');
        temp=fread(fid,10);
        DasInfo(i).FileType=char(temp');          %10 文件类型,字符串
        DasInfo(i).ChnlId=fread(fid,1,'uint16');         %2  通道号(整型)
        temp=fread(fid,12);
        ChnlName=char(temp');               %12 通道名,字符串
        %ChnlName=regexprep(ChnlName,'\W','');        if isChnlNameStandard
        if isChnlNameStandard
            ChnlName=regexp(ChnlName,'^\w+','match','once');
        end
        DasInfo(i).ChnlName=ChnlName;               %12 通道名,字符串
        
        DasInfo(i).Addr=fread(fid,1,'int32');           %4  数据地址(长整型)
        DasInfo(i).Freq=fread(fid,1,'float32');         %4  采数频率(单精度)
        DasInfo(i).Len=fread(fid,1,'int32');            %4  数据长度(长整型)
        DasInfo(i).Post=fread(fid,1,'int32');           %4  触发后长度(长整型)
        DasInfo(i).MaxDat=fread(fid,1,'uint16');         %2  满量程时的A/D转换(整型)
        DasInfo(i).LowRang=fread(fid,1,'float32');      %4  量程下限(单精度)
        DasInfo(i).HighRang=fread(fid,1,'float32');     %4  量程上限(单精度)
        DasInfo(i).Factor=fread(fid,1,'float32');       %4  系数因子(单精度)
        DasInfo(i).Offset=fread(fid,1,'float32');       %4  信号偏移量(单精度)
        temp=fread(fid,8);
        DasInfo(i).Unit=char(temp');                   %8  物理量单位,字符串
        DasInfo(i).Dly=fread(fid,1,'float32');          %4  延迟(单精度)
        DasInfo(i).AttribDt=fread(fid,1,'int16');       %2  数据属性(整型)
        DasInfo(i).DatWth=fread(fid,1,'int16');         %2  数据宽度(整型)
        %Sum=74
        %sparing for later use
        DasInfo(i).SparI1=fread(fid,1,'int16');         %2  备用字段1 数字 (整型)
        DasInfo(i).SparI2=fread(fid,1,'int16');         %2  备用字段2 数字 (整型)
        DasInfo(i).SparI3=fread(fid,1,'int16');         %2  备用字段3 数字 (整型)
        DasInfo(i).SparF1=fread(fid,1,'float32');       %4  备用字段1 数字 (单精度)
        DasInfo(i).SparF2=fread(fid,1,'float32');       %4  备用字段2 数字 (单精度)
        temp=fread(fid,8);
        DasInfo(i).SparC1=char(temp');                 %8  备用字段1 数字 (字符串)
        temp=fread(fid,16);
        DasInfo(i).SparC2=char(temp');                %16 备用字段2 数字 (字符串)
        temp=fread(fid,10);
        DasInfo(i).SparC3=char(temp');                %10 备用字段3 数字 (字符串)
        y=DasInfo;
    elseif length(varargin{1})>1
        %read MANY DASINFS
        n=max(varargin{1}(:));
        DasInfo(1:n)=SetMyInfo;
        for j=1:length(varargin{1})
            i=varargin{1}(j);
            status = fseek(fid, 122*(i-1), 'bof');
            temp=fread(fid,10);
            DasInfo(i).FileType=char(temp');          %10 文件类型,字符串
            DasInfo(i).ChnlId=fread(fid,1,'uint16');         %2  通道号(整型)
            temp=fread(fid,12);
            ChnlName=char(temp');               %12 通道名,字符串
            % ChnlName=regexprep(ChnlName,'\W','');
            if isChnlNameStandard
                ChnlName=regexp(ChnlName,'^\w+','match','once');
            end
            DasInfo(i).ChnlName=ChnlName;               %12 通道名,字符串
            
            
            DasInfo(i).Addr=fread(fid,1,'int32');           %4  数据地址(长整型)
            DasInfo(i).Freq=fread(fid,1,'float32');         %4  采数频率(单精度)
            DasInfo(i).Len=fread(fid,1,'int32');            %4  数据长度(长整型)
            DasInfo(i).Post=fread(fid,1,'int32');           %4  触发后长度(长整型)
            DasInfo(i).MaxDat=fread(fid,1,'uint16');         %2  满量程时的A/D转换(整型)
            DasInfo(i).LowRang=fread(fid,1,'float32');      %4  量程下限(单精度)
            DasInfo(i).HighRang=fread(fid,1,'float32');     %4  量程上限(单精度)
            DasInfo(i).Factor=fread(fid,1,'float32');       %4  系数因子(单精度)
            DasInfo(i).Offset=fread(fid,1,'float32');       %4  信号偏移量(单精度)
            temp=fread(fid,8);
            DasInfo(i).Unit=char(temp');                   %8  物理量单位,字符串
            DasInfo(i).Dly=fread(fid,1,'float32');          %4  延迟(单精度)
            DasInfo(i).AttribDt=fread(fid,1,'int16');       %2  数据属性(整型)
            DasInfo(i).DatWth=fread(fid,1,'int16');         %2  数据宽度(整型)
            %Sum=74
            %sparing for later use
            DasInfo(i).SparI1=fread(fid,1,'int16');         %2  备用字段1 数字 (整型)
            DasInfo(i).SparI2=fread(fid,1,'int16');         %2  备用字段2 数字 (整型)
            DasInfo(i).SparI3=fread(fid,1,'int16');         %2  备用字段3 数字 (整型)
            DasInfo(i).SparF1=fread(fid,1,'float32');       %4  备用字段1 数字 (单精度)
            DasInfo(i).SparF2=fread(fid,1,'float32');       %4  备用字段2 数字 (单精度)
            temp=fread(fid,8);
            DasInfo(i).SparC1=char(temp');                 %8  备用字段1 数字 (字符串)
            temp=fread(fid,16);
            DasInfo(i).SparC2=char(temp');                %16 备用字段2 数字 (字符串)
            temp=fread(fid,10);
            DasInfo(i).SparC3=char(temp');                %10 备用字段3 数字 (字符串)
        end
        y=DasInfo;
    end

else
    %--------------------------------------------------------------------------------------------
    s = dir(st);         %fid = fopen('myfile.dat');
    FileSize = s.bytes;             %fseek(fid, 0, 'eof');
    LenInfo=122; %通道信息长度
    ChnlCount=FileSize/LenInfo;
    DasInfo(1:ChnlCount)=SetMyInfo;
    
    for i=1:ChnlCount
        temp=fread(fid,10);
        DasInfo(i).FileType=char(temp');          %10 文件类型,字符串
        DasInfo(i).ChnlId=fread(fid,1,'uint16');         %2  通道号(整型)
        temp=fread(fid,12);
        ChnlName=char(temp');               %12 通道名,字符串
        if isChnlNameStandard
            ChnlName=regexp(ChnlName,'^\w+','match','once');
        end
        DasInfo(i).ChnlName=ChnlName;               %12 通道名,字符串
        
        DasInfo(i).Addr=fread(fid,1,'int32');           %4  数据地址(长整型)
        DasInfo(i).Freq=fread(fid,1,'float32');         %4  采数频率(单精度)
        DasInfo(i).Len=fread(fid,1,'int32');            %4  数据长度(长整型)
        DasInfo(i).Post=fread(fid,1,'int32');           %4  触发后长度(长整型)
        DasInfo(i).MaxDat=fread(fid,1,'uint16');         %2  满量程时的A/D转换(整型)
        DasInfo(i).LowRang=fread(fid,1,'float32');      %4  量程下限(单精度)
        DasInfo(i).HighRang=fread(fid,1,'float32');     %4  量程上限(单精度)
        DasInfo(i).Factor=fread(fid,1,'float32');       %4  系数因子(单精度)
        DasInfo(i).Offset=fread(fid,1,'float32');       %4  信号偏移量(单精度)
        temp=fread(fid,8);
        DasInfo(i).Unit=char(temp');                   %8  物理量单位,字符串
        DasInfo(i).Dly=fread(fid,1,'float32');          %4  延迟(单精度)
        DasInfo(i).AttribDt=fread(fid,1,'int16');       %2  数据属性(整型)
        DasInfo(i).DatWth=fread(fid,1,'int16');         %2  数据宽度(整型)
        %Sum=74
        %sparing for later use
        DasInfo(i).SparI1=fread(fid,1,'int16');         %2  备用字段1 数字 (整型)
        DasInfo(i).SparI2=fread(fid,1,'int16');         %2  备用字段2 数字 (整型)
        DasInfo(i).SparI3=fread(fid,1,'int16');         %2  备用字段3 数字 (整型)
        DasInfo(i).SparF1=fread(fid,1,'float32');       %4  备用字段1 数字 (单精度)
        DasInfo(i).SparF2=fread(fid,1,'float32');       %4  备用字段2 数字 (单精度)
        temp=fread(fid,8);
        DasInfo(i).SparC1=char(temp');                 %8  备用字段1 数字 (字符串)
        temp=fread(fid,16);
        DasInfo(i).SparC2=char(temp');                %16 备用字段2 数字 (字符串)
        temp=fread(fid,10);
        DasInfo(i).SparC3=char(temp');                %10 备用字段3 数字 (字符串)
        %Total  Sum=122
    end
    y=DasInfo;
    n=ChnlCount;
    
   
    %     %read all DASINFS
%     m = memmapfile(st,  ...
%         'Format', {              ...
%         'uint8' [1 10] 'FileType';   ...%10 文件类型,字符串
%         'uint16' [1 1] 'ChnlId';...%2  通道号(整型)
%         'uint8' [1 12] 'ChnlName';   ... %12 通道名,字符串
%         'int32' [1 1] 'Addr';...%4  数据地址(长整型)
%         'single' [1 1] 'Freq';... %4  采数频率(单精度)
%         'int32' [1 1] 'Len';...%4  数据长度(长整型)
%         'int32' [1 1] 'Post';... %4  触发后长度(长整型)
%         'uint16' [1 1] 'MaxDat';...%2  满量程时的A/D转换(整型)
%         'single' [1 1] 'LowRang';... %4  量程下限(单精度)
%         'single' [1 1] 'HighRang';... %4  量程上限(单精度)
%         'single' [1 1] 'Factor';... %4  系数因子(单精度)
%         'single' [1 1] 'Offset';...%4  信号偏移量(单精度)
%         'uint8' [1 8] 'Unit';   ...%8  物理量单位,字符串
%         'single' [1 1] 'Dly';...4  延迟(单精度)
%         'uint16' [1 1] 'AttribDt';... %2  数据属性(整型)
%         'uint16' [1 1] 'DatWth';... %2  数据宽度(整型)
%         'uint16' [1 1] 'SparI1';... %2  备用字段1 数字 (整型)
%         'uint16' [1 1] 'SparI2';...%2  备用字段2 数字 (整型)
%         'uint16' [1 1] 'SparI3';...%2  备用字段3 数字 (整型)
%         'single' [1 1] 'SparF1';...%4  备用字段1 数字 (单精度)
%         'single' [1 1] 'SparF2';...%4  备用字段2 数字 (单精度)
%         'uint8' [1 8] 'SparC1';   ... %8  备用字段1 数字 (字符串)
%         'uint8' [1 16] 'SparC2';   ... %16 备用字段2 数字 (字符串)
%         'uint8' [1 10] 'SparC3';   ... %10 备用字段3 数字 (字符串)
%         });  %  fields=24   Total Bytes =122
%     y=m.Data;
%     n=length(y);
end
status = fclose(fid);
    
% %catch
% status = fclose('all');
% %end
return




























% 
% %--------------------------------------------------------------------------------------------


% %try
% y=[];
% n=[];
% fid = fopen(st,'r');
% if fid==-1
%     warnstr=strcat('wrong when open the inf File /',st);
%     warnstr={warnstr,'the file may not be found'};%promt the need to update configuration
%     setappdata(0,'MyErr',warnstr);
%     %warnstr=strcat('File/',st,' does not exist!');%promt the need to update configuration
%     %warndlg(warnstr)
%     return
% end
% 
% s = dir(st);         %fid = fopen('myfile.dat');
% FileSize = s.bytes;             %fseek(fid, 0, 'eof');
% if FileSize<122
%     warnstr=strcat('inf File /',st,' have found, but the format may wrong');
%     warnstr={warnstr,'Check the file size for sure'};%promt the need to update configuration
%     setappdata(0,'MyErr',warnstr);
%     status = fclose(fid);
%     return
% end
% LenInfo=122; %通道信息长度
% if strcmpi(st(end-6:end-4),'vec')
%     % msgbox(['This is vec file, not das file'])
%     status = fclose(fid);
%     return
% end
% 
% 
% %filesize = ftell(fid)
% if  mod(FileSize,LenInfo)~=0;
%     msgbox(['information file_' st '_has error'])
%     status = fclose(fid);
%     return
% end
% 



% % %--------------------------------------------------------------------------------------------
% ChnlCount=FileSize/LenInfo;
% DasInfo(1:ChnlCount)=SetMyInfo;
% tic
% for j=1:100
% 
%     for i=1:ChnlCount
%         temp=fread(fid,10);
%         DasInfo(i).FileType=char(temp');          %10 文件类型,字符串
%         DasInfo(i).ChnlId=fread(fid,1,'int16');         %2  通道号(整型)
%         temp=fread(fid,12);
%         DasInfo(i).ChnlName=char(temp');               %12 通道名,字符串
%         DasInfo(i).Addr=fread(fid,1,'int32');           %4  数据地址(长整型)
%         DasInfo(i).Freq=fread(fid,1,'float32');         %4  采数频率(单精度)
%         DasInfo(i).Len=fread(fid,1,'int32');            %4  数据长度(长整型)
%         DasInfo(i).Post=fread(fid,1,'int32');           %4  触发后长度(长整型)
%         DasInfo(i).MaxDat=fread(fid,1,'uint16');         %2  满量程时的A/D转换(整型)
%         DasInfo(i).LowRang=fread(fid,1,'float32');      %4  量程下限(单精度)
%         DasInfo(i).HighRang=fread(fid,1,'float32');     %4  量程上限(单精度)
%         DasInfo(i).Factor=fread(fid,1,'float32');       %4  系数因子(单精度)
%         DasInfo(i).Offset=fread(fid,1,'float32');       %4  信号偏移量(单精度)
%         temp=fread(fid,8);
%         DasInfo(i).Unit=char(temp');                   %8  物理量单位,字符串
%         DasInfo(i).Dly=fread(fid,1,'float32');          %4  延迟(单精度)
%         DasInfo(i).AttribDt=fread(fid,1,'int16');       %2  数据属性(整型)
%         DasInfo(i).DatWth=fread(fid,1,'int16');         %2  数据宽度(整型)
%         %Sum=74
%         %sparing for later use
%         DasInfo(i).SparI1=fread(fid,1,'int16');         %2  备用字段1 数字 (整型)
%         DasInfo(i).SparI2=fread(fid,1,'int16');         %2  备用字段2 数字 (整型)
%         DasInfo(i).SparI3=fread(fid,1,'int16');         %2  备用字段3 数字 (整型)
%         DasInfo(i).SparF1=fread(fid,1,'float32');       %4  备用字段1 数字 (单精度)
%         DasInfo(i).SparF2=fread(fid,1,'float32');       %4  备用字段2 数字 (单精度)
%         temp=fread(fid,8);
%         DasInfo(i).SparC1=char(temp');                 %8  备用字段1 数字 (字符串)
%         temp=fread(fid,16);
%         DasInfo(i).SparC2=char(temp');                %16 备用字段2 数字 (字符串)
%         temp=fread(fid,10);
%         DasInfo(i).SparC3=char(temp');                %10 备用字段3 数字 (字符串)
%         %Total  Sum=122
%     end
% end
% tt2=toc
% %--------------------------------------------------------------------------------------------

% 
% 
% ChnlCount=FileSize/LenInfo;
% % DasInfo(1:ChnlCount)=SetMyInfo;
% 
% %   varargin{1} isonlychannelname
% if nargin>=2 && ~isempty(varargin{1}) && length(varargin{1})==1 && varargin{1}==0
%     offset=12;
%     for i=1:ChnlCount
%         status = fseek(fid, offset, 'bof');
%         temp=fread(fid,12);
%         DasInfo(i).ChnlName=char(temp');               %12 通道名,字符串
%         offset=offset+122;
%     end
% elseif nargin>=2 && ~isempty(varargin{1}) && length(varargin{1})==1 && varargin{1}>0
%     i=varargin{1};
%     status = fseek(fid, 122*(i-1), 'bof');
%     temp=fread(fid,10);
%     DasInfo(i).FileType=char(temp');          %10 文件类型,字符串
%     DasInfo(i).ChnlId=fread(fid,1,'int16');         %2  通道号(整型)
%     temp=fread(fid,12);
%     DasInfo(i).ChnlName=char(temp');               %12 通道名,字符串
%     DasInfo(i).Addr=fread(fid,1,'int32');           %4  数据地址(长整型)
%     DasInfo(i).Freq=fread(fid,1,'float32');         %4  采数频率(单精度)
%     DasInfo(i).Len=fread(fid,1,'int32');            %4  数据长度(长整型)
%     DasInfo(i).Post=fread(fid,1,'int32');           %4  触发后长度(长整型)
%     DasInfo(i).MaxDat=fread(fid,1,'uint16');         %2  满量程时的A/D转换(整型)
%     DasInfo(i).LowRang=fread(fid,1,'float32');      %4  量程下限(单精度)
%     DasInfo(i).HighRang=fread(fid,1,'float32');     %4  量程上限(单精度)
%     DasInfo(i).Factor=fread(fid,1,'float32');       %4  系数因子(单精度)
%     DasInfo(i).Offset=fread(fid,1,'float32');       %4  信号偏移量(单精度)
%     temp=fread(fid,8);
%     DasInfo(i).Unit=char(temp');                   %8  物理量单位,字符串
%     DasInfo(i).Dly=fread(fid,1,'float32');          %4  延迟(单精度)
%     DasInfo(i).AttribDt=fread(fid,1,'int16');       %2  数据属性(整型)
%     DasInfo(i).DatWth=fread(fid,1,'int16');         %2  数据宽度(整型)
%     %Sum=74
%     %sparing for later use
%     DasInfo(i).SparI1=fread(fid,1,'int16');         %2  备用字段1 数字 (整型)
%     DasInfo(i).SparI2=fread(fid,1,'int16');         %2  备用字段2 数字 (整型)
%     DasInfo(i).SparI3=fread(fid,1,'int16');         %2  备用字段3 数字 (整型)
%     DasInfo(i).SparF1=fread(fid,1,'float32');       %4  备用字段1 数字 (单精度)
%     DasInfo(i).SparF2=fread(fid,1,'float32');       %4  备用字段2 数字 (单精度)
%     temp=fread(fid,8);
%     DasInfo(i).SparC1=char(temp');                 %8  备用字段1 数字 (字符串)
%     temp=fread(fid,16);
%     DasInfo(i).SparC2=char(temp');                %16 备用字段2 数字 (字符串)
%     temp=fread(fid,10);
%     DasInfo(i).SparC3=char(temp');                %10 备用字段3 数字 (字符串)
% elseif nargin>=2 && ~isempty(varargin{1}) && length(varargin{1})>1
%     for j=1:length(varargin{1})
%         i=varargin{1}(j);
%         status = fseek(fid, 122*(i-1), 'bof');
%         temp=fread(fid,10);
%         DasInfo(i).FileType=char(temp');          %10 文件类型,字符串
%         DasInfo(i).ChnlId=fread(fid,1,'int16');         %2  通道号(整型)
%         temp=fread(fid,12);
%         DasInfo(i).ChnlName=char(temp');               %12 通道名,字符串
%         DasInfo(i).Addr=fread(fid,1,'int32');           %4  数据地址(长整型)
%         DasInfo(i).Freq=fread(fid,1,'float32');         %4  采数频率(单精度)
%         DasInfo(i).Len=fread(fid,1,'int32');            %4  数据长度(长整型)
%         DasInfo(i).Post=fread(fid,1,'int32');           %4  触发后长度(长整型)
%         DasInfo(i).MaxDat=fread(fid,1,'uint16');         %2  满量程时的A/D转换(整型)
%         DasInfo(i).LowRang=fread(fid,1,'float32');      %4  量程下限(单精度)
%         DasInfo(i).HighRang=fread(fid,1,'float32');     %4  量程上限(单精度)
%         DasInfo(i).Factor=fread(fid,1,'float32');       %4  系数因子(单精度)
%         DasInfo(i).Offset=fread(fid,1,'float32');       %4  信号偏移量(单精度)
%         temp=fread(fid,8);
%         DasInfo(i).Unit=char(temp');                   %8  物理量单位,字符串
%         DasInfo(i).Dly=fread(fid,1,'float32');          %4  延迟(单精度)
%         DasInfo(i).AttribDt=fread(fid,1,'int16');       %2  数据属性(整型)
%         DasInfo(i).DatWth=fread(fid,1,'int16');         %2  数据宽度(整型)
%         %Sum=74
%         %sparing for later use
%         DasInfo(i).SparI1=fread(fid,1,'int16');         %2  备用字段1 数字 (整型)
%         DasInfo(i).SparI2=fread(fid,1,'int16');         %2  备用字段2 数字 (整型)
%         DasInfo(i).SparI3=fread(fid,1,'int16');         %2  备用字段3 数字 (整型)
%         DasInfo(i).SparF1=fread(fid,1,'float32');       %4  备用字段1 数字 (单精度)
%         DasInfo(i).SparF2=fread(fid,1,'float32');       %4  备用字段2 数字 (单精度)
%         temp=fread(fid,8);
%         DasInfo(i).SparC1=char(temp');                 %8  备用字段1 数字 (字符串)
%         temp=fread(fid,16);
%         DasInfo(i).SparC2=char(temp');                %16 备用字段2 数字 (字符串)
%         temp=fread(fid,10);
%         DasInfo(i).SparC3=char(temp');                %10 备用字段3 数字 (字符串)
%     end
% else
%     for i=1:ChnlCount
%         temp=fread(fid,10);
%         DasInfo(i).FileType=char(temp');          %10 文件类型,字符串
%         DasInfo(i).ChnlId=fread(fid,1,'int16');         %2  通道号(整型)
%         temp=fread(fid,12);
%         DasInfo(i).ChnlName=char(temp');               %12 通道名,字符串
%         DasInfo(i).Addr=fread(fid,1,'int32');           %4  数据地址(长整型)
%         DasInfo(i).Freq=fread(fid,1,'float32');         %4  采数频率(单精度)
%         DasInfo(i).Len=fread(fid,1,'int32');            %4  数据长度(长整型)
%         DasInfo(i).Post=fread(fid,1,'int32');           %4  触发后长度(长整型)
%         DasInfo(i).MaxDat=fread(fid,1,'uint16');         %2  满量程时的A/D转换(整型)
%         DasInfo(i).LowRang=fread(fid,1,'float32');      %4  量程下限(单精度)
%         DasInfo(i).HighRang=fread(fid,1,'float32');     %4  量程上限(单精度)
%         DasInfo(i).Factor=fread(fid,1,'float32');       %4  系数因子(单精度)
%         DasInfo(i).Offset=fread(fid,1,'float32');       %4  信号偏移量(单精度)
%         temp=fread(fid,8);
%         DasInfo(i).Unit=char(temp');                   %8  物理量单位,字符串
%         DasInfo(i).Dly=fread(fid,1,'float32');          %4  延迟(单精度)
%         DasInfo(i).AttribDt=fread(fid,1,'int16');       %2  数据属性(整型)
%         DasInfo(i).DatWth=fread(fid,1,'int16');         %2  数据宽度(整型)
%         %Sum=74
%         %sparing for later use
%         DasInfo(i).SparI1=fread(fid,1,'int16');         %2  备用字段1 数字 (整型)
%         DasInfo(i).SparI2=fread(fid,1,'int16');         %2  备用字段2 数字 (整型)
%         DasInfo(i).SparI3=fread(fid,1,'int16');         %2  备用字段3 数字 (整型)
%         DasInfo(i).SparF1=fread(fid,1,'float32');       %4  备用字段1 数字 (单精度)
%         DasInfo(i).SparF2=fread(fid,1,'float32');       %4  备用字段2 数字 (单精度)
%         temp=fread(fid,8);
%         DasInfo(i).SparC1=char(temp');                 %8  备用字段1 数字 (字符串)
%         temp=fread(fid,16);
%         DasInfo(i).SparC2=char(temp');                %16 备用字段2 数字 (字符串)
%         temp=fread(fid,10);
%         DasInfo(i).SparC3=char(temp');                %10 备用字段3 数字 (字符串)
%         %Total  Sum=122
%     end
% 
% 
% end
% 
% status = fclose(fid);
% y=DasInfo;
% n=round(ChnlCount);
% %catch
% status = fclose('all');
% %end








% for reading reference
%
%
%
%
%
%
%
%
%
%
%
%     return
%
%
%     tic
%     for j=1:1000
%         offset=0;
%         status = fseek(fid, offset, 'bof');
%         temp=fread(fid,ChnlCount*10,'10*uchar=>uchar',122-10);
%         FileType=(char(reshape(temp,10,ChnlCount)))';          %10 文件类型,字符串
%         %         FileType=mat2cell(FileTypes,ones(1,ChnlCount),10);
%         offset=offset+10;
%         status = fseek(fid, offset, 'bof');
%         ChnlId=fread(fid,ChnlCount,'int16',122-2);         %2  通道号(整型)
%         offset=offset+2;
%         status = fseek(fid, offset, 'bof');
%         temp=fread(fid,ChnlCount*12,'12*uchar=>uchar',122-12);
%         ChnlName=(char(reshape(temp,12,ChnlCount)))';          %12 通道名,字符串
%         offset=offset+12;
%         status = fseek(fid, offset, 'bof');
%         Addr=fread(fid,ChnlCount,'int32',122-4);           %4  数据地址(长整型)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         Freq=fread(fid,ChnlCount,'float32',122-4);         %4  采数频率(单精度)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         Len=fread(fid,ChnlCount,'int32',122-4);            %4  数据长度(长整型)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         Post=fread(fid,ChnlCount,'int32',122-4);           %4  触发后长度(长整型)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         MaxDat=fread(fid,ChnlCount,'uint16',122-2);         %2  满量程时的A/D转换(整型)
%         offset=offset+2;
%         status = fseek(fid, offset, 'bof');
%         LowRang=fread(fid,ChnlCount,'float32',122-4);      %4  量程下限(单精度)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         HighRang=fread(fid,ChnlCount,'float32',122-4);     %4  量程上限(单精度)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         Factor=fread(fid,ChnlCount,'float32',122-4);       %4  系数因子(单精度)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         Offset=fread(fid,ChnlCount,'float32',122-4);       %4  信号偏移量(单精度)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         temp=fread(fid,ChnlCount*8,'8*uchar=>uchar',122-8);
%         Unit=(char(reshape(temp,8,ChnlCount)))';          %8  物理量单位,字符串
%         offset=offset+8;
%         status = fseek(fid, offset, 'bof');
%         Dly=fread(fid,ChnlCount,'float32',122-4);          %4  延迟(单精度)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         AttribDt=fread(fid,ChnlCount,'int16',122-2);       %2  数据属性(整型)
%         offset=offset+2;
%         status = fseek(fid, offset, 'bof');
%         DatWth=fread(fid,ChnlCount,'int16',122-2);         %2  数据宽度(整型)
%         %Sum=74
%         %sparing for later use
%         offset=offset+2;
%         status = fseek(fid, offset, 'bof');
%         SparI1=fread(fid,ChnlCount,'int16',122-2);         %2  备用字段1 数字 (整型)
%         offset=offset+2;
%         status = fseek(fid, offset, 'bof');
%         SparI2=fread(fid,ChnlCount,'int16',122-2);         %2  备用字段2 数字 (整型)
%         offset=offset+2;
%         status = fseek(fid, offset, 'bof');
%         SparI3=fread(fid,ChnlCount,'int16',122-2);         %2  备用字段3 数字 (整型)
%         offset=offset+2;
%         status = fseek(fid, offset, 'bof');
%         SparF1=fread(fid,ChnlCount,'float32',122-4);       %4  备用字段1 数字 (单精度)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         SparF2=fread(fid,ChnlCount,'float32',122-4);       %4  备用字段2 数字 (单精度)
%         offset=offset+4;
%         status = fseek(fid, offset, 'bof');
%         temp=fread(fid,ChnlCount*8,'8*uchar=>uchar',122-8);
%         SparC1=(char(reshape(temp,8,ChnlCount)))';              %8  备用字段1 数字 (字符串)
%         offset=offset+8;
%         status = fseek(fid, offset, 'bof');
%         temp=fread(fid,ChnlCount*16,'16*uchar=>uchar',122-16);
%         SparC2=(char(reshape(temp,16,ChnlCount)))';                 %16 备用字段2 数字 (字符串)
%         offset=offset+16;
%         status = fseek(fid, offset, 'bof');
%         temp=fread(fid,ChnlCount*10,'10*uchar=>uchar',122-10);
%         SparC3=(char(reshape(temp,10,ChnlCount)))';                  %10 备用字段3 数字 (字符串)
%         %Total  Sum=122
%         %construct the structure
%         %         DasInfo=struct('FileType',{FileType},'ChnlId',{ChnlId})%,'ChnlName',{ChnlName},'Addr',{Addr},'Freq',{Freq},'Len',{Len},'Post',{Post},'MaxDat',{MaxDat},'LowRang',{LowRang},...
%         %             'HighRang',{HighRang},'Factor',{Factor},'Offset',{Offset},'Unit',{Unit},'Dly',{Dly},'AttribDt',{AttribDt},'DatWth',{DatWth},'SparI1',{SparI1},'SparI2',{SparI2},...
%         %             'SparI3',{SparI3},'SparF1',{SparF1},'SparF2',{SparF2},'SparC1',{SparC1},'SparC2',{SparC2},'SparC3',{SparC3});
%         %         DasInfo=struct('FileType',{FileType},'ChnlId',{ChnlId},'ChnlName',{ChnlName},'Addr',{Addr},'Freq',{Freq},'Len',{Len},'Post',{Post},'MaxDat',{MaxDat},'LowRang',{LowRang},...
%         %             'HighRang',{HighRang},'Factor',{Factor},'Offset',{Offset},'Unit',{Unit},'Dly',{Dly},'AttribDt',{AttribDt},'DatWth',{DatWth},'SparI1',{SparI1},'SparI2',{SparI2},...
%         %             'SparI3',{SparI3},'SparF1',{SparF1},'SparF2',{SparF2},'SparC1',{SparC1},'SparC2',{SparC2},'SparC3',{SparC3});
%
%         %new code for get DasInfo
%     end
% T1=toc
%         DasInfo(1:ChnlCount)=SetMyInfo;
%         for i=1:ChnlCount
%             DasInfo(i).FileType=FileType(i,:);          %10 文件类型,字符串
%             DasInfo(i).ChnlId=ChnlId(i);         %2  通道号(整型)
%             DasInfo(i).ChnlName=ChnlName(i,:);               %12 通道名,字符串
%             DasInfo(i).Addr=Addr(i);           %4  数据地址(长整型)
%             DasInfo(i).Freq=Freq(i);         %4  采数频率(单精度)
%             DasInfo(i).Len=Len(i);            %4  数据长度(长整型)
%             DasInfo(i).Post=Post(i);           %4  触发后长度(长整型)
%             DasInfo(i).MaxDat=MaxDat(i);         %2  满量程时的A/D转换(整型)
%             DasInfo(i).LowRang=LowRang(i);      %4  量程下限(单精度)
%             DasInfo(i).HighRang=HighRang(i);     %4  量程上限(单精度)
%             DasInfo(i).Factor=Factor(i);       %4  系数因子(单精度)
%             DasInfo(i).Offset=Offset(i);       %4  信号偏移量(单精度)
%             DasInfo(i).Unit=Unit(i,:);                   %8  物理量单位,字符串
%             DasInfo(i).Dly=Dly(i);          %4  延迟(单精度)
%             DasInfo(i).AttribDt=AttribDt(i);       %2  数据属性(整型)
%             DasInfo(i).DatWth=DatWth(i);         %2  数据宽度(整型)
%             %Sum=74
%             %sparing for later use
%             DasInfo(i).SparI1=SparI1(i);         %2  备用字段1 数字 (整型)
%             DasInfo(i).SparI2=SparI2(i);         %2  备用字段2 数字 (整型)
%             DasInfo(i).SparI3=SparI3(i);         %2  备用字段3 数字 (整型)
%             DasInfo(i).SparF1=SparF1(i);       %4  备用字段1 数字 (单精度)
%             DasInfo(i).SparF2=SparF2(i);       %4  备用字段2 数字 (单精度)
%             DasInfo(i).SparC1=SparC1(i,:);                 %8  备用字段1 数字 (字符串)
%             DasInfo(i).SparC2=SparC2(i,:);                %16 备用字段2 数字 (字符串)
%             DasInfo(i).SparC3=SparC3(i,:);                %10 备用字段3 数字 (字符串)
%             %Total  Sum=122
%         end
%


