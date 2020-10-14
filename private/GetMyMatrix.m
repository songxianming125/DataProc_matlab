function [x,y]=GetMyMatrix(str,DasInfo)
%读多道中的一道
%注意数组运算  不能用for语句
%str is the filename
global  MyPicStruct Tstart Tend dFrequency dWidth dOffset
ADValue=0;
iWidth=dWidth/1000;% us to ms
iOffset=dOffset/1000;% um to ms

setappdata(0,'MyErr',[]);
x=[];
y=[];
myDataN=[];
if isempty(MyPicStruct)
    MyPicStruct=MyPicInit;%init by file data
end



fid = fopen(str,'r');


if fid<0
    warnstr=strcat(str,' not found');%promt the need to update configuration
    setappdata(0,'MyErr',warnstr);
    return
end

iStep = 1000 / DasInfo.Freq;
iStartTime=DasInfo.Dly+(DasInfo.Post-DasInfo.Len)*iStep;
iEndTime=iStartTime+iStep*(DasInfo.Len-1);




if ~isempty(dFrequency) && isnumeric(dFrequency)
    dFrequency=fix(dFrequency);
    myxstep=1000/dFrequency;
elseif ~isempty(dFrequency) && ischar(dFrequency)
    if  length(dFrequency)>2 && strcmpi(dFrequency(end-1:end),'hz')
        myxstep=1000/str2num(dFrequency(1:end-2));
    elseif length(dFrequency)>1 && strcmpi(dFrequency(end:end),'h')
        myxstep=1000/str2num(dFrequency(1:end-1));
    else
        myxstep=1000/str2num(dFrequency);
    end
else
    status = fclose('all');
    msgbox('the frequency parameter may be wrong' )
    return
end




Leng=fix(iWidth/iStep); %the data number within the dWidth

%calculate the start and end
if MyPicStruct.XLimitMode==0
    if  ~isempty(Tstart) && ~isempty(Tend)
        if Tend>=Tstart
            iTstart=Tstart;
            iTend=Tend;
        else
            iTstart=Tend;
            iTend=Tstart;
        end
    else
        iTstart=MyPicStruct.xleft;
        iTend=MyPicStruct.xright;
    end
elseif MyPicStruct.XLimitMode==1
    iTstart=iStartTime;
    iTend=iEndTime;
end


iStart=max(iTstart+iOffset,iStartTime);
iEnd=min(iTend,iEndTime-iOffset-iWidth);

iLenData=1+floor((iEnd-iStart)/myxstep);%length of output data
iAddressStep=myxstep/iStep;% 


%calculate the position of first raw data /t0 
myDelta=1e-20;
t0=1+fix((iStart-iStartTime)/iStep);

    
    
x=iStart:myxstep:(iStart+myxstep*(iLenData-1));
y=zeros(Leng,iLenData); %initializing variable
    
    for i=1:iLenData
        %lAdd=0+DasInfo.Addr; %1 For VB, 0 For C++ and Matlab
        %Leng=DasInfo.Len;
        lAdd=DasInfo.Addr+(t0-1)*DasInfo.DatWth+(i-1)*iAddressStep*DasInfo.DatWth; %1 For VB, 0 For C++ and Matlab

        %point to the right position
        s=fseek(fid, lAdd, 'bof');
        if s==-1
            warnstr='the pointer is out of position';
            setappdata(0,'MyErr',warnstr);
            status = fclose('all');
            return
        end

        %get the value according to the data type
        if DasInfo.AttribDt == 3 || DasInfo.AttribDt == 4
            myData = fread(fid,Leng,'float32'); %单精度浮点数 实型物理量
            myData = DasInfo.Factor .*myData;
        elseif DasInfo.AttribDt ==2 || DasInfo.AttribDt == 5    %直接物理量
            if DasInfo.DatWth == 2
                myData = fread(fid,Leng,'int16');
                myData = DasInfo.Factor .*myData;
            elseif DasInfo.DatWth == 1
                myData = fread(fid,Leng,'int8');
                myData = DasInfo.Factor .*myData;
            end
            %******************************************************************************************************************
            %数据采集的真正通路
        elseif (DasInfo.AttribDt == 1) && (DasInfo.DatWth == 2)%% && (DasInfo.MaxDat == 4095 || DasInfo.MaxDat == 65535||DasInfo.MaxDat ==16383)
%             myInteger1= fread(fid,Leng,'uint16');
%             if ~isempty(ADValue) && ADValue
%                 myData =myInteger1;
%             else
%                 myData = DasInfo.Factor .* (DasInfo.LowRang + (myInteger1) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
%             end
            
            myInteger1= fread(fid,Leng,'uint16');
            if ~isempty(ADValue) && ADValue
                myData =myInteger1;
            else
                myData = DasInfo.Factor .* (DasInfo.LowRang + (myInteger1) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
            end
            
        elseif DasInfo.AttribDt == 1 && DasInfo.DatWth == 1    %And (DasInfo.MaxDat = 255)
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
        
        
        if length(myData)<Leng
            myData(end:Leng)=0;
            msgbox('data file no enough data')
        end
        
        
        y(:,i)=myData;
        
    end %i

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    status = fclose(fid);
    
    return



