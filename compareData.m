function hBrowser=compareData(handleBrowser)
axesNum=handleBrowser.axesNum;

%%
% hBrowser=findobj('Type','figure','Tag','hBrowser');
    hBrowser=figure('Tag','hBrowser');%,'DeleteFcn',{@myDeleteFcn,handles},'resize','off');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Units','pixels')
    set(gcf,'Position',[scrsz(1) scrsz(2)+20 scrsz(3)/1.2 scrsz(4)/1.2])
    %     MyPicStruct=MyPicInit;%init by file data
    for i=1:axesNum %for location of axis
        hAxis(i)=axes('Parent',hBrowser,'Units','pixels','Position',[1 1 1 1],'box','on','XLim',handleBrowser.tLimit);%create axes for a position
        grid on
        %         hSmooth(i)=line('Parent',hAxis(i),'Color','b','Marker','n');
        hRaw(i)=line('Parent',hAxis(i),'Color','r','Marker','.');
        hRaw(i+axesNum)=line('Parent',hAxis(i),'Color','b','Marker','.');
        MyYTick(hAxis(i),3,2);
    end% for
    
%     set(hAxis(1),'Title',text('String',[num2str(CurrentShot) ':' num2str(CurrentShot1)],'Color','r'))   
    set(get(hAxis(1),'Title'),'String',handleBrowser.title,'Color','r')
    linkaxes(hAxis,'x')
    set(hAxis(1:axesNum-1),'XTickLabel',{[]})
    handleBrowser.hBrowser=hBrowser;
    handleBrowser.hAxis=hAxis;
    handleBrowser.hRaw=hRaw;

    myResize(hBrowser, [], handleBrowser)
    
    %set the callback function
    set(hBrowser,'WindowButtonDownFcn',{@myButtonDown,handleBrowser},'WindowButtonMotionFcn',{@myButtonMotion,handleBrowser},...
        'WindowButtonUpFcn',{@myButtonUp,handleBrowser},'ResizeFcn',{@myResize,handleBrowser},...
        'KeyPressFcn',{@browserKeyFunction,handleBrowser},'resize','off');
% else
%     hAxis=findobj('Type','axes');
%     hRaw=findobj('Type','line');
%     handleBrowser.hBrowser=hBrowser;
%     handleBrowser.hAxis=hAxis;
%     %     handleBrowser.hSmooth=hSmooth;
%     handleBrowser.hRaw=hRaw;
% end
numChannels=length(handleBrowser.yLabel);
n=0;

if numChannels>=6*(n+1)
    index(1:6)=6*n+1:6*(n+1);
else
    index(1:6)=numChannels;
    numResidue=numChannels-6*n;
    index(1:numResidue)=1:numResidue;
end
setappdata(0,'currentGroup',n)
setBrowserData(index,handleBrowser)
end






function setBrowserData(index,handles)
numChannels=handles.numChannels;  % vectors
axesNum=handles.axesNum;
t=handles.t;
y=handles.y;
yLabel=handles.yLabel;

ts=[t(index) t(index+numChannels)];
ys=[y(index) y(index+numChannels)];
yLabel=yLabel(index);



Ylimit=cell(axesNum,1);


for i=1:axesNum
    yMin=min(min(ys{i}),min(ys{i+axesNum}));
    yMax=max(max(ys{i}),max(ys{i+axesNum}));
    % special for logical status show
    if yMin>=0 && yMax<=1
        yMin=-0.25;
        yMax=1.25;
    end
    
    if yMin==yMax
        yMax=yMax+abs(yMax)/2;
    end    
    Ylimit{i}=[yMin yMax];
end

set(handles.hRaw,{'XData'},reshape(ts,[length(ts) 1]),{'YData'},reshape(ys,[length(ys) 1]));
set(handles.hAxis,{'YLim'},reshape(Ylimit,[length(Ylimit) 1]));
hyLabel=get(handles.hAxis,'YLabel');
hyLabel=cell2mat(hyLabel);
yLabel=regexprep(yLabel,'\_','\\_');
set(hyLabel,{'String'},reshape(yLabel,[length(yLabel) 1]));



for i=1:axesNum
    MyYTick(handles.hAxis(i),3,5);
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
index=ones(1,6);
chanLists=handles.yLabel;

numChannels=length(chanLists);
switch k
    case {'0' '1' '2' '3' '4' '5' '6' '7' '8' '9'}
        n=str2double(k);
        setappdata(0,'currentGroup',n)
        
        
        if numChannels<6*n
            n=0;
        end
        
        if numChannels>=6*(n+1)
            index(1:6)=6*n+1:6*(n+1);
        else
            index(1:6)=numChannels;
            numResidue=numChannels-6*n;
            index(1:numResidue)=1:numResidue;
        end
        setappdata(0,'currentGroup',n)
    case 'rightarrow'
        n=getappdata(0,'currentGroup')+1;
        if numChannels<6*n
            n=0;
        end
        
        if numChannels>=6*(n+1)
            index(1:6)=6*n+1:6*(n+1);
        else
            index(1:6)=numChannels;
            numResidue=numChannels-6*n;
            index(1:numResidue)=1:numResidue;
        end
        
        setappdata(0,'currentGroup',n)
    case 'leftarrow'
        n=getappdata(0,'currentGroup')-1;
        
        
        if n<0 
            n=ceil(numChannels/6); 
        end
        
        
        if numChannels>=6*(n+1)
            index(1:6)=6*n+1:6*(n+1);
        else
            index(1:6)=numChannels;
            numResidue=numChannels-6*n;
            index(1:numResidue)=1:numResidue;
        end
        
        
        setappdata(0,'currentGroup',n)
end
        setBrowserData(index,handles)
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
%     t1=get(handles.hSmooth,{'XData'});
%     y1=get(handles.hSmooth,{'YData'});
    axesNum=handles.axesNum;
    t2=get(handles.hRaw,{'XData'});
    y2=get(handles.hRaw,{'YData'});
    Ylimit=cell(M,1);

    for i=1:length(ha)
        t=t2{i};
        y=y2{i};
        tb=find(t>=L,1,'first');
        te=find(t<=R,1, 'last');
        ymin1=min(y(tb:te));
        ymax1=max(y(tb:te));
        
        t=t2{i+axesNum};
        y=y2{i+axesNum};
        tb=find(t>=L,1,'first');
        te=find(t<=R,1, 'last');
        ymin=min(y(tb:te));
        ymax=max(y(tb:te));
        
    yMin=min(ymin1,ymin);
    yMax=max(ymax1,ymax);
    
    
    
    % special for logical status show
    if yMin>=0 && yMax<=1
        yMin=-0.25;
        yMax=1.25;
    end
    
    if yMin==yMax
        yMax=yMax+abs(yMax)/2;
    end    
    
     
    Ylimit{i}=[yMin yMax];
        
        
        
    end
    set(handles.hAxis,{'YLim'},Ylimit);
    for i=1:length(ha)
          MyYTick(handles.hAxis(i),3,4);
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

