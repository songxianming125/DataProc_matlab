%read VEC data
%注意数组运算  不能用for语句
%str is the filename
function [x,y]=GetVecCurveN(str,Infos)
setappdata(0,'MyErr',[]);
x=[];
y=[];
try
    fid = fopen(str,'r');
    ChannelNum=length(Infos);
    for i=1:ChannelNum
        Info=Infos(i);
        lAdd = Info.DataAddress;   %1 For VB, 0 For C++
        if Info.Frequency > 0
            iStep = 1000 / Info.Frequency; %周期，单位为ms
        else
            setappdata(0,'MyErr','frequency is negative');
            return
        end
        fseek(fid, lAdd, 'bof');
        Leng=Info.DataLength*2;  % t,y; two data for one node
        %read according to the data type
        if Info.DataType == 2
            % mySing As Single  '对单精度浮点数
            myData = fread(fid,Leng,'float32'); %单精度浮点数 实型物理量
        elseif Info.DataType == 1
            % myInteger As Integer
            myData = fread(fid,Leng,'int16'); %整型物理量
        else
            setappdata(0,'MyErr','No such data type');
            return
        end


        if ChannelNum>1
            index=1:2:Leng;
            x{i}=myData(index')*iStep;
            index=2:2:Leng;
            y{i}=myData(index');
        elseif ChannelNum==1
            index=1:2:Leng;
            x=myData(index')*iStep;
            index=2:2:Leng;
            y=myData(index');
        end

    end
    status = fclose(fid);
catch
end

