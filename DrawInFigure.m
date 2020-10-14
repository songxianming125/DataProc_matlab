function DrawInFigure(hfig)
%   Copyright 1966-2012 Dr.SONG Xianming: songxm@swip.ac.cn
%%  2017.4 18 version 3.0
%set 
global  MyPicStruct PicDescription MyCurves handles LocationLeftRight hLines ha 


%% associate to axes
hAxisItem = uicontextmenu;
axisItem1=uimenu(hAxisItem, 'Label', 'addCurve', 'Callback', {@add_del_curve,handles,1});
axisItem2=uimenu(hAxisItem, 'Label', 'delCurve', 'Callback', {@add_del_curve,handles,-1});

        
%set a shadow        
%Coordinate transform 
if MyPicStruct.Backgroundwidth>0 && ~isempty(strmatch(MyPicStruct.BackgroundLayer,'back','exact'))
    hLabel(1)=SetLabelBar(MyPicStruct,0,'hShadow1',1);
    hLabel(2)=SetLabelBar(MyPicStruct,0,'hShadow2',2);
    hLabel(3)=SetLabelBar(MyPicStruct,1,'hHorizontal3',3);
    hLabel(4)=SetLabelBar(MyPicStruct,1,'hHorizontal4',4);
    setappdata(hfig,'ShadowHandle',findobj(hfig,'Type','axes','Tag','hShadow1'))
    setappdata(hfig,'hLabel',hLabel);
end %MyPicStruct.Backgroundwidth

%draw curves

M=MyPicStruct.AxesNum;%get the Axes number
n=length(PicDescription);
Location1={PicDescription.Location};%cell array is ok.
Location=cell2mat(Location1);
LeftRight1={PicDescription.Right};
LeftRight=cell2mat(LeftRight1);

% init
CurrentAxes=0;
if ~isempty(ha) && ishandle(ha(1))
    delete(ha)
end

ha=[];
hLines=[];
AxesPower=[];
ChannelNames={[]};



for i=1:M %for location of axis
    for j=0:1 %for LeftRight axis
        A=abs(Location-i)+abs(LeftRight-j);
        index=find(A==0);
        if ~isempty(index)
            CurrentAxes=CurrentAxes+1;
            %% create axes
            if j
                if LocationLeftRight(i,1)==0
                    ha(CurrentAxes)=axes('Units','pixels','Position',[1 1 1 1],'Color','none','XGrid',MyPicStruct.GridMode,'YGrid',MyPicStruct.GridMode,'XColor',MyPicStruct.XColor);%create axes for a position
                    set(ha(CurrentAxes),'Box','on','YAxisLocation','right','YColor',MyPicStruct.RightColor,'uicontextmenu',hAxisItem);%create axes for a position
                else
                    ha(CurrentAxes)=axes('Units','pixels','Position',[1 1 1 1],'Color','none','XGrid','off','YGrid','off','XColor',MyPicStruct.XColor);%create axes for a position
                    set(ha(CurrentAxes),'Box','off','YAxisLocation','right','YColor',MyPicStruct.RightColor,'uicontextmenu',hAxisItem);%create axes for a position
                end

                
            else
                ha(CurrentAxes)=axes('Units','pixels','Position',[1 1 1 1],'Color','none','XGrid',MyPicStruct.GridMode,'YGrid',MyPicStruct.GridMode,'XColor',MyPicStruct.XColor);%create axes for a position
                set(ha(CurrentAxes),'Box','on','YAxisLocation','left','YColor',MyPicStruct.LeftColor,'uicontextmenu',hAxisItem);%create axes for a position
            end
            
            
            yMin=PicDescription(index(1)).yMin;
            yMax=PicDescription(index(1)).yMax;
            
            %initialization
            MyLend=[];
            x={[]};
            y={[]};
            for ii=1:length(index)
                if PicDescription(index(ii)).IsStairs==1 %stairs style line
                    [xb,yb] = stairs(MyCurves(index(ii)).x,MyCurves(index(ii)).y); 
                    MyCurves(index(ii)).x=xb;
                    MyCurves(index(ii)).y=yb;
                end
                x(ii)={MyCurves(index(ii)).x+PicDescription(index(ii)).XOffset};
                y(ii)={PicDescription(index(ii)).Factor*MyCurves(index(ii)).y+PicDescription(index(ii)).YOffset};
                
                
