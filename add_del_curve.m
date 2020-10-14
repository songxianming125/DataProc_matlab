
% --------------------------------------------------------------------
function s=add_del_curve(~, ~,handles,addordelmode)
global   hOffset indexLoc MyCurves
global   Axes2Lines  Loc2Axes  PicDescription   



   hOffset=0;
[~,n]=size(MyCurves);
%hfig=gcf;
%Save the YLim Data in the Configuration.txt file or Use the Data in the Configuration.txt file as the YLim data
hfconfiguration=figure('Color', 'k','Name','configuration','DefaultTextColor','w');
scrsz = get(0,'ScreenSize');



set(gcf,'Units','pixels')
%set(gcf,'Position',[scrsz(1) scrsz(2)+50 scrsz(3)/1.1 scrsz(4)/1.2])
set(gcf,'Position',[scrsz(1) scrsz(2)+50 scrsz(3)/1.1 scrsz(4)/1.2])

sLabel=[{'Num'}  {'Loc'} {'Right'} {'Color'} {'Mkr'} {'LineSty'} {'IntNum'} {'FraNum'} {'XOffset'} {'YOffset'} {'Factor'} {'Unit'} {'YAuto'} {'Stairs'} {'ChName'} {'Min'} {'Max'}];
sType=[{'text'}  {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'}];
wstep=scrsz(3)/25;
hstep=scrsz(4)/36;
[~,m]=size(sLabel);
for i=1:m
    dLeft(i)=(i-0.5)*wstep;
    dWidth(i)=wstep;
end
dWidth(3)=wstep/2;
dWidth(4)=wstep*2;
dWidth(5)=wstep/2;
for i=(m-2):m
    dWidth(i)=wstep*2;
end

for i=1:2
    dLeft(m-2+i)=dLeft(m-1)+wstep*i;
end
dLeft(4)=dLeft(4)-wstep/2;
dLeft(5)=dLeft(5)+wstep/2;

for i=1:m
    sBtn(i) = uicontrol(gcf,...
                 'style', 'text',...
                 'Position',[dLeft(i) scrsz(4)/1.5+hOffset dWidth(i) scrsz(4)/40 ],...
                 'String', sLabel{i});
end



%% get the curves in current axes, only for the left axes.
indexAxes=cell2mat(Loc2Axes(indexLoc));
indexLines=cell2mat(Axes2Lines(indexAxes(1)));

for j=1:length(indexLines)
    indexLine=indexLines(j);
    index=1;
    sLabel{index}=num2str(j);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).Location);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).Right);
    index=index+1;
    if length(PicDescription(indexLine).Color)==3
        myColor=PicDescription(indexLine).Color;
        sLabel{index}=[num2str(myColor(1)),' ',num2str(myColor(2)),' ',num2str(myColor(3))];
    else
        sLabel{index}=PicDescription(indexLine).Color;
    end
    
    
    
    index=index+1;
    sLabel{index}=PicDescription(indexLine).Marker;
    index=index+1;
    sLabel{index}=PicDescription(indexLine).LineStyle;
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).LeftDigit);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).RightDigit);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).XOffset);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).YOffset);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).Factor);
    index=index+1;
    sLabel{index}=PicDescription(indexLine).Unit;
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).YLimitAuto);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).IsStairs);
    
    index=index+1;
    sLabel{index}=PicDescription(indexLine).ChnlName;
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).yMin);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).yMax);
    
  firstcheck=1;  
  for i=1:m
      hCurves(j,i) = uicontrol(gcf,...
          'style', sType{i},...
          'Position',[dLeft(i) scrsz(4)/1.5-j*hstep+hOffset dWidth(i) scrsz(4)/40 ],...  %hOffset move it upward
          'String', sLabel{i},...
          'Enable','off');
      if firstcheck==1
          if strcmp(get(hCurves(j,i),'style'),'checkbox')
              set(hCurves(j,i),'Value',PicDescription(indexLine).YLimitAuto)
            firstcheck=0; 
          end
      else
          if strcmp(get(hCurves(j,i),'style'),'checkbox')
              set(hCurves(j,i),'Value',PicDescription(indexLine).IsStairs)
          end
      end
  end
  %set(sBtnp(4),'String', {sLabel{4},sLabel{4},sLabel{4}})
