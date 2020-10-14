% --------------------------------------------------------------------
function s=DrawProfile(hObject, eventdata, handles,n1)
s=0;
t=1;
MyCurves=get(handles.lbCurves,'UserData');%得到当前的曲线
[m,n]=size(MyCurves);
n2=n-n1;
hfig=figure('Color', 'w');





scrsz = get(0,'ScreenSize');
set(gcf,'Units','pixels')
set(gcf,'Position',[scrsz(1) scrsz(2)+50 scrsz(3)/1.5 scrsz(4)/1.5])
oldPosition=get(gca,'Position');
set(gca,'Position',[oldPosition(1) oldPosition(2) oldPosition(3)/1.8 oldPosition(4)],'Tag','NLeft');
sLabel=[{'Step'} {'10'} {'Time(s)'} {'10'} {'Update'} {'Clear'} {'Up'} {'Down'} ];
sType=[{'text'}  {'edit'} {'text'}  {'edit'}  {'pushbutton'} {'pushbutton'} {'pushbutton'} {'pushbutton'}];

wstep=scrsz(3)/15;
hstep=scrsz(4)/36;

[Num,m]=size(sLabel);

    
for i=1:5
    Bottom(i)=(10-i)*hstep;
    Left(i)=8*wstep;
end

for i=m-2:m
    Bottom(i)=(13.5-i)*hstep;
    Left(i)=9*wstep;
end

for i=1:m
    hBtn(i) = uicontrol(gcf,...
                 'style', sType{i},...
                 'Position',[Left(i) Bottom(i) wstep hstep],...
                 'String', sLabel{i});
end
grid on
box on
%hold on
MyTitle=MyCurves(1).Shot;
title(MyTitle);
xlabel('rho')
%set(gca,'UserData',MyLegend);
set(hBtn(2),'String',num2str(1))
set(hBtn(4),'String',num2str(t))
set(hBtn(4),'UserData',MyCurves(1))
set(hBtn(5),'UserData',hBtn(4))
set(hBtn(6),'UserData',n1)
set(hBtn(7),'UserData',hBtn(2))
set(hBtn(8),'UserData',hBtn(2))
set(hfig,'UserData',n1)
set(hBtn(5),'CallBack',{@UpdatePicture,handles})
set(hBtn(6),'CallBack',{@ClearPicture,handles})
set(hBtn(7),'CallBack',{@UpTime,hBtn(4)})
set(hBtn(8),'CallBack',{@DownTime,hBtn(4)})

cfgmenu=uicontextmenu;
cfgitem1= uimenu(cfgmenu, 'Label', 'FixYLimit', 'Callback', {@FixYLimit,hfig});
cfgitem2= uimenu(cfgmenu, 'Label', 'ClearYLimit', 'Callback', {@ClearYLimit,hfig});
set(hfig,'UIContextMenu', cfgmenu);%,'KeyPressFcn',{@myKeyFunction,handles})

%--------------------------------------------------------------------------
function UpTime(hObject, eventdata, handles)
c=get(handles,'UserData');
step=str2num(get(get(hObject,'UserData'),'String'));
t=str2num(get(handles,'String'));
t=t+step;
if t>c.xMax
    t=c.xMax;
end
set(handles,'String',num2str(t));
%--------------------------------------------------------------------------
function DownTime(hObject, eventdata, handles)
c=get(handles,'UserData');
step=-str2num(get(get(hObject,'UserData'),'String'));
t=str2num(get(handles,'String'));
t=t+step;
if t<c.xMin
    t=c.xMin;
end
set(handles,'String',num2str(t));

%--------------------------------------------------------------------------
function s=UpdatePicture(hObject, eventdata, handles)
MyPicStruct=MyPicInit;%init by file data
MyCurves=get(handles.lbCurves,'UserData');
[m,n]=size(MyCurves);
n1=get(get(gca,'Parent'),'UserData');
n2=n-n1;
h=get(hObject,'UserData');
t=str2num(get(h,'String'));
c=MyCurves(1);
if t<c.xMin
    t=c.xMin;
end
if t>c.xMax
    t=c.xMax;
end
rho=0;
%__________________________________________________________________________
hf1=findobj('Type','axes','YAxisLocation','left','Tag','NLeft');
set(hf1,'Color','none','XColor','b','YAxisLocation','left','YColor','b');
x=MyCurves(1).x;
[mf,Index]=min(abs(x-t));
rho1=PlotProfile(hf1(1),MyCurves,MyPicStruct,Index, 0,n1,'b','.',t,0,rho);
%__________________________________________________________________________
if n2>0
    hf2=findobj('Type','axes','YAxisLocation','right','Tag','NRight');
    if isempty(hf2)
        MyPosition=get(gca,'Position');
        hf2=axes('Position',MyPosition);%,'replace'
        set(hf2,'Color','none','XColor','b','YAxisLocation','right','YColor','r','Tag','NRight');
        grid on
        box off
    end
    x=MyCurves(n1+1).x;
    [mf,Index]=min(abs(x-t));
    rho2=PlotProfile(hf2,MyCurves,MyPicStruct,Index, n1,n2,'r','x',t,1,rho1);
