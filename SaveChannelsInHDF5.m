function SaveChannelsInHDF5(hObject, eventdata, handles)
%%
%prepare channel for saving to HDF5 file
%%
global MyCurves  h5file %something wrong

%input the function name
h5file=[];
dlg_title = 'input your parameters for saving the data into HDF5';
prompt = {'shotnumber','total number'};
def   = {'20000','1'};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
CurrentShot1=str2double(answer{1});
TotalNumber=str2double(answer{2});

%update the channel names
% y=setSystemName(CurrentShot1,1);


MyChannelList=get(handles.lbCurves,'String');
systemPattern='[^\x5C]{3}(?=[\x5C])';


systems=regexpi(MyChannelList,systemPattern,'match','once');
systems = unique(systems);

myShotNumber=str2num(get(handles.ShotNumber,'String'));
CurrentShot=CurrentShot1;
hwait=waitbar(0.5/(TotalNumber),'please wait for Processing DATA...');
if myShotNumber==CurrentShot
else
    CurrentChannelNum=0;
    for i=1:length(systems)
        if isempty(systems{i})
        elseif length(systems{i})==3
            myCommand=['Channels=regexp(MyChannelList,''(?<=' systems{i} '[\x5C])[^\x5C]*$'' ,''match'',''once'');'];
            eval(myCommand)
            index=~cellfun(@isempty,Channels);
            Channels=Channels(index);
            
            if length(Channels)==0
                break;
            elseif length(Channels)==1
                if iscell(Channels)
                    Channels=Channels{1};
                end
            end
            
            [y,x,s,u,chs]=hl2adb(CurrentShot,Channels,systems{i});
            u = regexp(u, '^[^\s\o0]*','match','once');  %begin not space not null
            chs = regexp(chs, '^[^\s\o0]*','match','once');  %begin not space not null
        end
        %%
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
        %%
    end
end

set(handles.ShotNumber,'String',num2str(CurrentShot));
s=SaveInHDF5(hObject,eventdata,handles);


if TotalNumber>1
    for CurrentShot=CurrentShot1+1:CurrentShot1+TotalNumber-1
        waitbar((CurrentShot-CurrentShot1+0.5)/(TotalNumber));
        CurrentChannelNum=0;
        for i=1:length(systems)
            if isempty(systems{i})
            elseif length(systems{i})==3
                myCommand=['Channels=regexp(MyChannelList,''(?<=' systems{i} '[\x5C])[^\x5C]*$'' ,''match'',''once'');'];
                eval(myCommand)
                index=~cellfun(@isempty,Channels);
                Channels=Channels(index);
                
                if length(Channels)==0
                    break;
                elseif length(Channels)==1
                    if iscell(Channels)
                        Channels=Channels{1};
                    end
                end
                
                [y,x,s,u,chs]=hl2adb(CurrentShot,Channels,systems{i});
                u = regexp(u, '^[^\s\o0]*','match','once');  %begin not space not null
                chs = regexp(chs, '^[^\s\o0]*','match','once');  %begin not space not null
            end
            %%
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
            %%
        end
        set(handles.ShotNumber,'String',num2str(CurrentShot));
        s=SaveInHDF5(hObject,eventdata,handles);
    end
    
    s=SetMyCurves(MyCurveList);
end %>1
close(hwait);
end

