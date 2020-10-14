function setCurvesForShots(handles,CurrentShots)
global  MyPicStruct MyCurves PicDescription
global MyChanLists


MyShot=num2str(CurrentShots(1));
MyPicStruct=View2Struct(handles);
MyPicStruct.PicTitle=MyShot;


machine=getappdata(0,'machine');
switch machine
    case {'exl50','east'}
        
        
        
%         PicDescription=[];
%         MyCurves=[];
        MyCurveList=get(handles.lbCurves,'String');  % curves for more shot
        sMyCurveList=MyCurveList;
        
        m=length(MyCurveList);
        CurrentShot=CurrentShots(1);
        
        if m<1; return; end;  % stop here
        
        MyCurveList=[];
        CurrentChannelNum=0;
        
        
        machine=getappdata(0,'machine');
        [server,~] = getIpTree4Machine(machine);
        
        
        
        dataStep=get(handles.InterpPeriod,'string');
        
        %% s is the default time unit s -> s 1/1
        if isnumeric(str2double(dataStep)) &&  str2double(dataStep)>0
            timeContext=[num2str(str2double(get(handles.xLeft,'String'))/1) ':' num2str(str2double(get(handles.xRight,'String'))/1) ':' num2str(str2double(get(handles.InterpPeriod,'String'))/1)];
        else
            %% 1000Hz is the default frequency
            timeContext=[num2str(str2double(get(handles.xLeft,'String'))/1) ':' num2str(str2double(get(handles.xRight,'String'))/1) ':nan'];
        end
        
        isInOneTree=0;
        
        hwait=waitbar(0,'please wait ...');
        if isInOneTree
            CurrentChannel = regexpi(sMyCurveList{1}, '\w*$', 'match','once');
            %% find and open the tree
            strTreeName=getTreeName(machine,CurrentChannel); %
            strTreeName=strTreeName{1}; %
            initServerTree(server,strTreeName,CurrentShot)
            
            for i=1:length(sMyCurveList);
                CurrentChannel = regexpi(sMyCurveList{i}, '\w*$', 'match','once');
                [y,x,Unit]=db(CurrentChannel,timeContext);
                if strcmp(MyPicStruct.timeUnit,'ms')
                    x=x*1000;
                elseif strcmp(MyPicStruct.timeUnit,'s')
                end
                
                z=[];
                
                NickName=CurrentChannel;
                nMyCurveList=strcat(num2str(CurrentShot), '\' ,CurrentChannel);
                if lower(CurrentChannel(1))==':' %d->:
                    c=AddNewCurve(x(:,1),y(:,MyIndex),num2str(CurrentShot),NickName,Unit,z);
                else
                    c=AddNewCurve(x(:,1),y(:,1),num2str(CurrentShot),NickName,Unit,z);
                end
                
                
                CurrentChannelNum=CurrentChannelNum+1;
                if CurrentChannelNum>1
                    MyCurves(CurrentChannelNum)=c;
                    MyCurveList(CurrentChannelNum)={nMyCurveList};
                else
                    MyCurves=c;
                    MyCurveList={nMyCurveList};
                end
                
                waitbar(i/m);
            end
            %% close and disconnect
            initServerTree;
        else
            for i=1:length(sMyCurveList);
                CurrentChannel=sMyCurveList{i};
                patternname='[@_\w]*$';
                CurrentChannel = regexpi(CurrentChannel, patternname, 'match','once');
                
                
                cmd=['[y,x,Unit]=' machine 'db(CurrentShot,CurrentChannel,timeContext);'];
                eval(cmd)
                
                
                
                
                if strcmp(MyPicStruct.timeUnit,'ms')
                    x=x*1000;
                elseif strcmp(MyPicStruct.timeUnit,'s')
                end
                z=[];
                
                NickName=CurrentChannel;
                nMyCurveList=strcat(num2str(CurrentShot), '\' ,CurrentChannel);
                if lower(CurrentChannel(1))==':' %d->:
                    c=AddNewCurve(x(:,1),y(:,MyIndex),num2str(CurrentShot),NickName,Unit,z);
                else
                    c=AddNewCurve(x(:,1),y(:,1),num2str(CurrentShot),NickName,Unit,z);
                end
                
                
                CurrentChannelNum=CurrentChannelNum+1;
                if CurrentChannelNum>1
                    MyCurves(CurrentChannelNum)=c;
                    MyCurveList(CurrentChannelNum)={nMyCurveList};
                else
                    MyCurves=c;
                    MyCurveList={nMyCurveList};
                end
                
                waitbar(i/m);
            end
        end
        close(hwait)
    otherwise
        if isempty(PicDescription)
            MyCurveList=get(handles.lbCurves,'String');  % curves for more shot
        else
            MyCurveList={PicDescription(:).ChnlName};  % curve names for one shot
        end
        
        
%         PicDescription=[];
        sMyCurveList=get(handles.lbCurves,'String');  % curves for more shot
        if isempty(sMyCurveList)
            sMyCurveList=MyCurveList;
        end
        
        
        m=length(MyCurveList);
        CurrentShot=CurrentShots(1);
        
        if m<1; return; end;  % stop here
        
        
        
        % profile on
        % tic
        
        % make sure we have channel list
        if isempty(MyChanLists)
            y=setSystemName(CurrentShot,1);
        end
        
        MyShot=num2str(CurrentShot);
        % update the control parameter
        MyPicStruct=View2Struct(handles);
        
        MyPicStruct.PicTitle=MyShot;
        
        
        % [m1,n1]=size(MyCurves);
        
        %% find the system list
        channelNames=cell(m,1);
        systemNames=cell(m,1);
        systemNum=100;
        
        
        %%  parse the channel name over
        for i=1:m
            % change .* to \w* for Any alphabetic, numeric, or underscore character
            if iscell(sMyCurveList)
                currentName=sMyCurveList{i};
            else
                currentName=sMyCurveList;
            end
            
            %% cancel the shot information and select the channel
            channelPattern='(?<=\x5C)[\w_\+\-\=\!\#]*$|^[^\x5C]*$|@\w[^\x5C]*$';
            %     channelPattern='(?<=\x5C)\w*$';
            addcurvename=regexpi(currentName,channelPattern,'match','once');
            
            if addcurvename(1)=='_' || addcurvename(1)=='!' || addcurvename(1)=='='|| addcurvename(1)=='@'
                systemName=num2str(systemNum);
                systemNum=systemNum+1;
                ChanList=addcurvename;
            else
                systemPattern=['\w{3}(?=\x5C)'];
                systemName=regexpi(currentName,systemPattern,'match','once');
                
                
                % one channel one curves
                %     \x3a=':'  \x5C='\'
                %         channelPattern=['(?<=\xD\xA)[^\x3A]*' addcurvename '[^\x3A]*\x3A\w{3}(?=\xD\xA)'];
                channelPattern=['(?<=\xD\xA)' addcurvename '\x3A\w{3}(?=\xD\xA)'];
                ChanLists=regexpi(MyChanLists,channelPattern,'match','once');
                
                
                if ~isempty(ChanLists)
                    channelPattern=['^[^\x3A]*(?=\x3A)'];
                    ChanList=regexpi(ChanLists,channelPattern,'match','once');
                    
                    systemPattern=['(?<=\x3A)\w{3}$'];
                    systemName=regexpi(ChanLists,systemPattern,'match','once');
                else
                    
                    %add the curves from GetCurveByFormula
                    CurveNames=GetCurveNames;
                    
                    if strcmp(addcurvename(1),'@')
                        addcurvename=addcurvename(2:end);
                    end
                    patternname=['.\w*',addcurvename, '.*'];
                    
                    sNames = regexpi(CurveNames, patternname, 'match','once');
                    index=~cellfun(@isempty,sNames);
                    ChanList=sNames(index);
                    if isempty(ChanList)
                        ChanList=addcurvename;
                    else
                        if iscell(ChanList)
                            ChanList=ChanList{1};
                        end
                    end
                end
            end
            
            
            if isempty(systemName)
                systemName=num2str(systemNum);
                systemNum=systemNum+1;
            end
            
            channelNames(i)={ChanList};
            systemNames(i)={systemName};
            
            
        end
        %%  parse the channel name over
        
        uniqueNames=unique(systemNames);
        numSystemNames=length(uniqueNames);
        ChannelIndexs=cell(numSystemNames,1);
        hwait=waitbar(0,'please wait ...');
        for j=1:length(CurrentShots)
            CurrentShot=CurrentShots(j);
            
            lenCurves=length(MyCurves);
            
            %% prepare the new curves
            if lenCurves<1
            else
                MyCurves(lenCurves+1:lenCurves+m)=MyCurves(1:m);
                sMyCurveList(lenCurves+1:lenCurves+m)=MyCurveList(1:m);
            end
            
            
            
            
            for i=1:numSystemNames
                CurrentSysName=uniqueNames{i};
                patternname=['^' CurrentSysName '$'];
                s = regexpi(systemNames, patternname, 'start');
                Indexs=cellfun('isempty',s);
                ChannelIndex=find(~Indexs);
                %% store the channel positions for update
                % very good algorithm
                ChannelIndexs(i)={ChannelIndex};
                
                CurrentChannels=channelNames(ChannelIndex);
                numChannels=length(CurrentChannels);
                if numChannels>1
                    CurrentChannels=CurrentChannels';
                else
                    CurrentChannels=CurrentChannels{1};
                end
                
                if isempty(str2num(CurrentSysName))
                    [y,x,CurrentSysName,Unit,Chs,z]=hl2adb(CurrentShot,CurrentChannels,CurrentSysName);
                else
                    [y,x,CurrentSysName,Unit,Chs,z]=hl2adb(CurrentShot,CurrentChannels);
                end
                if strcmp(MyPicStruct.timeUnit,'ms')
                elseif strcmp(MyPicStruct.timeUnit,'s')
                    x=x/1000;
                end
                
                
                
                %     [y,x,CurrentSysName,Unit,Chs,z]=hl2adb(CurrentShot,CurrentChannels,CurrentSysName);
                
                for ii=1:numChannels
                    CurrentChannel=Chs{ii};
                    CurrentChannel=ChannelsConditionning(CurrentChannel);
                    NickName=CurrentChannel;
                    if length(y)<2
                        x=0;
                        y=zeros(1,numChannels);
                        ShowWarning(CurrentShot,NickName,handles)
                        %continue
                    end
                    
                    CurrentChannelNum=ChannelIndex(ii);
                    if   isempty(CurrentSysName)
                        CurrentSysName='';
                    elseif iscell(CurrentSysName)
                        CurrentSysName=CurrentSysName{1};
                    end
                    
                    
                    sMyCurveList(lenCurves+CurrentChannelNum)={strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel)};
                    
                    if length(Unit)<ii || size(y,2)<ii
                        msgbox('more channels for one channel data! setCurvesForShots:186 ')
                    end
                    
                    c=AddNewCurve(x(:,1),y(:,ii),num2str(CurrentShot),NickName,Unit{ii},z);
                    
                    
                    
                    if isempty(MyCurves)
                        MyCurves=c;  %initial
                        MyCurves(CurrentChannelNum)=c;
                    else
                        MyCurves(lenCurves+CurrentChannelNum)=c;
                    end
                end
                
                waitbar(i/numSystemNames);
            end
        end
        
        close(hwait)
        MyCurveList=sMyCurveList;
end

s=SetMyCurves(MyCurveList);
MyPicStruct.Modified=1;
return
