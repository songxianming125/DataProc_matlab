function hBrowser=ShowRawData(CurrentShot,tStart,tEnd,gFit)


RZMeasured=gFit.RZMeasured;  % 4  vectors
fluxMeasured=gFit.fluxMeasured;  % 4  vectors
BnMeasured=gFit.BnMeasured;  % 18  vectors
BtMeasured=gFit.BtMeasured;% 18  vectors
Ip=gFit.Ip;  %  1 vector
Iex=gFit.Iex;  % 18 element vector
betap=gFit.betap;% 18 element vector
tf=gFit.tf;  % 1 vector
tv=gFit.tv;  % 1 vector
tm=gFit.tm;% 1 vector
te=gFit.te;% 1 vector

t0=tStart; % start time
t1=tEnd;  % end time


%% load the raw data
[fluxMeasuredRaw,tf1]=hl2adb(CurrentShot,{'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d' 'FEx_Ip'},t0,t1,1,'fbc');
[BnMeasuredRaw,tv1]=hl2adb(CurrentShot,{'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'  'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12' 'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18' 'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'  'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12' 'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'},t0,t1,1,'vax');
[iPF,tm1]=hl2adb(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},t0,t1,1,'FBC');

hBrowser=findobj('Type','figure','Tag','hBrowser');
if isempty(hBrowser)
    hBrowser=figure('Tag','hBrowser');%,'DeleteFcn',{@myDeleteFcn,handles},'resize','off');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Units','pixels')
    set(gcf,'Position',[scrsz(1) scrsz(2)+20 scrsz(3)/1.2 scrsz(4)/1.2])
    %     MyPicStruct=MyPicInit;%init by file data
    axesNum=6;
    for i=1:axesNum %for location of axis
        hAxis(i)=axes('Parent',hBrowser,'Units','pixels','Position',[1 1 1 1],'box','on','XLim',[tStart tEnd]);%create axes for a position
        grid on
        hSmooth(i)=line('Parent',hAxis(i),'Color','b','Marker','n');
        hRaw(i)=line('Parent',hAxis(i),'Color','r','Marker','.');
        MyYTick(hAxis(i),3,2);

    end% for
    linkaxes(hAxis,'x')
    set(hAxis(1:axesNum-1),'XTickLabel',{[]})

    handleBrowser.hBrowser=hBrowser;
    handleBrowser.hAxis=hAxis;
    handleBrowser.hSmooth=hSmooth;
    handleBrowser.hRaw=hRaw;
    handleBrowser.tLimit=[tStart tEnd];
    
    
    handleBrowser.RZMeasured=RZMeasured;  % 4  vectors
    handleBrowser.fluxMeasured=fluxMeasured;  % 4  vectors
    handleBrowser.BnMeasured=BnMeasured;  % 18  vectors
    handleBrowser.BtMeasured=BtMeasured;% 18  vectors
    handleBrowser.Ip=Ip;  %  1 vector
    handleBrowser.Iex=Iex;  % 18 element vector
    handleBrowser.betap=betap;% 18 element vector
    handleBrowser.tf=tf;  % 1 vector
    handleBrowser.tv=tv;  % 1 vector
    handleBrowser.tm=tm;% 1 vector
    handleBrowser.te=te;% 1 vector
    
    handleBrowser.fluxMeasuredRaw=fluxMeasuredRaw;  % 1 vector
    handleBrowser.BnMeasuredRaw=BnMeasuredRaw(:,1:18);% 1 vector
    handleBrowser.BtMeasuredRaw=BnMeasuredRaw(:,19:36);% 1 vector
    handleBrowser.iPF=iPF;% 1 vector
%     set(hBrowser,'KeyPressFcn',{@browserKeyFunction,handleBrowser});
    
%set the callback function
    set(hBrowser,'WindowButtonDownFcn',{@myButtonDown,handleBrowser},'WindowButtonMotionFcn',{@myButtonMotion,handleBrowser},...
    'WindowButtonUpFcn',{@myButtonUp,handleBrowser},'ResizeFcn',{@myResize,handleBrowser},...
    'KeyPressFcn',{@browserKeyFunction,handleBrowser},'resize','off');
    
    
    
    
    myResize(hBrowser, [], handleBrowser)