end
s=1;
%__________________________________________________________________________
function ClearPicture(hObject, eventdata, handles)
h1=get(gcf,'Children');
h=findobj(h1,'Type','axes');
[m,n]=size(h);
if m==2
    delete(h(1))
elseif m==4
    delete(h(1:3))
end
set(gca,'UserData',[]);
cla;

%--------------------------------------------------------------------------
function rho=PlotProfile(ha,MyCurves,MyPicStruct,Index, iOffset,n1,MyColor,MyMarker,t,R,rhov)
%R  0=Left, 1=Right
subplot(ha);
if n1==11
    if R==1 & iOffset==11
        rho1=rhov;
    else
        CurrentShot=str2num(MyCurves(1+iOffset).Shot);
        CurrentChannel='GEQAEQUA';
        [r1,x1]=tsbase(CurrentShot,CurrentChannel);
        for i=1:n1
            rho1(i)=r1(Index,i)/r1(Index,n1);
        end
    end
else
    rho1=0:n1-1;
    rho1=rho1/(n1-1);
end

for i=1:n1
    y1(i)=MyCurves(i+iOffset).y(Index);
end

yMin=min(y1);
yMax=max(y1);
MyAxisData=get(gca,'UserData');
if isempty(MyAxisData)
        r1=GetMyPower(max(abs(yMin),abs(yMax)));
        n=0;
else
        MyLegend=MyAxisData.MyLegend;
        [m,n]=size(MyLegend);
        r1=MyAxisData.r;
        pr=realpow(10,r1);
        MLim=get(gca,'YLim').*pr;
        yMin=min(yMin,MLim(1));
        yMax=max(yMax,MLim(2));
end
pr1=realpow(10,r1);
y1=y1/pr1;
yMin=yMin/pr1;
yMax=yMax/pr1;

fixYLim=getappdata(gcf,'FixYLimit');
if ~isempty(fixYLim)
    yMin=fixYLim(2*R+1);
    yMax=fixYLim(2*R+2);
end

%fix the y

%sMyColor='mcrgbwky';
sMyColor='bckymrg';
if R
    MyColor=sMyColor(mod(n+5,7)+1);
else
    MyColor=sMyColor(mod(n,7)+1);
end
%Marker + o * . x s d ^ v > < p h none (total=14)
sMyMarker='+o*.xsd^v><ph';
%MyMarker=sMyMarker(mod(n,13)+1);
%MyMarker='x';
sMyLineStyle=[{'-'},{'-.'},{'--'},{':'}];
MyLineStyle=sMyLineStyle{mod(n,4)+1};

hline1=line(rho1,y1,'Marker','.','Parent',gca,'Color',MyColor,'Marker',MyMarker,'LineStyle',MyLineStyle);

if n>0
    MyLegend(n+1)={strcat('t=',num2str(t),'(s)')};
else
    MyLegend={strcat('t=',num2str(t),'(s)')};
    MyAxisData.r=r1;
end
[h1,h2,h3,h4]=legend(MyLegend,2-R);
ylim([yMin yMax]);
Yy=MyYTick(MyPicStruct.YTickNum,MyPicStruct.RightDigit,0);
MyAxisData.MyLegend=MyLegend;
set(gca,'UserData',MyAxisData);

CurveUnit=MyCurves(1+iOffset).ChnlName;
[p1,q1]=size(CurveUnit);
CurveUnit=strcat(CurveUnit(1:q1-2),'/',MyCurves(1+iOffset).Unit);
if r1==0
        MyUnit=strcat(CurveUnit,' ');
else
        s1=num2str(r1);
        L1=size(s1,2);
        sr='';
        for j=1:L1
            sr=strcat(sr,'^',s1(j));
        end
        %MyUnit=strcat(CurveUnit{i},'(\times10',sr,')');
        MyUnit=strcat(CurveUnit,'(10',sr,')');
end
ylabel(MyUnit);
rho=rho1;

function s=FixYLimit(hObject, eventdata,hfig)
prompt = [{'Fix the Ymin of Left axis'} {'Fix the YMax of Left axis'} {'Fix the Ymin of Right axis'} {'Fix the YMax of Right axis'}];
dlg_title = 'FixYLimit';
num_lines= 1;
def     = [{'0'} {'12'} {'0'} {'12'}];
y  = inputdlg(prompt,dlg_title,num_lines,def);
for i=1:4
    fixYLim(i)=str2num(y{i});%
end
setappdata(hfig,'FixYLimit',fixYLim);

function s=ClearYLimit(hObject, eventdata,hfig)
setappdata(hfig,'FixYLimit',[]);

