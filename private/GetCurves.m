function [x,y]=GetCurves(str,DasInfos)
%str is the filename
%when we need more than one channels, and the tstart and tend is not the
%same, or the frequency is not the same, use this function to get data
%This is for ccs subsystem only!


global  MyPicStruct Tstart Tend InterpPeriod ADValue bFullOrFast
if isempty(bFullOrFast)
    bFullOrFast=0;%1=FULL 0=FAST
end

setappdata(0,'MyErr',[]);
%ADValue=getappdata(0,'ADValue');%sometimes, we need the AD value for debugging, use this status for get it
x=[];
y=[];
try
    %if DasInfo.Len>3000000
    % DasInfo.Len=3000000; %for lcw. if Len is too large, divided it
    %end
    %assign x
    fid = fopen(str,'r');
    if fid<0
        warnstr=strcat(str,' not found');%promt the need to update configuration
        setappdata(0,'MyErr',warnstr);
        return
    end



    ChannelNum=length(DasInfos);

    for i=1:ChannelNum
        DasInfo=DasInfos(i);
        iStep = 1000 / DasInfo.Freq;
        iStartTime=DasInfo.Dly+(DasInfo.Post-DasInfo.Len)*iStep;              %4  数据长度(长整型)
        iEnd=iStartTime+iStep*(DasInfo.Len-1);
        xr=iStartTime:iStep:iEnd;
        t=xr';

        myDelta=1e-10;
        if  ~isempty(Tstart) && ~isempty(Tend)
            if Tend>Tstart
                t0=find(t>=Tstart-myDelta,1);
                t1=find(t<=Tend+myDelta,1, 'last');
            end
        else
            if isempty(MyPicStruct)
                MyPicStruct=MyPicInit;%init by file data
            end
            t0=find(t>=MyPicStruct.xleft-myDelta,1);
            t1=find(t<=MyPicStruct.xright+myDelta,1, 'last');
        end

        if t0>=t1
            t0=1;
            t1=length(t);
        end

        %left and right

        x1=t(t0:t1);
        Leng=length(x1);
        %lAdd=0+DasInfo.Addr; %1 For VB, 0 For C++ and Matlab
        %Leng=DasInfo.Len;
        if (DasInfo.AttribDt ~= 6)
            lAdd=0+DasInfo.Addr+(t0-1)*DasInfo.DatWth; %1 For VB, 0 For C++ and Matlab
        else
            lAdd=(t0-1)*DasInfo.DatWth; %1 For VB, 0 For C++ and Matlab
        end


        %point to the right position
        fseek(fid, lAdd, 'bof');


        %get the value according to the data type

        if DasInfo.AttribDt == 3 | DasInfo.AttribDt == 4
            myData = fread(fid,Leng,'float32'); %单精度浮点数 实型物理量
            myData = DasInfo.Factor .*myData;
        elseif DasInfo.AttribDt ==2 | DasInfo.AttribDt == 5    %直接物理量
            if DasInfo.DatWth == 2
                myData = fread(fid,Leng,'int16');
                myData = DasInfo.Factor .*myData;
            elseif DasInfo.DatWth == 1
                myData = fread(fid,Leng,'int8');
                myData = DasInfo.Factor .*myData;
            end
            %******************************************************************************************************************
            %数据采集的真正通路
        elseif (DasInfo.AttribDt == 1) & (DasInfo.DatWth == 2) & (DasInfo.MaxDat == 4095 | DasInfo.MaxDat == 65535|DasInfo.MaxDat ==16383)
            myInteger1= fread(fid,Leng,'uint16');
            if ~isempty(ADValue) && ADValue
                myData =myInteger1;
            else
                myData = DasInfo.Factor .* (DasInfo.LowRang + (myInteger1) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
            end
        elseif DasInfo.AttribDt == 1 & DasInfo.DatWth == 1    %And (DasInfo.MaxDat = 255)
            myByte=fread(fid,Leng,'uint8');
            if ~isempty(ADValue) && ADValue
                myData =myByte;
            else
                myData = DasInfo.Factor .* (DasInfo.LowRang + (myByte) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
            end
            %__________________

        elseif (DasInfo.AttribDt == 6)
            fseek(fid, lAdd, 'bof');
            myByte=fread(fid, Leng*DasInfo.DatWth,'uint8');
            myMatrix=reshape(myByte,DasInfo.DatWth,Leng);%Leng*
            myAdd = floor((DasInfo.Addr) / 8) + 1;
            myInd =  mod(DasInfo.Addr, 8);
            myBitCon = 2 ^ (myInd);
            myData = myMatrix(myAdd,:);
            myData = bitget(myData(:),myInd+1);%myBitCon;
            %for displaying boolean variable
            myData(1) =0;%myBitCon;
            myData(2)=1;

            %__________________
        else
            setappdata(0,'MyErr','The data attribute, data width or maximum data have not been defined!');
        end
        %interpolation


        if bFullOrFast% interpolate forcely
            if isempty(InterpPeriod)
                InterpPeriod=1;
            elseif InterpPeriod<1
                InterpPeriod=1;
            end
            index=1:InterpPeriod:Leng;
        else
            if (x1(2)-x1(1))<0.02
                myxstep=0.1;
                myx=x1(1):myxstep:x1(end);
                index=interp1(x1,[1:Leng],myx,'nearest','extrap');
            else
                index=[1:Leng];
            end
        end
        
        if i<2
            x={x1(index)};
            y={myData(index,1)};
            
        else
            x(i)={x1(index)};
            y(i)={myData(index)};
        end
    end %i
    status = fclose(fid);
    return
catch
end
