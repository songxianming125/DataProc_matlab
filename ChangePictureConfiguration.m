
% --------------------------------------------------------------------
function s=ChangePictureConfiguration(~, ~,handles)
global MyPicStruct PicDescription MyCurves hOffset
hOffset=0;  % used to move the position

%MyCurves=get(handles.lbCurves,'UserData');%得到当前的曲线
[~,n]=size(MyCurves);
%hfig=gcf;
%Save the YLim Data in the Configuration.txt file or Use the Data in the Configuration.txt file as the YLim data
hfconfiguration=figure('Color', 'k','Name','configuration','DefaultTextColor','w','MenuBar','none');
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


hOffset=(length(PicDescription)+2)*hstep;


for i=1:m
    sBtn(i) = uicontrol(gcf,...
                 'style', 'text',...
                 'Position',[dLeft(i) hOffset-2*hstep dWidth(i) scrsz(4)/40 ],...
                 'String', sLabel{i});
end



for j=1:n
    index=1;
    sLabel{index}=num2str(j);
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
    sLabel{index}=PicDescription(j).ChnlName;
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).yMin);
    index=index+1;
    sLabel{index}=num2str(PicDescription(j).yMax);
    
  firstcheck=1;  
  for i=1:m
      hCurves(j,i) = uicontrol(gcf,...
          'style', sType{i},...
          'Position',[dLeft(i) -(j+2)*hstep+hOffset dWidth(i) scrsz(4)/40 ],...  %hOffset move it upward
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
  %set(sBtnp(4),'String', {sLabel{4},sLabel{4},sLabel{4}})
end

m=8;
sLabel(1:m)=[{'Struct'} {'DelPic'} {'BkLeft'} {'BkWidth'} {'XStep'} {'Xmin'}  {'Xmax'} {'BkColor'}];

for i=1:m
    dLeft(i)=(i-0.5)*wstep;
    dWidth(i)=wstep;
    dHeight(i)=scrsz(4)/40;
    dBottom(i)=scrsz(4)/1.3;
end
%dWidth(3)=wstep/2;
%dWidth(4)=wstep*3/2;

for i=(m-2):m
    dWidth(i)=wstep*2;
end


for i=1:2
    dLeft(m-2+i)=dLeft(m-1)+wstep*i;
end
dWidth(1)=dWidth(1)+wstep/2;
dWidth(2)=dWidth(1)-wstep/2;


dLeft(2)=dLeft(2)+wstep/2;



for i=1:m
    sPic(i) = uicontrol(gcf,...
                 'style', 'text',...
                 'Position',[dLeft(i) hOffset+1*hstep dWidth(i) scrsz(4)/40],...
                 'String', sLabel{i});
end

%sLabel{1}=num2str(MyPicStruct.LayoutMode);
sLabel{1}=[{'1/0'} {'1/1'} {'135/246'} {'111...'} {'1|1+n/2'} {'1+1/0'} {'6'} {'135+246'} {'R=0'}];
sLabel{2}=num2str(MyPicStruct.DeletePic);
sLabel{3}=num2str(MyPicStruct.BackgroundLeft);
sLabel{4}=num2str(MyPicStruct.Backgroundwidth);
sLabel{5}=num2str(MyPicStruct.xStep);
sLabel{6}=num2str(MyPicStruct.xleft);
sLabel{7}=num2str(MyPicStruct.xright);
sLabel{8}=MyPicStruct.BackgroundColor;
sType(1:m)=[{'popupmenu'}  {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} {'edit'} ];
dHeight(1)=dHeight(1);
dBottom(1)=dBottom(1);
for i=1:m
    hPic(i) = uicontrol(gcf,...
                 'style',sType{i},...
                 'Position',[dLeft(i) hOffset dWidth(i) scrsz(4)/40],...
                 'String', sLabel{i});
end
set(hPic(1),'value',1,'Enable','off');


sBtnOK = uicontrol(gcf,...
                 'style', 'pushbutton',...
                 'Position',[dLeft(12) hOffset dWidth(8) scrsz(4)/40 ],...
                 'String', 'OK',...
                 'CallBack',{@RedrawPicture,handles});
hcfg.hCurves= hCurves;
hcfg.hPic= hPic;
%hcfg.hfig= hfig;
hcfg.hfconfiguration= hfconfiguration;
set(sBtnOK,'UserData',hcfg)
%delete(hfig);
set(hfconfiguration,'Position',[scrsz(1) scrsz(2)+50 scrsz(3)/1.1 hOffset+2*hstep])
s=1;
% --------------------------------------------------------------------



function RedrawPicture(hObject, eventdata, handles)
global MyPicStruct PicDescription MyCurves Lines2Axes


[m,n]=size(MyCurves);
hcfg=get(hObject,'UserData');
hCurves=hcfg.hCurves;
hPic=hcfg.hPic;
%hfig=hcfg.hfig;
hfconfiguration=hcfg.hfconfiguration;

%Num Loc Right Color Marker LineStyle Min Max
for i=1:n
    index=2;
    PicDescription(i).Location=str2num(get(hCurves(i,2),'String')); %%build up the initial PictureArrangement
%     Location(i)=PicDescription(i).Location;
    index=index+1;
    PicDescription(i).Right=str2num(get(hCurves(i,index),'String'));
    index=index+1;
    myColor=get(hCurves(i,index),'String');
    [cm,cn]=size(myColor);
    if cn>1
        format='%e';
        [C(1:3),count,errs]=sscanf(myColor,format);
    else
        C=myColor;
    end
    PicDescription(i).Color=C;
    index=index+1;
    PicDescription(i).Marker=get(hCurves(i,index),'String');
    index=index+1;
    PicDescription(i).LineStyle=get(hCurves(i,index),'String');
    index=index+1;
    PicDescription(i).LeftDigit=str2num(get(hCurves(i,index),'String'));
    index=index+1;
    PicDescription(i).RightDigit=str2num(get(hCurves(i,index),'String'));

    index=index+1;
    PicDescription(i).XOffset=str2num(get(hCurves(i,index),'String'));
    index=index+1;
    PicDescription(i).YOffset=str2num(get(hCurves(i,index),'String'));
    index=index+1;
    PicDescription(i).Factor=str2num(get(hCurves(i,index),'String'));

    index=index+1;
    PicDescription(i).Unit=get(hCurves(i,index),'String');
    index=index+1;
%     PicDescription(i).YLimitAuto=get(hCurves(i,index),'Value');
    PicDescription(i).YLimitAuto=str2num(get(hCurves(i,index),'String'));
    index=index+1;
%     PicDescription(i).IsStairs=get(hCurves(i,index),'Value');
    PicDescription(i).IsStairs=str2num(get(hCurves(i,index),'String'));
    index=index+1;
    PicDescription(i).ChnlName=get(hCurves(i,index),'String');
    index=index+1;
    PicDescription(i).yMin=str2num(get(hCurves(i,index),'String'));
    index=index+1;
    PicDescription(i).yMax=str2num(get(hCurves(i,index),'String'));
    %debug
    %PicDescription(i).LeftDigit=mod(i,2)+1;
    %PicDescription(i).RightDigit=0;

end

%M=max(Location(1:n));
%MyPicStruct.AxesNum=M;%store the Axes number

% if MyPicStruct.LayoutMode~=get(hPic(1),'value')-1
%     MyPicStruct.LayoutMode=get(hPic(1),'value')-1;
%     MyPicStruct.Modified=1;
% else
%     MyPicStruct.Modified=0;%do not change the PicDescription
% end


MyPicStruct.DeletePic=str2num(get(hPic(2),'String')); %%build up the initial PictureArrangement
MyPicStruct.BackgroundLeft=str2num(get(hPic(3),'String')); %%build up the initial PictureArrangement
MyPicStruct.Backgroundwidth=str2num(get(hPic(4),'String')); %%build up the initial PictureArrangement
MyPicStruct.xStep=str2num(get(hPic(5),'String')); %%build up the initial PictureArrangement
MyPicStruct.xleft=str2num(get(hPic(6),'String')); %%build up the initial PictureArrangement
MyPicStruct.xright=str2num(get(hPic(7),'String'));
MyPicStruct.BackgroundColor=deblank(get(hPic(8),'String'));

MyPicStruct.xTickleft=MyPicStruct.xleft;
MyPicStruct.xTickright=MyPicStruct.xright;

%set the default channel name for later drawing
if length(MyCurves)==length(PicDescription)
    SaveChannelName
end
Lines2Axes=[];
MyPicStruct.Modified=0;%do not change the PicDescription

delete(gcf)
MyPicStruct.Modified=1;%do not change the PicDescription
DrawCurves_Callback(handles.DrawCurves, eventdata, handles);