end
for j=length(indexLines)+1 % one more index
    indexLine=indexLines(j-1);
    index=1;
    sLabel{index}=num2str(j); 
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).Location);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).Right);
    index=index+1;
    if length(PicDescription(indexLine).Color)==3
        myColor=PicDescription(indexLine).Color;
        sLabel{index}=[num2str(myColor(1)),' ',num2str(myColor(2)),' ',num2str(myColor(3))];
    else
        sLabel{index}=PicDescription(indexLine).Color;
    end
    
    
    
    index=index+1;
    sLabel{index}=PicDescription(indexLine).Marker;
    index=index+1;
    sLabel{index}=PicDescription(indexLine).LineStyle;
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).LeftDigit);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).RightDigit);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).XOffset);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).YOffset);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).Factor);
    index=index+1;
    sLabel{index}=PicDescription(indexLine).Unit;
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).YLimitAuto);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).IsStairs);
    
    index=index+1;
    sLabel{index}='newChannel';
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).yMin);
    index=index+1;
    sLabel{index}=num2str(PicDescription(indexLine).yMax);
    
  firstcheck=1;  
  for i=1:m
      hCurves(j,i) = uicontrol(gcf,...
          'style', sType{i},...
          'Position',[dLeft(i) scrsz(4)/1.5-j*hstep+hOffset dWidth(i) scrsz(4)/40 ],...  %hOffset move it upward
          'String', sLabel{i},...
          'ForegroundColor','r');
      if firstcheck==1
          if strcmp(get(hCurves(j,i),'style'),'checkbox')
              set(hCurves(j,i),'Value',PicDescription(indexLine).YLimitAuto)
            firstcheck=0; 
          end
      else
          if strcmp(get(hCurves(j,i),'style'),'checkbox')
              set(hCurves(j,i),'Value',PicDescription(indexLine).IsStairs)
          end
      end
  end
  %set(sBtnp(4),'String', {sLabel{4},sLabel{4},sLabel{4}})
end

set(hCurves(end,15),'CallBack',{@showDef,handles})

sBtnOK = uicontrol(gcf,...
                 'style', 'pushbutton',...
                 'Position',[dLeft(17) scrsz(4)/1.3 dWidth(8) scrsz(4)/40 ],...
                 'String', 'OK',...
                 'CallBack',{@addOneCurve,handles});
             
hPopup = uicontrol(gcf,...
                 'style', 'popupmenu',...
                 'Position',[dLeft(15) scrsz(4)/1.3 2*dWidth(8) scrsz(4)/40 ],...
                 'String', 'default|channel',...
                 'CallBack',{@setChanName,handles});
             
hcfg.hCurves= hCurves;
hcfg.hPopup= hPopup;
hcfg.hfconfiguration= hfconfiguration;
setappdata(0,'hcfg',hcfg)

s=1;
% --------------------------------------------------------------------



function addOneCurve(hObject, eventdata, handles)
global MyPicStruct indexLoc ha

global  Lines2Axes Axes2Lines  Loc2Axes  PicDescription MyCurves LocationLeftRight 


hcfg=getappdata(0,'hcfg');
hCurves=hcfg.hCurves;

%% get the current channel
hChanName=hCurves(end,15);
CurrentChannel=get(hChanName,'String');
if iscell(CurrentChannel)
    CurrentChannel=CurrentChannel{1};
end

%% get current shot
sShots=get(handles.ShotNumber,'String');
if iscell(sShots)
    CurrentShot=str2num(sShots{get(handles.ShotNumber,'value')});
else
    CurrentShot=str2num(sShots);
end

DataFlag=0; % get data from database


%% get 
    MyCurveList=get(handles.lbCurves,'String');

    
%% prepare the parameters

[y,x,CurrentSysName,Unit,CurrentChannel,z]=GetNewCurve4Add(CurrentShot,CurrentChannel,DataFlag);%for more channels

if iscell(Unit)
    Unit=Unit{1};
end
if iscell(CurrentChannel)
    CurrentChannel=CurrentChannel{1};
end



