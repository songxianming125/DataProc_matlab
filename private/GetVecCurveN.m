%read VEC data
%ע����������  ������for���
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
            iStep = 1000 / Info.Frequency; %���ڣ���λΪms
        else
            setappdata(0,'MyErr','frequency is negative');
            return
        end
        fseek(fid, lAdd, 'bof');
        Leng=Info.DataLength*2;  % t,y; two data for one node
        %read according to the data type
        if Info.DataType == 2
            % mySing As Single  '�Ե����ȸ�����
            myData = fread(fid,Leng,'float32'); %�����ȸ����� ʵ��������
        elseif Info.DataType == 1
            % myInteger As Integer
            myData = fread(fid,Leng,'int16'); %����������
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

