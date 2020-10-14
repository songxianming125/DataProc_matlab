function [x,y]=GetMyCurveN(str,DasInfos)
%%  2016.07.16
% fix frequency problem by introduce a new var InterpPeriodFreq, give up
% the var InterpPeriod

%%
%读多道中的一道
%注意数组运算  不能用for语句
%str is the filename
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%new algorithm for building short x1
global  MyPicStruct Tstart Tend InterpPeriodFreq ADValue bFullOrFast bFacMode 

setappdata(0,'MyErr',[]);
%ADValue=getappdata(0,'ADValue');%sometimes, we need the AD value for debugging, use this status for get it
x=[];
y=[];
myDataN=[];
if isempty(MyPicStruct)
    MyPicStruct=MyPicInit;%init by file data
end




%try
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



DasInfo=DasInfos(1);%share the same x
iStep = 1000 / DasInfo.Freq;
iStartTime=DasInfo.Dly+(DasInfo.Post-DasInfo.Len)*iStep;
iEnd=iStartTime+iStep*(DasInfo.Len-1);


%% when no gui, set default Tstart and Tend
% all code base on ms
if  isempty(Tstart) && isempty(Tend)
    Tstart=MyPicStruct.xleft;
    Tend=MyPicStruct.xright;

    if strcmp(MyPicStruct.timeUnit,'ms')
    elseif strcmp(MyPicStruct.timeUnit,'s')
        % s->ms
        Tstart=Tstart*1000;
        Tend=Tend*1000;
    end   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% bb=1;
if DasInfo.Freq>2e5
% if bb>0
    MaxLeng=2e7;  %maximum length of data per variable
    if MyPicStruct.XLimitMode==0
        myDelta=1e-10;
        if  ~isempty(Tstart) && ~isempty(Tend)
            if Tend>Tstart
                t0=ceil((Tstart-myDelta-iStartTime)/iStep);
                if t0<1
                    t0=1;
                end
                t1=ceil((Tend+myDelta-iStartTime)/iStep);
                if t1>DasInfo.Len
                    t1=DasInfo.Len;
                end
            end
        else
            
            t0=ceil((MyPicStruct.xleft-myDelta-iStartTime)/iStep);
            if t0<1
                t0=1;
            end
            t1=ceil((MyPicStruct.xright+myDelta-iStartTime)/iStep);
            if t1>DasInfo.Len
                t1=DasInfo.Len;
            end
        end
        if isempty(t0) || isempty(t1)
            status = fclose('all');
            return
        end
        if t0>=t1
            t0=1;
            t1=DasInfo.Len;% nature x length
        end
    elseif MyPicStruct.XLimitMode==1% nature x length
        t0=1;
        t1=DasInfo.Len;
    end
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %interpolation for high sampling signal
%%  set the private var InterpPeriod
    if ~isempty(InterpPeriodFreq) && isnumeric(InterpPeriodFreq)
        InterpPeriod=InterpPeriodFreq;
    elseif ~isempty(InterpPeriodFreq) && ischar(InterpPeriodFreq)
        %the DasInfo.Freq is far more than user set frequency
        if  length(InterpPeriodFreq)>2 && strcmpi(InterpPeriodFreq(end-1:end),'hz')
            InterpPeriod=DasInfo.Freq/str2num(InterpPeriodFreq(1:end-2));
        elseif length(InterpPeriodFreq)>1 && strcmpi(InterpPeriodFreq(end:end),'h')
            InterpPeriod=DasInfo.Freq/str2num(InterpPeriodFreq(1:end-1));
        else
            InterpPeriod=DasInfo.Freq/str2num(InterpPeriodFreq);
        end
        
    else
        if ~isempty(bFullOrFast) && bFullOrFast%1=FULL 0=FAST
            InterpPeriod=1;
        else
            InterpPeriod=DasInfo.Freq/100000;% if frequency >10kHz, we get only 10kHZ
        end
    end
    
    InterpPeriod=fix(InterpPeriod);  %integer
    
   %when data is too large, we force to extract data from begin
    
    while (t1-t0)/InterpPeriod>MaxLeng; %only 1/10 data is accessed