%                %reference the only first curve,  don't care other 
                yMin=min(yMin,PicDescription(index(ii)).yMin);
                yMax=max(yMax,PicDescription(index(ii)).yMax);
                
                switch PicDescription(index(ii)).LineStyle
                    case ','
                        PicDescription(index(ii)).LineStyle='--';
                    case '.'
                        PicDescription(index(ii)).LineStyle='-.';
                    case 'n'
                        PicDescription(index(ii)).LineStyle='none';
                end
                switch PicDescription(index(ii)).Marker
                    case 'n'
                        PicDescription(index(ii)).Marker='none';
                end
                
                if ~isempty(MyCurves(index(ii)).z)
                         hLines(index(ii))=pcolor(ha(CurrentAxes),MyCurves(index(ii)).x,MyCurves(index(ii)).y,MyCurves(index(ii)).z);shading (ha(CurrentAxes),'interp');
                else
                    
                    if MyPicStruct.Debug2~=2
                        hLines(index(ii))=line('Parent',ha(CurrentAxes),'Color',PicDescription(index(ii)).Color,'Marker',PicDescription(index(ii)).Marker,'LineStyle',PicDescription(index(ii)).LineStyle,'LineWidth',MyPicStruct.DefaultAxesLineWidth,...
                            'DisplayName',PicDescription(index(ii)).ChnlName,'ButtonDownFcn',{@myLineButtonDownFcn,hfig});
                    else
                        hLines(index(ii))=line('Parent',ha(CurrentAxes),'Color',PicDescription(index(ii)).Color,'Marker',PicDescription(index(ii)).Marker,'MarkerEdgeColor',PicDescription(index(ii)).Color,'MarkerFaceColor',PicDescription(index(ii)).Color,...
                            'MarkerSize',8,'LineStyle',PicDescription(index(ii)).LineStyle,'LineWidth',MyPicStruct.DefaultAxesLineWidth,...
                            'DisplayName',PicDescription(index(ii)).ChnlName,'ButtonDownFcn',{@myLineButtonDownFcn,hfig});
                    end
                end
                
                mystr=deblank(strtok(PicDescription(index(ii)).ChnlName,char(0)));
                if MyPicStruct.Debug5==9  %tex mode
                else
                    mystr=strrep(mystr,'_','\_');
                end
                mystr=strrep(mystr,'@','');
                
                
                
                if isempty(PicDescription(index(ii)).Unit)
                    MyLend=[MyLend {mystr}];
                else
                    mystrU=deblank(strtok(PicDescription(index(ii)).Unit,char(0)));
                    if iscell(mystrU)
                        mystrU=mystrU{1}; %avoid to be cell
                    end
                    
                    if MyPicStruct.Debug5==9  %tex mode
                    else
                        mystrU=strrep(mystrU,'_','\_');
                    end
                    MyLend=[MyLend {strcat(mystr,'(',mystrU,')')}];
                end
                
            end
            
            
            %for yMin==yMax
            if yMin==yMax
                if yMin==0
                    yMax=yMin+1;
                else
                    yMax=yMin+abs(yMin)/5;
                    yMin=yMin-abs(yMin)/5;
                end
            end

            
            myYmax=max((yMax-yMin),abs(yMax));
            myYmax=max(myYmax,abs(yMin));
            %YTick is in science format
            
            
            if MyPicStruct.FloatingMode==1
                %           make sure the YTick is integer
                PicDescription(index(1)).LeftDigit=ceil(log10(myYmax));
                r=0;
            else
                PicDescription(index(1)).LeftDigit=MyPicStruct.LeftDigit;
                r=ceil(log10(myYmax))-1-PicDescription(index(1)).LeftDigit;
            end

            p=realpow(10,r);        %adjust the former curve
            AxesPower(CurrentAxes)=r;
            
            for ii=1:length(index)
                %x(ii)={x{ii}/p};
                y(ii)={y{ii}/p};
                %set(hLines(ii),'XData',x{ii},'YData',y{ii});
            end
            yMin=yMin/p;
            yMax=yMax/p;
            
            hLines=reshape(hLines,length(hLines),1);
            x=reshape(x,length(x),1);
            y=reshape(y,length(y),1);
            
            
            if isempty(MyCurves(index(ii)).z)
                set(hLines(index),{'XData'},x,{'YData'},y);  %x and y are always cell
            end
            ChannelNames(CurrentAxes)={MyLend};
            
            if 0 % MyPicStruct.YAutoInteger && PicDescription(index(1)).YLimitAuto 
                [yMin,yMax,RightDigit]=ModifyYLimitTick(yMin,yMax,PicDescription(index(1)).RightDigit);
                [yMin,yMax]=ModifyYLimitTick(yMin,yMax,n);
%                 PicDescription(index(1)).RightDigit=RightDigit; %reset the RightDigit
            end

            
            set(ha(CurrentAxes),'YLim',[yMin,yMax]);
            yLimit(:,CurrentAxes)=[yMin,yMax];
            
            if CurrentAxes==1
                    if ~isempty(MyPicStruct.PicTitle)
                        myTitle=strrep(MyPicStruct.PicTitle,'_','\_');
                    else
                        myTitle=[];
                    end
                    hPicTitle=title(myTitle,'Color',MyPicStruct.XColor);
                    setappdata(hfig,'hPicTitle',hPicTitle);
            end%L==1
        end% if
    end
end

setappdata(hfig,'yLimit',yLimit);
setappdata(hfig,'ChannelNames',ChannelNames);
setappdata(hfig,'AxesPower',AxesPower);
setappdata(hfig,'hAxis',ha);


%set a shadow        
%Coordinate transform 
if MyPicStruct.Backgroundwidth>0 && ~isempty(strmatch(MyPicStruct.BackgroundLayer,'front','exact'))
    hLabel(1)=SetLabelBar(MyPicStruct,0,'hShadow1',1);
    hLabel(2)=SetLabelBar(MyPicStruct,0,'hShadow2',2);
    hLabel(3)=SetLabelBar(MyPicStruct,1,'hHorizontal3',3);
    hLabel(4)=SetLabelBar(MyPicStruct,1,'hHorizontal4',4);
    setappdata(hfig,'ShadowHandle',findobj('Type','axes','Tag','hShadow1'))
    setappdata(hfig,'hLabel',hLabel);
end %MyPicStruct.Backgroundwidth

