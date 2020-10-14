function addChnlFromStruct(hObject, eventdata, handles)


global  MyPicStruct SmoothStatus isVIP
global MyCurves  %something wrong

ClearAll_Callback(hObject, eventdata, handles)
MyPicStruct=View2Struct(handles);
MyChannels=[];
MyCurves=[];
CurrentChannelNum=0;
% MyShot=get(handles.ShotNumber,'String');
% if iscell(MyShot)
%     MyShot=MyShot{get(handles.ShotNumber,'value')};
% end
% CurrentShot=str2num(MyShot);
%
% CurrentChannels=get(hObject,'String');
% CurrentSelectNum=get(hObject,'Value');
%
%
% if isempty(CurrentChannels) %click lbChannels by chance
%     return
% end
%
% CurrentChannels=deblank(CurrentChannels{CurrentSelectNum});
% CurrentChannel=CurrentChannels;
%
% ChannelIndex=0;









CurrentSysName=[];
CurrentShot=[];
Unit=[];

% d=getY;
% load('c:\myData')

MyShot1=get(handles.ShotNumber,'String');
if iscell(MyShot1)
    MyShot1=MyShot1{get(handles.ShotNumber,'value')};
end

if ~isempty(str2num(MyShot1))
    CurrentShot=str2num(MyShot1);
else
    CurrentShot=MyShot1;
end


MyPicStruct=View2Struct(handles);

range=[MyPicStruct.xleft MyPicStruct.xright];


cd('D:\Program Files\Matlab2010\work')
d=fast_plot(CurrentShot,range);
cd('c:\DataProc')


IndexStart=1;
IndexEnd=d.num;


for CurrentIndex=IndexStart:IndexEnd
    z=[];
    myCommand=['z=d.z' num2str(CurrentIndex) ';'];
    eval(myCommand)
    myCommand=['y=d.y' num2str(CurrentIndex) ';'];
    eval(myCommand)
    myCommand=['x=d.t' num2str(CurrentIndex) ';'];
    eval(myCommand)
    x=x';
    myCommand=['CurrentChannel=d.n' num2str(CurrentIndex) ';'];
    eval(myCommand)
    
    
    
    NickName=CurrentChannel;
    
    
    nMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel);
    
    if length(Unit)>1
        currentUnit=Unit(CurrentIndex);
    else
        currentUnit=Unit;
    end
    
    c=AddNewCurve(x,y,num2str(CurrentShot),CurrentChannel,currentUnit,z);
    
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
s=SetMyCurves(MyCurveList);
set(handles.tChannels,'BackgroundColor','g');



function d=getY


d.t1=(1:1000)';
d.y1=sin(d.t1);
d.n1='sin';
d.t2=(1:2:1000)';
d.y2=cos(d.t2);
d.n2='cos';