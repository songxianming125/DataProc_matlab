function S=read(shot,range,varargin)

% Attention: time_dura<=200ms
len=length(varargin);

if len==1&&iscell(varargin{1})
    len=length(varargin{1});
    varargin=varargin{1};
end

s=cell(len,1);
lt=zeros(len,1);
for i=1:len
    [dirinfo,ch]=HLchfind(shot,varargin{i});
    if ch~=0
        info=GetMyInfoN(dirinfo);
        dirdata=strrep(dirinfo,'\inf\','\data\');
        dirdata=strrep(dirdata,'.INF','.DAT');
        dirdata=strrep(dirdata,'.inf','.dat');
        [x,y]=GetMyCurveN(dirdata,info(ch));
        Fs=info(ch).Freq/1e3;
        newrange(1)=max(range(1),x(1))-x(1);
        newrange(2)=min(range(2),x(end))-x(1);
        index=floor(newrange(1)*Fs)+1:floor(newrange(2)*Fs);
        s{i}=y(index);
        lt(i)=length(index);
    else
        s{i}=0;
        lt(i)=1;
        display([char(39) num2str(varargin{i}) char(39) ' not found'])
    end
end

if nargout==0
    for i=1:len
        assignin('base',strrep(varargin{i},'-','_'), s{i});
    end
    clear
else
    S=zeros(max(lt),len);
    for i=1:len
        tt=s{i};
        S(:,i)=tt';
    end
end


function [x,y]=GetMyCurveN(str,DasInfo)

try
% if DasInfo.Len>1000000 
%     DasInfo.Len=1000000; %for lcw. if Len is too large, divided it
% end
    
lAdd=0+DasInfo.Addr; %1 For VB, 0 For C++ and Matlab
Leng=DasInfo.Len;

fid = fopen(str,'r');
%point to the right position
fseek(fid, lAdd, 'bof');
%do according to the data type

if DasInfo.AttribDt == 3 | DasInfo.AttribDt == 4 
        myData = fread(fid,Leng,'float32'); %单精度浮点数 实型物理量
elseif DasInfo.AttribDt ==2 | DasInfo.AttribDt == 5    %直接物理量
        myData = fread(fid,Leng,'int16');  
%******************************************************************************************************************
% 数据采集的真正通路
elseif (DasInfo.AttribDt == 1) & (DasInfo.DatWth == 2) & (DasInfo.MaxDat == 4095 | DasInfo.MaxDat == 65535|DasInfo.MaxDat ==16383) 
        myInteger1= fread(fid,Leng,'uint16');
        myData = DasInfo.Factor .* (DasInfo.LowRang + (myInteger1) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;

elseif DasInfo.AttribDt == 1 & DasInfo.DatWth == 1    %And (DasInfo.MaxDat = 255)
        myByte=fread(fid,Leng,'uint8');
        myData = DasInfo.Factor .* (DasInfo.LowRang + (myByte) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
%__________________
        
elseif (DasInfo.AttribDt == 6) 
        fseek(fid, 0, 'bof');
        myByte=fread(fid, Leng*DasInfo.DatWth,'uint8');
        myMatrix=reshape(myByte,DasInfo.DatWth,Leng);%Leng*
        myAdd = floor((DasInfo.Addr) / 8) + 1;
        myInd =  mod(DasInfo.Addr, 8);
        myBitCon = 2 ^ (myInd);
        myData = myMatrix(myAdd,:);
        myData = bitget(myData(:),myInd+1);%myBitCon;
        
%__________________
else
    msgbox('GetMyCurveN,the data attribute, data width or maximum data have not been defined!')
end

status = fclose(fid);


%assign y
y=myData;
%assign x
iStep = 1000 / DasInfo.Freq;
iStartTime=DasInfo.Dly+(DasInfo.Post-DasInfo.Len)*iStep;              %4  数据长度(长整型)
iEnd=iStartTime+iStep*(DasInfo.Len-1);
xr=iStartTime:iStep:iEnd;
x=xr';
return

catch
    x=[];
    y=[];
end

%读多道信息文件


function [y,n]=GetMyInfoN(st)
y=[];
n=[];
fid = fopen(st,'r');
if fid==-1
    disp(st)
    warnstr=strcat('File/',st,' does not exist!');%promt the need to update configuration
    warndlg(warnstr)
    return
end

s = dir(st);         %fid = fopen('myfile.dat');
FileSize = s.bytes;             %fseek(fid, 0, 'eof');
LenInfo=122; %通道信息长度                               %filesize = ftell(fid)
                               %fclose(fid);
ChnlCount=FileSize/LenInfo;

for i=1:ChnlCount
temp=fread(fid,10);    
DasInfo(i).FileType=char(temp');          %10 文件类型,字符串
DasInfo(i).ChnlId=fread(fid,1,'int16');         %2  通道号(整型)
temp=fread(fid,12);    
DasInfo(i).ChnlName=char(temp');               %12 通道名,字符串
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
status = fclose(fid);
if ChnlCount <1
    DasInfo =0;
    ChnlCount=0;
end
y=DasInfo;
n=ChnlCount;

function [chdir,ch]=HLchfind(shot,name)
str=sprintf('%05d',shot);
dirshot=sprintf('%05d',(floor(shot/200))*200);
% if shot<16000 %11799
dirall=['\\hl\2adas\' dirshot '\inf\'];%192.168.10.11   -old% \\192.168.10.11\2adas% dirall=['\\hl\2ADAS-old\' dirshot '\inf\'];
% else
%dirall=['\\192.168.10.11\2ADAS\' dirshot '\inf\'];%\\hl\2ADAS\
%end
%dirall=['F:\data\' dirshot '\inf\'];
temp1=dir([dirall str '*.inf']);
lle=length(temp1);                                        %文件数

K=[];
for j=1:lle
    dirinfo=[dirall temp1(j).name];
    y=GetMyInfoN(dirinfo);
    if ~isnumeric(y)
      temp2=deblank(lower(strtok({y.ChnlName},char(0))));
      K=strmatch(lower(name),temp2,'exact');
    end
    if ~isempty(K)
         chdir=dirinfo;
         ch=K;
         break
     end
end
if isempty(K)
    ch=0;
    chdir='no such signal name';
end


