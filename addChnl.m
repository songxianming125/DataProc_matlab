function addChnl(hObject, eventdata, handles)
% add channel or curve, can support 3 dimension data

global  MyPicStruct
global MyCurves 


MyPicStruct=View2Struct(handles);

MyCurveList=get(handles.lbCurves,'String');%curve list


if isempty(MyCurveList)
    MyCurves=[];
end

n=length(MyCurves);%
CurrentChannelNum=n;



MyShot=get(handles.ShotNumber,'String');
if iscell(MyShot)
    MyShot=MyShot{get(handles.ShotNumber,'value')};
end


CurrentShot=str2double(MyShot);
CurrentSysName=[];
Unit=[];



myCommand=['x=eventdata.x;'];
eval(myCommand)
myCommand=['y=eventdata.y;'];
eval(myCommand)
myCommand=['z=eventdata.z;'];
eval(myCommand)
myCommand=['CurrentChannel=eventdata.n;'];
eval(myCommand)
myCommand=['CurrentSysName=eventdata.s;'];
eval(myCommand)
myCommand=['Unit=eventdata.u;'];
eval(myCommand)



nMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel);

if length(Unit)>1
    currentUnit=Unit;
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

s=SetMyCurves(MyCurveList);