end
    t1={tv tv tv tv tv tv}';
    t2={tv tv tv tv tv tv}';
    y1={BnMeasured(:,1) BnMeasured(:,2) BnMeasured(:,3) BnMeasured(:,4) BnMeasured(:,5) BnMeasured(:,6)}';
    y2={BnMeasured(:,7) BnMeasured(:,8) BnMeasured(:,9) BnMeasured(:,10) BnMeasured(:,11) BnMeasured(:,12)}';
    yLabel={'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'}';
    setBrowserData(t1,t2,y1,y2,yLabel,handleBrowser)
end
function setBrowserData(t1,t2,y1,y2,yLabel,handleBrowser)
axesNum=6;
Ylimit=cell(axesNum,1);
for i=1:axesNum
    Ylimit{i}=[min(min(y1{i}),min(y2{i})) max(max(y1{i}),max(y2{i}))];
end

set(handleBrowser.hSmooth,{'XData'},t1,{'YData'},y1);
set(handleBrowser.hRaw,{'XData'},t2,{'YData'},y2);
set(handleBrowser.hAxis,{'YLim'},Ylimit);

hyLabel=get(handleBrowser.hAxis,'YLabel');
hyLabel=cell2mat(hyLabel);
yLabel=regexprep(yLabel,'\_','\\_');


set(hyLabel,{'String'},yLabel);


for i=1:axesNum
    MyYTick(handleBrowser.hAxis(i),3,5);
end
end






function myResize(hObject, eventdata, handleBrowser)
%figure position

[BkLeft,BkBottom,BkWidth,BkHeight,figLBWH,MyPicStruct,M,HeightNumber]=getPositionSize(hObject);
HeightUnit=BkHeight/sum(HeightNumber);

CurrentAxes=0;
ha=handleBrowser.hAxis;
for i=1:M %for location
    Lnum=sum(HeightNumber(1:i));
    CurrentAxes=CurrentAxes+1;
    if HeightNumber(i)==0
        set(ha(CurrentAxes),'Position',[2000+BkLeft BkBottom+BkHeight-HeightUnit*Lnum BkWidth HeightUnit]);%move out our sight
    else
        set(ha(CurrentAxes),'Position',[BkLeft BkBottom+BkHeight-HeightUnit*Lnum BkWidth HeightUnit*HeightNumber(i)]);%set the size
    end
end

end%~isempty(ha)

function browserKeyFunction(hObject, eventdata, handles)
k=get(hObject,'currentkey');

        RZMeasured= handles.RZMeasured;  % 4  vectors
        fluxMeasured= handles.fluxMeasured;  % 4  vectors
        BnMeasured= handles.BnMeasured;  % 18  vectors
        BtMeasured= handles.BtMeasured;% 18  vectors
        Ip= handles.Ip;  %  1 vector
        Iex= handles.Iex;  % 18 element vector
        betap= handles.betap;% 18 element vector
        tf= handles.tf;  % 1 vector
        tv= handles.tv;  % 1 vector
        tm= handles.tm;% 1 vector
        te= handles.te;% 1 vector
  
