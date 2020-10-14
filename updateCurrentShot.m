function s=updateCurrentShot(hObject, eventdata,handles)
global MyCurves NumShot moveMouseEvent PicDescription
% set the total shot number for comparing
% press enter in shot edit control


signOfShotNumber=1;
CancelMod([], [], handles)

myStr=get(hObject,'string');
% parse the string
if isempty(myStr); return;end;

if strcmp(myStr(1),'+')
    myStr(1)=[];
    if isempty(myStr); return;end;
    NumShot=NumShot+1;
elseif strcmp(myStr(1),'-')
    myStr(1)=[];
    signOfShotNumber=-1;

    PicDescription=[];
    MyCurves=[];
    NumShot=1;
else
    PicDescription=[];
    MyCurves=[];
    NumShot=1;
end


% make sure at most 2 '+', one is removed
k=regexp(myStr,'[\+\-]');

if ~isempty(k)
   MyShot= myStr(1:k(1)-1);
   if isempty(str2num(myStr(1+k(1))))
       cmpShotNum=myStr(2+k(1):end);
       cmpShotNum=str2num(cmpShotNum);
   else
       cmpShotNum=myStr(k(1):end);
       cmpShotNum=str2num(cmpShotNum);
   end
else
   MyShot= myStr(1:end);
   cmpShotNum=0;
end




if str2num(MyShot)*signOfShotNumber<1
    % relative shot to lastshot
    nShot=GetLastestShot+str2num(MyShot)*signOfShotNumber;
else
    nShot=str2num(MyShot);
end

if cmpShotNum>0
    if cmpShotNum>10000
        CurrentShots=[nShot,cmpShotNum];
        NumShot=NumShot+1;
    else
        CurrentShots=nShot:nShot+cmpShotNum;
        NumShot=NumShot+abs(cmpShotNum);
    end
elseif cmpShotNum<0
    CurrentShots=nShot:-1:nShot+cmpShotNum;
    NumShot=NumShot+abs(cmpShotNum);
else
    CurrentShots=nShot;
end


if NumShot<2
    set(handles.LayoutMode,'value',1) % last for comparieng ;defining the mode from 0 to 7
else
    set(handles.LayoutMode,'value',length(get(handles.LayoutMode,'String'))) % last for comparieng ;defining the mode from 0 to 7
end

hcfg=getappdata(gcf,'hcfg');
hCurves=hcfg.hCurves;
sBtn=hcfg.sBtn;
hfconfiguration=hcfg.hfconfiguration;


set(hfconfiguration,'Position',getappdata(hfconfiguration,'size0'))
set(hCurves(:,4:end),{'visible'},{'off'})
set(sBtn(4:end),{'visible'},{'off'})
moveMouseEvent=0;
% keep the channel sequence the same.
%  get the shotnumber
 PicDescription=getPicDescription(hCurves);

% update MyCurveList


if isempty(MyCurves)
    MyCurveList=[];
    % MyCurveList={PicDescription(:).ChnlName};
    set(handles.lbCurves,'String',MyCurveList);
    set(handles.lbCurves,'Value',1);%
end

set(hcfg.hModify,'enable','on')

setCurvesForShots(handles,CurrentShots)
DrawCurves_Callback(handles.DrawCurves, eventdata, handles)
s=1;
