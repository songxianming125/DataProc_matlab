function s=myAddShadow(hObject, eventdata,handles,mode)
global hfig MyPicStruct



if mode
    dlg_title = 'Add a Shadow';
    prompt = {'ShadowColor','MyTransparencyValue 1=n 0=y','start=0','end=10'};
    def     = {MyPicStruct.LeftShadowColor,num2str(MyPicStruct.MyTransparencyValue),num2str(MyPicStruct.xleft),num2str(MyPicStruct.xright)};
    num_lines= 1;
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    ShadowColor=answer{1};
    ShadowTransparencyValue=str2double(answer{2}); %#ok<*ST2NM>
    
    
    ShadowLeft=str2double(answer{3});
    ShadowLeft1=str2double(answer{4});
else
    dlg_title = 'Add a Shadow';
    prompt = {'ShadowColor','MyTransparencyValue 1=n 0=y'};
    def     = {MyPicStruct.LeftShadowColor,num2str(MyPicStruct.MyTransparencyValue)};
    num_lines= 1;
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    ShadowColor=answer{1};
    ShadowTransparencyValue=str2double(answer{2}); %#ok<*ST2NM>
    
    
    [ShadowLeft,~]=ginput(1);
    [ShadowLeft1,~]=ginput(1);
end


ShadowWidth=abs(ShadowLeft1-ShadowLeft);
ShadowLeft=min(ShadowLeft,ShadowLeft1);




%[l b w h];
[BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hfig);

ha=getappdata(hfig,'hAxis');
axisPosition=get(ha(1),'position');
BkWidth=axisPosition(3);

xLim=get(ha(1),'XLim');%debug
myLeft=BkLeft+BkWidth*(ShadowLeft-xLim(1))/(xLim(2)-xLim(1)); %debug
%myWidth=BkWidth*ShadowWidth/(xLim(2)-xLim(1));
myWidth=BkWidth*ShadowWidth/(xLim(2)-xLim(1));
PicPos=get(hfig,'Position');
% annotation(hfig,'textbox',[myLeft/PicPos(3) BkBottom/PicPos(4) myWidth/PicPos(3) BkHeight/PicPos(4)],'FaceAlpha',ShadowTransparencyValue,'BackgroundColor',ShadowColor,'EdgeColor','none')
hshadow=annotation(hfig,'textbox',[myLeft/PicPos(3) (BkBottom-2)/PicPos(4) myWidth/PicPos(3) BkHeight/PicPos(4)]);%,'EraseMode ','xor','BackgroundColor','w')
set(hshadow,'EdgeColor','none','BackgroundColor',ShadowColor,'FaceAlpha',ShadowTransparencyValue)%,'EraseMode ','xor')%,'FaceAlpha',ShadowTransparencyValue
s=0;

% haxes=allchild(hfig);
% htemp=haxes(1);
% haxes(1)=haxes(end);
% haxes(end)=htemp;
% 
% % haxes=flipud(haxes);%keep the last one the same
% set(hfig,'Children',haxes);


return



dlg_title = 'Add a Shadow';
prompt = {'Enter the Shadow left 0=xlim','Enter the Shadow width 0=n','ShadowColor','MyTransparencyValue 1=n 0=y'};
def     = {num2str(MyPicStruct.xleft),num2str(MyPicStruct.Backgroundwidth),MyPicStruct.LeftShadowColor,num2str(MyPicStruct.MyTransparencyValue)};
num_lines= 1;
answer  = inputdlg(prompt,dlg_title,num_lines,def);
ShadowLeft=str2num(answer{1});
ShadowWidth=str2num(answer{2});
ShadowColor=answer{3};
ShadowTransparencyValue=str2num(answer{4});

%[l b w h];
[BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hfig);
ha=getappdata(hfig,'hAxis');
xLim=get(ha(1),'XLim');%debug
myLeft=BkLeft+BkWidth*(ShadowLeft-xLim(1))/(xLim(2)-xLim(1)); %debug
myWidth=BkWidth*ShadowWidth/(xLim(2)-xLim(1));
PicPos=get(hfig,'Position');
% annotation(hfig,'textbox',[myLeft/PicPos(3) BkBottom/PicPos(4) myWidth/PicPos(3) BkHeight/PicPos(4)],'FaceAlpha',ShadowTransparencyValue,'BackgroundColor',ShadowColor,'EdgeColor','none')
hshadow=annotation(hfig,'textbox',[myLeft/PicPos(3) BkBottom/PicPos(4) myWidth/PicPos(3) BkHeight/PicPos(4)]);%,'EraseMode ','xor','BackgroundColor','w')
set(hshadow,'EdgeColor','none','BackgroundColor',ShadowColor,'FaceAlpha',ShadowTransparencyValue)%,'EraseMode ','xor')%,'FaceAlpha',ShadowTransparencyValue
s=0;
return









