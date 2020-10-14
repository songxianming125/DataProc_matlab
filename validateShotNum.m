function iShotNumber= validateShotNum( iShotNum )
%% developed by Dr. SONG Xianming

% tic
% profile on
scrsz = get(0,'ScreenSize');
hfig=figure('visible','off');

hOffset=0;
n=1;
hfconfiguration=hfig;
set(hfconfiguration,'Units','pixels','name','validate shotnumber')
set(hfconfiguration,'Position',[scrsz(1)+scrsz(3)/2 scrsz(2)+50+scrsz(4)/1.2 scrsz(3)/2 scrsz(4)/1.2])

sLabel=[{'shotnumber'} ];
sType=[{'edit'}];
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
for i=1:m
    dWidth(i)=wstep*2;
end


hOffset=(n+1)*hstep;




hMinusOne = uicontrol('Parent',hfconfiguration,...
    'style','pushbutton',...
    'Position',[dLeft(1) hOffset+1*hstep dWidth(1)/2 scrsz(4)/40 ],...
    'String', '-',...
    'CallBack',{@MinusOne,hfig});

hShotNum = uicontrol('Parent',hfconfiguration,...
          'style', sType{i},...
          'visible','on',...
          'Position',[dLeft(i)+dWidth(1)/2 hOffset+1*hstep dWidth(i) scrsz(4)/40 ],...  %hOffset move it upward
          'String', num2str(iShotNum));


hAddOne = uicontrol('Parent',hfconfiguration,...
    'style','pushbutton',...
    'Position',[dLeft(1)+dWidth(1)*3/2 hOffset+1*hstep dWidth(1)/2 scrsz(4)/40 ],...
    'String', '+',...
    'CallBack',{@AddOne,hfig});


hOK = uicontrol('Parent',hfconfiguration,...
    'style','pushbutton',...
    'Position',[dLeft(1)+dWidth(1)/2 -hstep+hOffset dWidth(1) scrsz(4)/40 ],...
    'String', 'OK',...
    'CallBack',{@validate,hfig}); % this func for one shot





hcfg.hfig= hfig;

hcfg.hMinusOne= hMinusOne;
hcfg.hAddOne= hAddOne;
hcfg.hOK= hOK;
hcfg.hShotNum= hShotNum;
setappdata(0,'hcfg',hcfg)

marginHeight=3;
set(hfconfiguration,'Position',[scrsz(1)+20 scrsz(2)-10 sum(dWidth(:))-30 hOffset+marginHeight*hstep])
set(hfig,'Position',[scrsz(1)+scrsz(3)/3 scrsz(2)+50+scrsz(4)/3 sum(dWidth(:))+10 hOffset+marginHeight*hstep],'visible','on','MenuBar','none')
drawnow expose

uiwait(gcf)
iShotNumber=getappdata(0,'iShotNumber');



% profile viewer
% td=toc

function MinusOne(hObject, eventdata, hfig)
hcfg=getappdata(0,'hcfg');
iShotNum=str2num(get(hcfg.hShotNum,'string'));
iShotNum=iShotNum-1;
set(hcfg.hShotNum,'string',num2str(iShotNum))



function AddOne(hObject, eventdata, hfig)

hcfg=getappdata(0,'hcfg');
iShotNum=str2num(get(hcfg.hShotNum,'string'));
iShotNum=iShotNum+1;
set(hcfg.hShotNum,'string',num2str(iShotNum))

function validate(hObject, eventdata, hfig)

%% set the shotnumber
% OK
hcfg=getappdata(0,'hcfg');
iShotNum=str2num(get(hcfg.hShotNum,'string'));
setappdata(0,'iShotNumber',iShotNum)
delete(gcf)
return




