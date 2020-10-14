function   [y,x,CurrentSysName,Unit,varargout]=GetIp(CurrentShot);
%tic
%ts = cputime;
y=[];
x=[];
CurrentSysName=[];
Unit=[];

[sMyShot,MyPath,Mylist] = GetShotPath(CurrentShot);

if isempty(Mylist) || length(Mylist)<1
    return
end

Unit='kA';
NumProbe=18;
[ChnlName,ChnlNum]=SetProbeChnl;%set channel group name

%vax or vx1
CurrentSysName='vx1';


MyFile=Mylist{1};
if length(MyFile)==12
    s=MyFile(6:8);
    MyFile=strrep(MyFile,s,CurrentSysName);%the prefered filename
end
CurrentInfoFile=fullfile(MyPath,MyFile);

[CurrentInfoFile,ChannelIndex,DasInfos]=GetChannelIndex(MyPath,MyFile,ChnlName(1));

if isempty(ChannelIndex)%
    CurrentSysName='vax';
    MyFile=Mylist{1};
    if length(MyFile)==12
        s=MyFile(6:8);
        MyFile=strrep(MyFile,s,CurrentSysName);%the prefered filename
    end
    CurrentInfoFile=fullfile(MyPath,MyFile);
end

[DasInfos,n]=GetMyInfoN(CurrentInfoFile);

CurrentDataFile=regexprep(CurrentInfoFile, '(?<!\.)([iI][nN][fF])', 'data','preservecase');
CurrentDataFile=regexprep(CurrentDataFile, '(\.[iI][nN][fF])', '\.dat','preservecase');

[myProbeData,x]=GetProbeData(CurrentDataFile,DasInfos,n,ChnlName,ChnlNum);

CurrentSysName=CurrentSysName(1:3);
if isempty(myProbeData)
    warnstr=strcat(num2str(CurrentShot),'/','ip',' is not existed or in other files');
    warndlg(warnstr)
    return
end


Bpol=reshape(myProbeData(2,:,:),NumProbe,[]);

%yl=myProbeData{2,1};
%for i=2:NumProbe
%yl=yl+myProbeData{2,i};
%end
y=5050./2.*sum(Bpol,1)./18;%y=Ip
y=y';
if nargout>=5
    varargout{1}=myProbeData;
    if nargout==6
        varargout{2}=CurrentInfoFile;
    end
end %nargout>=3

%tElasped = cputime-ts
%toc


function [y,x]=GetProbeData(CurrentDataFile,DasInfos,n,ChnlName,ChnlNum,varargin);
global  MyPicStruct Tstart Tend InterpPeriod ADValue bFullOrFast
y=[];
x=[];
%n is the channel number
NumProbe=length(ChnlNum);
MyIdList(1:n,1)={DasInfos(1:n).ChnlId};
Ids = cell2mat(MyIdList);
J=find(Ids==ChnlNum(1));%first channel
DasInfo=DasInfos(J);


iStep = 1000 / DasInfo.Freq;
iStartTime=DasInfo.Dly+(DasInfo.Post-DasInfo.Len)*iStep;              %4  数据长度(长整型)
iEnd=iStartTime+iStep*(DasInfo.Len-1);
xr=iStartTime:iStep:iEnd;
t=xr';

%time range




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


%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen(CurrentDataFile,'r');

for I=1:NumProbe
    for Icol=1:2
        J=find(Ids==ChnlNum(I,Icol));%DasInfo(J).ChnlName==ChnlName{I,Icol} &
        if isempty(J)
            yy(Icol,I,:)=myData;
            continue
        end
        DasInfo=DasInfos(J);
        %point to the right position
        lAdd=0+DasInfo.Addr+(t0-1)*DasInfo.DatWth; %1 For VB, 0 For C++ and Matlab  The offset is very important for reading, easy to make wrong
        fseek(fid, lAdd, 'bof'); %put the pointer to the beginning of the file
        %do according to the data type
        if (DasInfo.AttribDt == 1) & (DasInfo.DatWth == 2) & (DasInfo.MaxDat == 4095 | DasInfo.MaxDat == 65535|DasInfo.MaxDat ==16383)
            myInteger1= fread(fid,Leng,'uint16');
            myData = DasInfo.Factor .* (DasInfo.LowRang + (myInteger1) .* (DasInfo.HighRang - DasInfo.LowRang) / DasInfo.MaxDat) - DasInfo.Offset;
        else
            msgbox('The data attribute, data width or maximum data have not been defined!')
        end % if read
        yy(Icol,I,:)=myData;
    end %for Icol
end %for I
status = fclose(fid);

%assign x

if isempty(bFullOrFast)
    bFullOrFast=1;%1=FULL 0=FAST
end

if bFullOrFast% interpolate forcely
    if isempty(InterpPeriod)
        InterpPeriod=1;
    elseif InterpPeriod<1
        InterpPeriod=1;
    end
    index=1:InterpPeriod:Leng;
else
    if (x1(2)-x1(1))<0.1
        myxstep=0.1;
        myx=x1(1):myxstep:x1(end);
        index=interp1(x1,[1:Leng],myx,'nearest','extrap');
    else
        index=[1:Leng];
    end
end



x=x1(index);
y=yy(:,:,index);