switch k
    case '1'
        t1={tf tf tf tf tf tf}';
        t2={tf tf tf tf tf tf}';
        y1={fluxMeasured(:,1) fluxMeasured(:,2) fluxMeasured(:,3) fluxMeasured(:,4) Ip RZMeasured(:,1)}';
        y2={fluxMeasured(:,1) fluxMeasured(:,2) fluxMeasured(:,3) fluxMeasured(:,4) Ip RZMeasured(:,1)}';
        yLabel={'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d' 'FEx_Ip' 'Dh'}';
        setBrowserData(t1,t2,y1,y2,yLabel,handles)
    case '2'
        t1={tf tf tf tf tf tf}';
        t2={tf tf tf tf tf tf}';
        y1={Iex(:,1) Iex(:,2) Iex(:,3) Iex(:,4) Iex(:,5) RZMeasured(:,2)}';
        y2={Iex(:,1) Iex(:,2) Iex(:,3) Iex(:,4) Iex(:,5) RZMeasured(:,2)}';
        yLabel={'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2' 'Dz'}';
        setBrowserData(t1,t2,y1,y2,yLabel,handles)
    case '3'
        t1={tv tv tv tv tv tv}';
        t2={tv tv tv tv tv tv}';
        y1={BtMeasured(:,1) BtMeasured(:,2) BtMeasured(:,3) BtMeasured(:,4) BtMeasured(:,5) BtMeasured(:,6)}';
        y2={BtMeasured(:,1) BtMeasured(:,2) BtMeasured(:,3) BtMeasured(:,4) BtMeasured(:,5) BtMeasured(:,6)}';
        yLabel={'FBIpol_01' 'FBIpol_02' 'FBIpol_03' 'FBIpol_04' 'FBIpol_05' 'FBIpol_06'}';
        setBrowserData(t1,t2,y1,y2,yLabel,handles)
    case '4'
        t1={tv tv tv tv tv tv}';
        t2={tv tv tv tv tv tv}';
        y1={BtMeasured(:,7) BtMeasured(:,8) BtMeasured(:,9) BtMeasured(:,10) BtMeasured(:,11) BtMeasured(:,12)}';
        y2={BtMeasured(:,7) BtMeasured(:,8) BtMeasured(:,9) BtMeasured(:,10) BtMeasured(:,11) BtMeasured(:,12)}';
        yLabel={'FBIpol_07' 'FBIpol_08' 'FBIpol_09' 'FBIpol_10' 'FBIpol_11' 'FBIpol_12'}';
        setBrowserData(t1,t2,y1,y2,yLabel,handles)
    case '5'
        t1={tv tv tv tv tv tv}';
        t2={tv tv tv tv tv tv}';
        y1={BtMeasured(:,13) BtMeasured(:,14) BtMeasured(:,15) BtMeasured(:,16) BtMeasured(:,17) BtMeasured(:,18)}';
        y2={BtMeasured(:,13) BtMeasured(:,14) BtMeasured(:,15) BtMeasured(:,16) BtMeasured(:,17) BtMeasured(:,18)}';
        yLabel={'FBIpol_13' 'FBIpol_14' 'FBIpol_15' 'FBIpol_16' 'FBIpol_17' 'FBIpol_18'}';
        setBrowserData(t1,t2,y1,y2,yLabel,handles)
    case '6'
        t1={tv tv tv tv tv tv}';
        t2={tv tv tv tv tv tv}';
        y1={BnMeasured(:,1) BnMeasured(:,2) BnMeasured(:,3) BnMeasured(:,4) BnMeasured(:,5) BnMeasured(:,6)}';
        y2={BnMeasured(:,1) BnMeasured(:,2) BnMeasured(:,3) BnMeasured(:,4) BnMeasured(:,5) BnMeasured(:,6)}';
        yLabel={'FBIrad_01' 'FBIrad_02' 'FBIrad_03' 'FBIrad_04' 'FBIrad_05' 'FBIrad_06'}';
        setBrowserData(t1,t2,y1,y2,yLabel,handles)
    case '7'
        t1={tv tv tv tv tv tv}';
        t2={tv tv tv tv tv tv}';
        y1={BnMeasured(:,7) BnMeasured(:,8) BnMeasured(:,9) BnMeasured(:,10) BnMeasured(:,11) BnMeasured(:,12)}';
        y2={BnMeasured(:,7) BnMeasured(:,8) BnMeasured(:,9) BnMeasured(:,10) BnMeasured(:,11) BnMeasured(:,12)}';
        yLabel={'FBIrad_07' 'FBIrad_08' 'FBIrad_09' 'FBIrad_10' 'FBIrad_11' 'FBIrad_12'}';
        setBrowserData(t1,t2,y1,y2,yLabel,handles)
    case '8'
        t1={tv tv tv tv tv tv}';
        t2={tv tv tv tv tv tv}';
        y1={BnMeasured(:,13) BnMeasured(:,14) BnMeasured(:,15) BnMeasured(:,16) BnMeasured(:,17) BnMeasured(:,18)}';
        y2={BnMeasured(:,13) BnMeasured(:,14) BnMeasured(:,15) BnMeasured(:,16) BnMeasured(:,17) BnMeasured(:,18)}';
        yLabel={'FBIrad_13' 'FBIrad_14' 'FBIrad_15' 'FBIrad_16' 'FBIrad_17' 'FBIrad_18'}';
        setBrowserData(t1,t2,y1,y2,yLabel,handles)