currentUnit=Unit;
nMyCurveList=strcat(num2str(CurrentShot),CurrentSysName,'\',CurrentChannel);
c=AddNewCurve(x,y,num2str(CurrentShot),CurrentChannel,currentUnit,z);

MyCurves(end+1)=c;
MyCurveList(end+1)={nMyCurveList};
i=length(MyCurves);  % the last line
indexAxes=cell2mat(Loc2Axes(indexLoc));
indexLines=cell2mat(Axes2Lines(indexAxes(1)));


Lines2Axes(i)=Lines2Axes(indexLines);
Axes2Lines(indexAxes(1))={[Axes2Lines{indexAxes(1)} i]};

index=2;
PicDescription(i).Location=str2num(get(hCurves(end,2),'String')); %%build up the initial PictureArrangement
Location(i)=PicDescription(i).Location;
index=index+1;
PicDescription(i).Right=str2num(get(hCurves(end,index),'String'));
index=index+1;
myColor=get(hCurves(end,index),'String');
[cm,cn]=size(myColor);
if cn>1
    format='%e';
    [C(1:3),count,errs]=sscanf(myColor,format);
else
    C=myColor;
end
PicDescription(i).Color=C;
index=index+1;
PicDescription(i).Marker=get(hCurves(end,index),'String');
index=index+1;
PicDescription(i).LineStyle=get(hCurves(end,index),'String');
index=index+1;
PicDescription(i).LeftDigit=str2num(get(hCurves(end,index),'String'));
index=index+1;
PicDescription(i).RightDigit=str2num(get(hCurves(end,index),'String'));

index=index+1;
PicDescription(i).XOffset=str2num(get(hCurves(end,index),'String'));
index=index+1;
PicDescription(i).YOffset=str2num(get(hCurves(end,index),'String'));
index=index+1;
PicDescription(i).Factor=str2num(get(hCurves(end,index),'String'));

index=index+1;
PicDescription(i).Unit=get(hCurves(end,index),'String');
index=index+1;
%     PicDescription(i).YLimitAuto=get(hCurves(end,index),'Value');
PicDescription(i).YLimitAuto=str2num(get(hCurves(end,index),'String'));
index=index+1;
%     PicDescription(i).IsStairs=get(hCurves(end,index),'Value');
PicDescription(i).IsStairs=str2num(get(hCurves(end,index),'String'));
index=index+1;
ChnlName=get(hCurves(end,index),'String');
if iscell(ChnlName)
    ChnlName=ChnlName{1};
end

PicDescription(i).ChnlName=ChnlName;
index=index+1;
PicDescription(i).yMin=str2num(get(hCurves(end,index),'String'));
index=index+1;
PicDescription(i).yMax=str2num(get(hCurves(end,index),'String'));


hLines(i)=line('Parent',ha(indexAxes(1)),'Color',PicDescription(i).Color,'Marker',PicDescription(i).Marker,'LineStyle',PicDescription(i).LineStyle,'LineWidth',MyPicStruct.DefaultAxesLineWidth,...
                            'DisplayName',PicDescription(i).ChnlName,'XData',x,'YData',y);


s=SetMyCurves(MyCurveList);
delete(gcf)


function showDef(hObject, eventdata, handles)
global MyChanLists
hcfg=getappdata(0,'hcfg');
hCurves=hcfg.hCurves;
hPopup= hcfg.hPopup;

%hfig=hcfg.hfig;

%% get the channel name
hChanName=hCurves(end,15);
namePattern=get(hChanName,'String');




%% prepare the namelist
if isempty(MyChanLists)
    sShots=get(handles.ShotNumber,'String');
    if iscell(sShots)
        CurrentShot=str2num(sShots{get(handles.ShotNumber,'value')});
    else
        CurrentShot=str2num(sShots);
    end
    y=setSystemName(CurrentShot,1);
end


%% find the possible match channel

% change .* to \w* for Any alphabetic, numeric, or underscore character
namePattern=regexprep(namePattern,'\.','\\w');

%     channelPattern=['(?<=\xD\xA)[^\x3A]*' addcurvename '[^\x3A]*(?=\x3A)'];
%  \xD=13   \xA=10  \x3A=':'  \x5C='\'
channelPattern=['(?<=\xD\xA)[^\x3A]*' namePattern '[^\x3A]*(?=\x3A[a-zA-Z]{3}\xD\xA)'];
ChanLists=regexpi(MyChanLists,channelPattern,'match');
ChanLists=regexprep(ChanLists,'\x3A','\x5C');


%%

%add the curves from GetCurveByFormula
CurveNames=GetCurveNames;
patternname=['.\w*',namePattern, '.*'];
%     sNames=cellfun(@regexpi,CurveNames,patternname,'match','once');

sNames = regexpi(CurveNames, patternname, 'match','once');
index=~cellfun(@isempty,sNames);
Names=sNames(index);
ChanLists=[ChanLists'; Names];

set(hPopup,'string',ChanLists)
uicontrol(hPopup)

function setChanName(hObject, eventdata, handles)
hcfg=getappdata(0,'hcfg');
hCurves=hcfg.hCurves;
index=get(hObject,'value');
ChanLists=get(hObject,'string');
ChanName=ChanLists(index);


%% get the channel name
hChanName=hCurves(end,15);


set(hChanName,'String',ChanName);

