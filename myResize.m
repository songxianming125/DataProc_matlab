function myResize(hObject, eventdata, handles)
%figure position
global bResizable MyPicStruct PicDescription HeightNumber Loc2Axes WidthNumber
global myLeft myWidth ha
% bResizable=0;
if bResizable
    %% m*n grid display
    % condition 1) only left axes 2) divide axes number to m*n, if less
    % than m*n, padded empty, column privilege.
    
    %% end grid display
    setappdata(hObject,'HeightNumber',HeightNumber);
    
    RowNumber=MyPicStruct.RowNumber;
    ColumnNumber=MyPicStruct.ColumnNumber;
    [BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
    
    HeightUnit=BkHeight/sum(HeightNumber(:));
    WidthUnit=BkWidth/sum(WidthNumber(:));
    GapWidth=MyPicStruct.GapWidth;
    
    
    
    if MyPicStruct.GapMode==0  %control the YTick mode song mode or conventional mode
        GapHeight=0; %control the gap height for conventional YTick mode
    else
        GapHeight=MyPicStruct.GapHeight; %control the gap height for conventional YTick mode
    end
    
    Location1={PicDescription.Location};%cell array is ok.
    Location=cell2mat(Location1);
    LeftRight1={PicDescription.Right};
    LeftRight=cell2mat(LeftRight1);
    
    
    
    
    CurrentAxes=0;
    for iC=1:ColumnNumber
        for iR=1:RowNumber
            if ~isempty(ha)
                    Lnum=sum(HeightNumber(1:iR));
                    Wnum=sum(WidthNumber(1:iC))-WidthNumber(iC);
                    for j=0:1 %for LeftRight
                        % i
                        A=abs(Location-iR-RowNumber*(iC-1))+abs(LeftRight-j);
                        index=find(A==0);
                        
                        
                        if ~isempty(index)
                            CurrentAxes=CurrentAxes+1;
                            if (HeightNumber(iR)==0) || (WidthNumber(iC)==0)
                                set(ha(CurrentAxes),'Position',[2000+BkLeft BkBottom+BkHeight-HeightUnit*Lnum WidthUnit HeightUnit]);%move out our sight
                            else
                                set(ha(CurrentAxes),'Position',[BkLeft+WidthUnit*Wnum BkBottom+BkHeight-HeightUnit*Lnum WidthUnit*WidthNumber(iC)-GapWidth HeightUnit*HeightNumber(iR)-GapHeight]);%set the size
                                
                                %align the YLabel x position
                                if MyPicStruct.Debug1==2
                                    if CurrentAxes==1
                                        pos1=get(get(ha(CurrentAxes),'YLabel'),'position');
                                        
                                        XLim=get(ha(CurrentAxes),'XLim');
                                        XTick=get(ha(CurrentAxes),'XTick');
                                        if ~isempty(XTick) && length(XTick)>2
                                            pos1(1)=XLim(1)-(XTick(2)-XTick(1))/2;
                                        else
                                            pos1(1)=XLim(1);
                                        end
                                        
                                        set(get(ha(CurrentAxes),'YLabel'),'position',pos1);
                                        %ext=get(get(ha(i),'YLabel'),'extent');
                                    else
                                        pos=get(get(ha(CurrentAxes),'YLabel'),'position');
                                        pos(1)=pos1(1);
                                        set(get(ha(CurrentAxes),'YLabel'),'position',pos);
                                        %ext=set(get(ha(i),'YLabel'),'extent',);
                                    end
                                    %Uni=get(get(ha(CurrentAxes),'YLabel'),'Units');
                                end
                            end
                        end% if
                        %                 axes(ha(CurrentAxes))
                        %                 box off
                        %                 set(ha(CurrentAxes),'LineWidth',MyPicStruct.DefaultAxesLineWidth*6)
                        %                 box on
                        %                 set(ha(CurrentAxes),'LineWidth',MyPicStruct.DefaultAxesLineWidth)
                    end
                
                if MyPicStruct.Backgroundwidth>0  %prepare for move the label
                    
                    %for details browsing manipulation
                    index=find(cellfun('isempty',Loc2Axes(:)),1,'last');
                    
                    if ~isempty(index)
                        Lnum=sum(HeightNumber((1:index(1)-1)));
                        BkBottom=BkBottom+BkHeight-HeightUnit*Lnum;
                        Lnum=sum(HeightNumber((index(1):end)));
                        BkHeight=BkHeight-HeightUnit*Lnum;
                    end
                    hLabel=getappdata(hObject,'hLabel');
                    
                    if isempty(myLeft)
                        myWidth=BkWidth*(MyPicStruct.Backgroundwidth)/(MyPicStruct.xright-MyPicStruct.xleft);
                        myLeft=BkLeft;
                    end
                    VerticalWidth=BkWidth*(MyPicStruct.Backgroundwidth)/(MyPicStruct.xright-MyPicStruct.xleft);
                    CurrentPosition=[myLeft BkBottom myWidth BkHeight];
                    
                    %MyPicStruct.Backgroundwidth=495;%debug
                    
                    
                    %MyLeftPosition=385;%debug
                    %xLim=get(ha(1),'XLim');%debug
                    %CurrentPosition(1)=BkLeft+BkWidth*(MyLeftPosition-xLim(1))/(xLim(2)-xLim(1)); %debug
                    
                    
                    
                    set(hLabel(1),'Position',CurrentPosition);
                    setappdata(hLabel(1),'Step',MyPicStruct.xStep);
                    setappdata(hLabel(1),'t',BkLeft);
                    
                    if MyPicStruct.Debug1==1
                        BkWidth=3*BkWidth;
                    end
                    
                    
                    
                    CurrentPosition=[BkLeft+2*BkWidth BkBottom VerticalWidth BkHeight];
                    set(hLabel(2),'Position',CurrentPosition);
                    setappdata(hLabel(2),'Step',MyPicStruct.xStep);
                    setappdata(hLabel(2),'t',BkLeft);
                    
                    
                    if MyPicStruct.Debug1==1
                        BkBottom=BkBottom-5*BkHeight;
                    end
                    
                    HorizontalHeight=MyPicStruct.Backgroundheight;
                    CurrentPosition=[BkLeft BkBottom-BkHeight BkWidth HorizontalHeight];
                    
                    set(hLabel(3),'Position',CurrentPosition);
                    setappdata(hLabel(3),'Step',HeightUnit);
                    setappdata(hLabel(3),'t',BkBottom);
                    
                    CurrentPosition=[BkLeft BkBottom+2*BkHeight BkWidth HorizontalHeight];
                    set(hLabel(4),'Position',CurrentPosition);
                    setappdata(hLabel(4),'Step',HeightUnit);
                    setappdata(hLabel(4),'t',BkBottom);
                end %MyPicStruct.Backgroundwidth>0  %prepare for move the label
                
                if MyPicStruct.Debug1==1
                    for i=1:length(ha)
                        set(ha(i), 'box','on');
                    end
                end
                
            end %~isempty(ha)
        end %for iC=1:ColumnNumber
    end % for iR=1:RowNumber
    
end %if bresizable
return