end

end


function myButtonMotion(hObject, eventdata, handles)
end

%--------------------------------------------------------------------------


function myButtonDown(hObject, eventdata, handles)
StartPoint=get(hObject,'CurrentPoint');
setappdata(hObject,'StartPoint',StartPoint)
finalRect=rbbox;
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function myButtonUp(hObject, eventdata, handles)

EndPoint=get(hObject,'CurrentPoint');
StartPoint=getappdata(hObject,'StartPoint');


if ~isempty(StartPoint)
    xLeft=min(StartPoint(1),EndPoint(1));
    xRight=max(StartPoint(1),EndPoint(1));
    yBottom=min(StartPoint(2),EndPoint(2));
    yTop=max(StartPoint(2),EndPoint(2));
    %coordinate transformation
    ha=handles.hAxis;
    [BkLeft,BkBottom,BkWidth,BkHeight,figLBWH,MyPicStruct,M,HeightNumber]=getPositionSize(hObject);
    xLim=get(ha(1),'XLim');
    NTotal=sum(HeightNumber);
    HeightUnit=BkHeight/NTotal;

    if StartPoint(1)<EndPoint(1)
        %begin coordinate transformation
        %x coordinates
        xLeft=xLim(1)+(xLim(2)-xLim(1))*(xLeft-BkLeft)/BkWidth;
        xRight=xLim(1)+(xLim(2)-xLim(1))*(xRight-BkLeft)/BkWidth;
        [L,S,R]=gettheXTick(xLeft,xRight);
    elseif StartPoint(1)>=EndPoint(1) %if StartPoint(1)<EndPoint(1)
         tLimit= handles.tLimit;
        [L,S,R]=gettheXTick(tLimit(1),tLimit(2));
    else%if StartPoint(1)<EndPoint(1)
    end%if StartPoint(1)<EndPoint(1)
    
    
    xLim=[L R];
    set(ha(1:M-1),{'XLim'},{xLim},{'XTick'},{[L:S:R]},{'XTickLabel'},{[]});
    set(ha(M),'XLim',xLim,'XTick',[L:S:R],'XTickLabelMode','auto');
    t1=get(handles.hSmooth,{'XData'});
    y1=get(handles.hSmooth,{'YData'});
    
    t2=get(handles.hRaw,{'XData'});
    y2=get(handles.hRaw,{'YData'});
    Ylimit=cell(M,1);

    for i=1:length(ha)
        t=t1{i};
        y=y1{i};
        tb=find(t>=L,1,'first');
        te=find(t<=R,1, 'last');
        ymin1=min(y(tb:te));
        ymax1=max(y(tb:te));
        
        t=t2{i};
        y=y2{i};
        tb=find(t>=L,1,'first');
        te=find(t<=R,1, 'last');
        ymin2=min(y(tb:te));
        ymax2=max(y(tb:te));
        
        Ylimit{i}=[min(ymin1,ymin2) max(ymax1,ymax2)];
    end
    set(handles.hAxis,{'YLim'},Ylimit);
    for i=1:length(ha)
          MyYTick(handles.hAxis(i),3,2);
    end
    
end%~isempty(StartPoint)
end


function [BkLeft,BkBottom,BkWidth,BkHeight,figLBWH,MyPicStruct,axesNum,HeightNumber]=getPositionSize(hObject)
MyPicStruct=MyPicInit;%init by file data
figLBWH=get(hObject,'position');%get the size of the picture
BkLeft=figLBWH(3)*MyPicStruct.myleft;
BkBottom=32+figLBWH(4)*MyPicStruct.mybottom;
BkHeight=figLBWH(4)*MyPicStruct.myheight;
BkWidth=figLBWH(3)*MyPicStruct.mywidth;
axesNum=6;
HeightNumber(1:axesNum)=1;%init by file data
end