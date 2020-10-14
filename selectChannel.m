function selectChannel(hObject, eventdata, handles)
%%
%prepare channel for saving to HDF5 file
%%
global MyCurves  %something wrong

%input the function name
dlg_title = 'input your pattern for channel and the system';
prompt = {'pattern','system1','system2','0=search 1=load'};
% def   = {'ep[a-z]?[0-9][0-9]','EPC','EPD','1'};
% def   = {'epk[0-1][0-9]','EPK','EPD','1'};
def   = {'sI','sim','FBC','1'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
addcurvename=answer{1};
system1=answer{2};
system2=answer{3};
bSearchOrLoad=str2num(answer{4});

MyPath = which('DP');
dataFile='infChannelSystem.mat';
infChannelSystemFile=[MyPath(1:end-4) 'configurations' filesep dataFile];
fid = fopen(infChannelSystemFile,'r');
MyChanLists = fread(fid, '*char')';
status = fclose(fid);





if isempty(system1)
    channelPattern=['(?<=\xD\xA)[^\x3A]*' addcurvename '[^\x3A]*[\x3A][a-zA-Z]{3}(?=\xD\xA)'];
elseif length(system1)==3
    channelPattern=['(?<=\xD\xA)[^\x3A]*' addcurvename '[^\x3A]*[\x3A]' system1 '(?=\xD\xA)'];
end
%  char(hex2dec('3A'))
% channelPattern=['(?<=\xD\xA)' addcurvename '[\x3A]' system1 '(?=\xD\xA)'];
% channelPattern=['(?<=\xD\xA)' 'cc[\w]*' '[\x3A]' system1 '(?=\xD\xA)'];
ChanLists=regexpi(MyChanLists,channelPattern,'match');
% Channels=regexprep(ChanLists,'^([^\x3A]*)([\x3A])([a-zA-Z]{3})$','$1');
hwait=waitbar(0.5,'please wait for Processing DATA...');
if bSearchOrLoad
    if iscell(get(handles.ShotNumber,'String'))
        myShotNumber=get(handles.ShotNumber,'String');
        myShot=myShotNumber{get(handles.ShotNumber,'value')};
    else
        myShot=get(handles.ShotNumber,'String');
    end
    CurrentShot=str2double(myShot);
    
    systems=regexprep(ChanLists,'^([^\x3A]*)([\x3A])([a-zA-Z]{3})$','$3');
    systems = unique(systems);
    
    
    MyCurveList=get(handles.lbCurves,'String');
    % if length(MyCurveList)~=length(MyCurves)
    %     disp('length(MyCurveList)~=length(MyCurves)')
    %     return
    % end
    CurrentChannelNum=length(MyCurves);
    
    
    for i=1:length(systems)
        myCommand=['Channels=regexprep(ChanLists,''^([^\x3A]*)([\x3A])(' systems{i} ')$'',''$1'');'];
        eval(myCommand)
        if isempty(Channels)
        else
            [y,x,s,u,chs]=hl2adb(CurrentShot,Channels,systems{i});
            u = regexp(u, '^[^\s\o0]*','match','once');  %begin not space not null
            chs = regexp(chs, '^[^\s\o0]*','match','once');  %begin not space not null
            
            
            for CurrentIndex=1:length(chs)
                if isempty(y)
                    ShowWarning(CurrentShot,NickName,handles)
                    continue
                end
                Unit=u{CurrentIndex};
                
                
                
                CurrentSysName=systems{i};
                NickName=chs{CurrentIndex};
                CurrentChannel=chs{CurrentIndex};
                
                
                nMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel);
                c=AddNewCurve(x(:,1),y(:,CurrentIndex),num2str(CurrentShot),strcat(NickName),Unit);
                
                CurrentChannelNum=CurrentChannelNum+1;
                
                if CurrentChannelNum>1
                    if ~isempty(MyCurveList)
                        MyCurves(CurrentChannelNum)=c;
                        MyCurveList(CurrentChannelNum)={nMyCurveList};
                    end
                else
                    MyCurves=c;
                    MyCurveList={nMyCurveList};
                end
            end%CurrentIndex
        end %isempty
    end
    ChanLists=regexprep(ChanLists,'\x3A','\x5C');
    if ~isempty(system2) && length(system2)==3
        channelPattern=['(?<=\xD\xA)[^\x3A]*' addcurvename '[^\x3A]*[\x3A]' system2 '(?=\xD\xA)'];
        ChanLists2=regexpi(MyChanLists,channelPattern,'match');
        
        
        myCommand=['Channels=regexprep(ChanLists2,''^([^\x3A]*)([\x3A])(' system2 ')$'',''$1'');'];
        eval(myCommand)
        if isempty(Channels)
        else
            
            [y,x,s,u,chs]=hl2adb(CurrentShot,Channels,system2);
            u = regexp(u, '^[^\s\o0]*','match','once');  %begin not space not null
            chs = regexp(chs, '^[^\s\o0]*','match','once');  %begin not space not null
            
            
            for CurrentIndex=1:length(chs)
                if isempty(y)
                    ShowWarning(CurrentShot,NickName,handles)
                    continue
                end
                Unit=u{CurrentIndex};
                
                
                
                CurrentSysName=system2;
                NickName=chs{CurrentIndex};
                CurrentChannel=chs{CurrentIndex};
                
                
                nMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel);
                c=AddNewCurve(x(:,1),y(:,CurrentIndex),num2str(CurrentShot),strcat(NickName),Unit);
                
                CurrentChannelNum=CurrentChannelNum+1;
                
                if CurrentChannelNum>1
                    if ~isempty(MyCurveList)
                        MyCurves(CurrentChannelNum)=c;
                        MyCurveList(CurrentChannelNum)={nMyCurveList};
                    end
                else
                    MyCurves=c;
                    MyCurveList={nMyCurveList};
                end
            end%CurrentIndex
            ChanLists2=regexprep(ChanLists2,'\x3A','\x5C');
            ChanLists=[ChanLists ChanLists2];
        end %isempty
    end
    s=SetMyCurves(MyCurveList);
else
    ChanLists=regexprep(ChanLists,'\x3A','\x5C');
    if ~isempty(system2) && length(system2)==3
        channelPattern=['(?<=\xD\xA)[^\x3A]*' addcurvename '[^\x3A]*[\x3A]' system2 '(?=\xD\xA)'];
        ChanLists2=regexpi(MyChanLists,channelPattern,'match');
        ChanLists2=regexprep(ChanLists2,'\x3A','\x5C');
        ChanLists=[ChanLists ChanLists2];
    end
end
close(hwait);
ChanLists=ChanLists';
set(handles.lbChannels,'String',ChanLists);
set(handles.lbChannels,'Value',length(ChanLists));
set(handles.lbChannels,'UserData',[]); %del UserData