%         InterpPeriod=10*InterpPeriod;
        t1=t0+MaxLeng*InterpPeriod;
        disp(['too many data,force to extract'])
        setappdata(0,'MyErr',['too many data,force to extract']);
    end
    
    
    x1=iStartTime+(t0-1)*iStep:iStep*InterpPeriod:iStartTime+(t1-1)*iStep;
    x1=x1';
    Leng=length(x1);
    
    skip=DasInfo.DatWth*(InterpPeriod-1);  %skip bytes for read
    
    
    
    for i=1:ChannelNum
        DasInfo=DasInfos(i);
        if (DasInfo.AttribDt ~= 6)
            lAdd=0+DasInfo.Addr+(t0-1)*DasInfo.DatWth; %1 For VB, 0 For C++ and Matlab
        else
            lAdd=(t0-1)*DasInfo.DatWth; %1 For VB, 0 For C++ and Matlab
        end
        
        
        %point to the right position
        s=fseek(fid, lAdd, 'bof');
        if s==-1
            warnstr='the pointer is out of position';
            setappdata(0,'MyErr',warnstr);
            status = fclose('all');
            return
        end
        if bFacMode==1
            DasInfo.Factor=1;
        end
        
        %get the value according to the data type
        if DasInfo.AttribDt == 3 
            if DasInfo.DatWth == 4 %单精度浮点数 实型物理量
                myData = fread(fid,Leng,'float32',skip);
                myData = DasInfo.Factor .*myData-DasInfo.Offset;
            elseif DasInfo.DatWth == 8 %双精度浮点数 实型物理量
                myData = fread(fid,Leng,'float64',skip);
                myData = DasInfo.Factor .*myData-DasInfo.Offset;
            end
            
        elseif DasInfo.AttribDt ==2 || DasInfo.AttribDt == 5    %直接物理量
            if DasInfo.DatWth == 2
                myData = fread(fid,Leng,'int16',skip);
                myData = DasInfo.Factor .*myData-DasInfo.Offset;
            elseif DasInfo.DatWth == 1
                myData = fread(fid,Leng,'int8',skip);
                myData = DasInfo.Factor .*myData-DasInfo.Offset;
            end
            %******************************************************************************************************************
            %数据采集的真正通路
        elseif (DasInfo.AttribDt == 1) && (DasInfo.DatWth == 2)%% && (DasInfo.MaxDat == 4095 || DasInfo.MaxDat == 65535||DasInfo.MaxDat ==16383)
            myInteger1= fread(fid,Leng,'uint16',skip);
            if ~isempty(ADValue) && ADValue
                myData =myInteger1;
            else
                myData = DasInfo.Factor .* (DasInfo.LowRang + (myInteger1) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
            end
        elseif DasInfo.AttribDt == 1 && DasInfo.DatWth == 1    %And (DasInfo.MaxDat = 255)
            myByte=fread(fid,Leng,'uint8',skip);
            if ~isempty(ADValue) && ADValue
                myData =myByte;
            else
                myData = DasInfo.Factor .* (DasInfo.LowRang + (myByte) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
            end
            %__________________
            
        elseif (DasInfo.AttribDt == 6)
            fseek(fid, lAdd, 'bof');
%             myByte=fread(fid, Leng*DasInfo.DatWth,'uint8',skip); %no skip
            myByte=fread(fid, Leng*DasInfo.DatWth,'uint8',skip); %no skip
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
            msgbox('data file no enough data/in GetMyCurveN')
        end
        if ~isempty(myDataN) && size(myData,1)~=size(myDataN,1)
            status = fclose('all');
            msgbox('the channels have different ranges' )
            return
        end
        myDataN(:,i)=myData;
        
    end %i
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x=x1;
    y=myDataN;
    
else
    tic
    
    xr=iStartTime:iStep:iEnd;
    t=xr';
    if MyPicStruct.XLimitMode==0
        myDelta=1e-10;
        if  ~isempty(Tstart) && ~isempty(Tend)
            if Tend>Tstart
                t0=find(t>=Tstart-myDelta,1);
                t1=find(t<=Tend+myDelta,1, 'last');
            end
        else
            t0=find(t>=MyPicStruct.xleft-myDelta,1);
            t1=find(t<=MyPicStruct.xright+myDelta,1, 'last');
        end
        if isempty(t0) || isempty(t1)
            status = fclose('all');
            return
        end
        if t0>=t1
            t0=1;
            t1=length(t);
        end
    elseif MyPicStruct.XLimitMode==1
        t0=1;
        t1=length(t);
    end
    x1=t(t0:t1);
    Leng=length(x1);
   
    for i=1:ChannelNum
        DasInfo=DasInfos(i);
        if (DasInfo.AttribDt ~= 6)
            lAdd=0+DasInfo.Addr+(t0-1)*DasInfo.DatWth; %1 For VB, 0 For C++ and Matlab
        else
            lAdd=(t0-1)*DasInfo.DatWth; %1 For VB, 0 For C++ and Matlab
        end
        %point to the right position
        s=fseek(fid, lAdd, 'bof');
        if s==-1
            warnstr='the pointer is out of position';
            setappdata(0,'MyErr',warnstr);
            status = fclose('all');
            return
        end
        if bFacMode==1
            DasInfo.Factor=1;
        end
        
        %get the value according to the data type
        if DasInfo.AttribDt == 3 
            if DasInfo.DatWth == 4 %单精度浮点数 实型物理量
                myData = fread(fid,Leng,'float32');
                myData = DasInfo.Factor .*myData-DasInfo.Offset;
            elseif DasInfo.DatWth == 8 %双精度浮点数 实型物理量
                myData = fread(fid,Leng,'float64');
                myData = DasInfo.Factor .*myData-DasInfo.Offset;
            end

         elseif DasInfo.AttribDt ==2 || DasInfo.AttribDt == 5    %直接物理量
            if DasInfo.DatWth == 2
                myData = fread(fid,Leng,'int16');
                myData = DasInfo.Factor .*myData;
            elseif DasInfo.DatWth == 1
                myData = fread(fid,Leng,'int8');
                myData = DasInfo.Factor .*myData;
            end
            %******************************************************************************************************************
            %real acq
        elseif (DasInfo.AttribDt == 1) && (DasInfo.DatWth == 2)%% && (DasInfo.MaxDat == 4095 || DasInfo.MaxDat == 65535||DasInfo.MaxDat ==16383)
            myInteger1= fread(fid,Leng,'uint16');
            if ~isempty(ADValue) && ADValue
               % myData =myInteger1;
                myData =DasInfo.LowRang + (myInteger1) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat;
            else
                myData = DasInfo.Factor .* (DasInfo.LowRang + (myInteger1) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
            end
        elseif DasInfo.AttribDt == 1 && DasInfo.DatWth == 1    %And (DasInfo.MaxDat = 255)
            myByte=fread(fid,Leng,'uint8');
            if ~isempty(ADValue) && ADValue
               % myData =myByte;
                myData =DasInfo.Factor .* (DasInfo.LowRang + (myByte) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
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
            msgbox('data file no enough data/in GetMyCurveN')
        end
        if ~isempty(myDataN) && size(myData,1)~=size(myDataN,1)
            status = fclose('all');
            msgbox('the channels have different ranges' )
            return
        end
        myDataN(:,i)=myData;
        
    end %i
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %interpolation for low sampling signal
    index=[];
    myxstep=[];
    if ~isempty(InterpPeriodFreq) && isnumeric(InterpPeriodFreq)
        InterpPeriod=fix(InterpPeriodFreq);
        index=1:InterpPeriod:Leng;
        
    elseif ~isempty(InterpPeriodFreq) && ischar(InterpPeriodFreq)
        if  length(InterpPeriodFreq)>2 && strcmpi(InterpPeriodFreq(end-1:end),'hz')
            myxstep=1000/str2num(InterpPeriodFreq(1:end-2));
        elseif length(InterpPeriodFreq)>1 && strcmpi(InterpPeriodFreq(end:end),'h')
            myxstep=1000/str2num(InterpPeriodFreq(1:end-1));
        else
            myxstep=1000/str2num(InterpPeriodFreq);
        end
        
    else
        if ~isempty(bFullOrFast) && bFullOrFast%1=FULL 0=FAST
        else
            if (x1(2)-x1(1))<0.1
                myxstep=1;  % if frequency >10kHz, we get only 10kHZ
            end
        end
    end
    
    if isempty(index)
        if ~isempty(myxstep)
            myx=x1(1):myxstep:x1(end);
            index=interp1(x1,[1:Leng],myx,'nearest','extrap');
        else
            index=[1:Leng];
        end
    end
    
%     if DasInfo.ChnlId==688 %keep the H-alpha sampling fixed
%         index=[1:Leng];
%     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x=x1(index);
    y=myDataN(index,:);
    
end

status = fclose(fid);
return
%catch
% status = fclose('all');
%end


