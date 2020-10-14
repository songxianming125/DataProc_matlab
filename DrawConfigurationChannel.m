function MyCurveList=DrawConfigurationChannel(MyCurveList, handles)

% tic
% profile on
scrsz = get(0,'ScreenSize');

hfig=figure('visible','off');

hOffset=0;
n=length(MyCurveList);
% hfconfiguration=uipanel('Parent',hfig,'visible','on','Title','Channels','FontSize',12, 'BackgroundColor','k','DeleteFcn',{@exitPanel,handles});
hfconfiguration=hfig;
set(hfconfiguration,'Units','pixels')
%set(gcf,'Position',[scrsz(1) scrsz(2)+50 scrsz(3)/1.1 scrsz(4)/1.2])
set(hfconfiguration,'Position',[scrsz(1) scrsz(2)+50 scrsz(3)/2 scrsz(4)/1.2])

% sLabel=[{'Num'} {'YN'}           {'ChName'} {'Loc'}  {'Right'} {'Color'} {'Mkr'}  {'LineSty'} {'IntNum'} {'FraNum'} {'XOffset'} {'YOffset'} {'Factor'} {'Unit'} {'YAuto'} {'Stairs'}  {'Min'} {'Max'}];
% sType=[{'text'} {'checkbox'}         {'edit'}   {'edit'} {'edit'}  {'edit'}  {'edit'} {'edit'}    {'edit'}   {'edit'}   {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'}];
sLabel=[{'Num'} {'All+Clear'} {'ChName'} ];
sType=[{'text'} {'checkbox'}  {'edit'}];
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


hOffset=(n+1)*hstep;




hCancel = uicontrol('Parent',hfconfiguration,...
    'style','pushbutton',...
    'Position',[dLeft(1) hOffset+1*hstep dWidth(1) scrsz(4)/40 ],...
    'String', 'Cancel',...
    'CallBack',{@CancelMod,handles});

hAdd = uicontrol('Parent',hfconfiguration,...
    'style','pushbutton',...
    'Position',[dLeft(3)-dWidth(2)/4 hOffset+1*hstep dWidth(2)/4 scrsz(4)/40 ],...
    'String', '+add',...
    'CallBack',{@AddOneChannel,handles,hstep});


hOK = uicontrol('Parent',hfconfiguration,...
    'style','pushbutton',...
    'Position',[dLeft(2) hOffset+1*hstep dWidth(2)/4 scrsz(4)/40 ],...
    'String', 'OK',...
    'CallBack',{@updateChannels,handles}); % this func for one shot

%tip for channels
hPopup = uicontrol('Parent',hfconfiguration,...
    'style','popupmenu',...
    'Position',[dLeft(3) hOffset+hstep dWidth(3) scrsz(4)/40 ],...
    'String', 'default|channel',...
    'CallBack',{@setChanName,handles});


for i=1:m
    if i==2
        sBtn(i) = uicontrol('Parent',hfconfiguration,...
            'style', 'togglebutton',...
            'visible','on',...
            'Position',[dLeft(i) hOffset dWidth(i)/2 scrsz(4)/40 ],...
            'String', sLabel{i},...
            'CallBack',{@setCheckBox,handles});
    else
        sBtn(i) = uicontrol('Parent',hfconfiguration,...
            'style', 'text',...
            'visible','on',...
            'Position',[dLeft(i) hOffset dWidth(i) scrsz(4)/40 ],...
            'String', sLabel{i});
    end
end



for j=1:n
    index=1;
    sLabel{index}=num2str(j);
    index=index+1;
    sLabel{index}='';
    
    index=index+1;
    sLabel{index}=MyCurveList{j};
    

  for i=1:m
      hCurves(j,i) = uicontrol('Parent',hfconfiguration,...
          'style', sType{i},...
          'visible','on',...
          'Position',[dLeft(i) -j*hstep+hOffset dWidth(i) scrsz(4)/40 ],...  %hOffset move it upward
          'String', sLabel{i});
      if strcmp(get(hCurves(j,i),'style'),'checkbox')
          set(hCurves(j,i),'Value',1)
      end
  end
end
hcfg.hfig= hfig;
hcfg.sBtn= sBtn;

hcfg.hPopup= hPopup;

hcfg.hCancel= hCancel;
hcfg.hAdd= hAdd;
hcfg.hOK= hOK;
hcfg.hCurves= hCurves;

hcfg.hfconfiguration= hfconfiguration;
setappdata(0,'hcfg',hcfg)
% 
set(hCurves(:,1:3),{'visible'},{'on'})
% for tip of channels
set(hCurves(:,3),'CallBack',{@showDef,handles})

marginHeight=3;
set(hfconfiguration,'Position',[scrsz(1)+20 scrsz(2)-10 sum(dWidth(1:3))-30 hOffset+marginHeight*hstep])
set(hfig,'Position',[scrsz(1)+30 scrsz(2)+50 sum(dWidth(1:3))+10 hOffset+marginHeight*hstep],'visible','on','MenuBar','none')
drawnow expose

uiwait(gcf)
MyCurveList=getappdata(0,'configurationChannel');



% profile viewer
% td=toc

function setCheckBox(hObject, eventdata, handles)
hcfg=getappdata(0,'hcfg');
hCurves=hcfg.hCurves;
hCheckBox=hCurves(:,2);
value=get(hCheckBox,'value');
if iscell(value)
    myValue=cellfun(@(x) ~x,value);
    value=mat2cell(myValue, linspace(1,1,length(hCheckBox)), 1);
    set(hCheckBox,{'value'},value);
else
    value=~value;
    set(hCheckBox,'value',value);
end
function AddOneChannel(hObject, eventdata, handles,hstep)

sType=[{'text'} {'checkbox'}   {'edit'}   ];

hcfg=getappdata(0,'hcfg');
hCurves=hcfg.hCurves;
hfconfiguration= hcfg.hfconfiguration;


j=size(hCurves,1)+1;
position=get(hCurves(j-1,:),'position');


if iscell(position)
    position=cell2mat(position);
else
end




    index=1;
    sLabel{index}=num2str(j);
    index=index+1;
    sLabel{index}='';
    
    index=index+1;
    sLabel{index}=get(hCurves(end,3),'string');
    
   
  m=size(hCurves,2);
  for i=1:m
      hCurves(j,i) = uicontrol('Parent',hfconfiguration,...
          'style', sType{i},...
          'Position',position(i,:)-[0 hstep 0 0],...  %hOffset move it upward
          'String', sLabel{i});
  end
  

  for i=1:size(hCurves,1)
      for j=1:size(hCurves,2)
          position=get(hCurves(i,j),'position');
          position(2)=position(2)+hstep;
          set(hCurves(i,j),'position',position);
      end
  end
  

  
  position=get(hcfg.hPopup,'position');
  position(2)=position(2)+hstep;
  set(hcfg.hPopup,'position',position);
  position=get(hcfg.hCancel,'position');
  position(2)=position(2)+hstep;
  set(hcfg.hCancel,'position',position);
  
  position=get(hcfg.hAdd,'position');
  position(2)=position(2)+hstep;
  set(hcfg.hAdd,'position',position);
  position=get(hcfg.hOK,'position');
  position(2)=position(2)+hstep;
  set(hcfg.hOK,'position',position);
  

  position=get(hcfg.hfconfiguration,'position');

%   position(4)=position(4)+hstep;
%   set(hcfg.hfconfiguration,'position',position);
  position=get(hcfg.hfig,'position');
  position(4)=position(4)+hstep;
  set(hcfg.hfig,'position',position);
  sBtn=hcfg.sBtn;
  
  for i=1:length(sBtn)
      position=get(sBtn(i),'position');
      position(2)=position(2)+hstep;
      set(sBtn(i),'position',position);
      
  end
 

  

% update data
set(hCurves(:,3),'CallBack',{@showDef,handles})
hcfg.hCurves= hCurves;
setappdata(0,'hcfg',hcfg)

function updateChannels(hObject, eventdata, handles)

%% after you have selected the channels of interest, the updated the pic
% OK


hcfg=getappdata(0,'hcfg');
hCurves=hcfg.hCurves;
hCheckBox=hCurves(:,2);
hChnl=hCurves(:,3);
value=get(hCheckBox,'value');
chnlName=get(hChnl,'string');

if iscell(value)
    MyCurveList=chnlName(cellfun(@(x) logical(x),value));
else
    if logical(value)
        MyCurveList=chnlName;
    else
        MyCurveList=[];
    end
end

setappdata(0,'configurationChannel',MyCurveList)


delete(gcf)
return




