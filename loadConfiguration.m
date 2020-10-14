function loadConfiguration(hObject, eventdata, handles,varargin)
global  PicDescription  hOffset hfig moveMouseEvent

if nargin<4
    cd(getDProot('Channels'))
    [FileName,PathName]=uigetfile('*.mat',getDProot('Channels'),'Load the data file');
    cfgFile=strcat(PathName,FileName);
    cd(getDProot)
else
    cfgFile=varargin{1};
end
load(cfgFile);
setappdata(0,'cfgFile',cfgFile)





n=length(PicDescription);
hcfg=getappdata(hfig,'hcfg');

hCancel= hcfg.hCancel;
hAdd= hcfg.hAdd;
hShot= hcfg.hShot;
hExpand= hcfg.hExpand;
hOK= hcfg.hOK;
hPopup= hcfg.hPopup;
hModify= hcfg.hModify;



hCurves= hcfg.hCurves;
sBtn= hcfg.sBtn;
hfconfiguration= hcfg.hfconfiguration;

delete(hCurves)
hCurves=[];


scrsz = get(0,'ScreenSize');
set(hfconfiguration,'Units','pixels')
%set(gcf,'Position',[scrsz(1) scrsz(2)+50 scrsz(3)/1.1 scrsz(4)/1.2])
set(hfconfiguration,'Position',[scrsz(1) scrsz(2)+50 scrsz(3)/1.1 scrsz(4)/1.2])

sLabel=[{'Num'} {'YN'}           {'ChName'} {'Loc'}  {'Right'} {'Color'} {'Mkr'}  {'LineSty'} {'IntNum'} {'FraNum'} {'XOffset'} {'YOffset'} {'Factor'} {'Unit'} {'YAuto'} {'Stairs'}  {'Min'} {'Max'}];
sType=[{'text'} {'checkbox'}         {'edit'}   {'edit'} {'edit'}  {'edit'}  {'edit'} {'edit'}    {'edit'}   {'edit'}   {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'}];
wstep=scrsz(3)/25;
hstep=scrsz(4)/36;
[~,m]=size(sLabel);
for i=1:m
    dLeft(i)=(i-1)*wstep;
    dWidth(i)=wstep;
end
dWidth(2)=wstep/2;
dWidth(4)=wstep/2;
dWidth(5)=wstep/2;
dWidth(7)=wstep/2;
for i=(m-1):m
    dWidth(i)=wstep*2;
end


dLeft(3)=dLeft(3)-wstep/2;
dLeft(4)=dLeft(4)-wstep/2;
dLeft(5)=dLeft(5)-wstep;
dLeft(6)=dLeft(6)-wstep*3/2;
dLeft(7)=dLeft(7)-wstep*3/2;

for i=8:m  % for last 2
    dLeft(i)=dLeft(i)-wstep*2;
end
dLeft(m)=dLeft(m)+wstep;
hOffset=(n+2)*hstep;


set(hcfg.hModify ,    'Position',[dLeft(1) hOffset+3*hstep dWidth(1) scrsz(4)/40 ])
set(hcfg.hCurrentShot,    'Position',[dLeft(2) hOffset+3*hstep dWidth(2) scrsz(4)/40 ])
set(hcfg.hUp,    'Position',[dLeft(3) hOffset+3*hstep dWidth(3)/2 scrsz(4)/40 ])
set(hcfg.hDown,    'Position',[dLeft(3)+dWidth(3)/2 hOffset+3*hstep dWidth(3)/2 scrsz(4)/40 ])



set(hCancel,    'Position',[dLeft(1) hOffset+2*hstep dWidth(1) scrsz(4)/40 ])
set(hAdd,    'Position',[dLeft(2) hOffset+2*hstep dWidth(2) scrsz(4)/40 ])

sShots=get(handles.ShotNumber,'String');
if iscell(sShots)
    CurrentShot=str2num(sShots{get(handles.ShotNumber,'value')});
else
    CurrentShot=str2num(sShots);
end
set(hShot ,    'Position',[dLeft(3) hOffset+2*hstep sum(dWidth(3)) scrsz(4)/40 ])

set(hExpand ,'Position',[dLeft(1) hOffset+hstep dWidth(1) scrsz(4)/40 ])
set(hOK,'Position',[dLeft(2) hOffset+hstep dWidth(2) scrsz(4)/40 ])

set(hPopup,'Position',[dLeft(3) hOffset+hstep dWidth(3) scrsz(4)/40 ])
for i=1:m
	set(sBtn(i),'Position',[dLeft(i) hOffset dWidth(i) scrsz(4)/40 ])
end



for j=1:n
    index=1;
    sLabel{index}=num2str(j);
    index=index+1;
    sLabel{index}='';
    
    index=index+1;
    sLabel{index}=PicDescription(j).ChnlName;
    
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).Location);
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).Right);
    index=index+1;
    if length(PicDescription(j).Color)==3
        myColor=PicDescription(j).Color;
        sLabel{index}=[num2str(myColor(1)),' ',num2str(myColor(2)),' ',num2str(myColor(3))];
    else
        sLabel{index}=PicDescription(j).Color;
    end
    
    
    
    index=index+1;
    sLabel{index}=PicDescription(j).Marker;
    index=index+1;
    sLabel{index}=PicDescription(j).LineStyle;
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).LeftDigit);
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).RightDigit);
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).XOffset);
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).YOffset);
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).Factor);
    index=index+1;
    sLabel{index}=PicDescription(j).Unit;
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).YLimitAuto);
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).IsStairs);
    
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).yMin);
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).yMax);
    
  firstcheck=1;  
  for i=1:m
      hCurves(j,i) = uicontrol('Parent',hfconfiguration,...
          'style', sType{i},...
          'Position',[dLeft(i) -j*hstep+hOffset dWidth(i) scrsz(4)/40 ],...  %hOffset move it upward
          'String', sLabel{i});
      if firstcheck==1
          if strcmp(get(hCurves(j,i),'style'),'checkbox')
              set(hCurves(j,i),'Value',PicDescription(j).YLimitAuto)
            firstcheck=0; 
          end
      else
          if strcmp(get(hCurves(j,i),'style'),'checkbox')
              set(hCurves(j,i),'Value',PicDescription(j).IsStairs)
          end
      end
  end
end
% show default channel name
set(hCurves(:,3),'CallBack',{@showDef,handles})
hcfg.hCurves= hCurves;
setappdata(hfig,'hcfg',hcfg)
set(hCurves(:,4:end),{'visible'},{'off'})
set(sBtn(4:end),{'visible'},{'off'})

marginHeight=5;
set(hfconfiguration,'Position',[scrsz(1)-sum(dWidth(1:3))/0.8 scrsz(2)+50 sum(dWidth(1:3)) hOffset+marginHeight*hstep])
setappdata(hfconfiguration,'size0',[scrsz(1)-sum(dWidth(1:3))/0.8 scrsz(2)+50 sum(dWidth(1:3)) hOffset+marginHeight*hstep])
setappdata(hfconfiguration,'size1',[scrsz(1) scrsz(2)+50 sum(dWidth(1:3)) hOffset+marginHeight*hstep])
setappdata(hfconfiguration,'size2',[scrsz(1) scrsz(2)+50 sum(dWidth(:)) hOffset+marginHeight*hstep])


moveMouseEvent=0;