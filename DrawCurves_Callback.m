function DrawCurves_Callback(hObject, eventdata, handles)
%% multichildren function
global iCurrentFigure iTotalFigNum
global bResizable hfig bDrawConfigurationChannel
global MyPicStruct MyCurves moveMouseEvent
% need to associate with figure
moveMouseEvent=0;
bResizable=0;%initial the resizable function

% tic
% profile on
if isempty(MyCurves)
    if isempty(MyCurves)
        ShowWarning(1,'no any Curve exists',handles);
        return
    end
end

%get the control parameter from the view
MyPicStruct=View2Struct(handles);

%% prepare the figure for drawing
% control key force to create a new figure

if  ~isempty(hfig) && ishandle(hfig)  % use the old figure
    bDrawConfigurationChannel=0;
    hChildren=get(hfig,'Children');
    hAxes=findobj(hChildren,'Type','Axes');
    
    clf(hfig)
    %     set(hfig,'Color',MyPicStruct.PicBackgroundColor,'Visible','on','name',['songxm' num2str(hfig.Number)],'Tag',['songxm' num2str(hfig.Number)]);
    set(hfig,'Color',MyPicStruct.PicBackgroundColor,'name',['songxm' num2str(1)],'Tag',['songxm' num2str(1)]);
    myPosition=get(hfig,'Position');
    init=0;
else % create a new figure
    bDrawConfigurationChannel=0;
    if isempty(iCurrentFigure)
        iCurrentFigure=1;
    else
        iCurrentFigure=mod(iCurrentFigure,iTotalFigNum)+1;  % 10 figure allowed
    end
    % name the figure
    hfig=figure('Color',MyPicStruct.PicBackgroundColor,'Visible','off','name',['songxm' num2str(iCurrentFigure)],'Tag',['songxm' num2str(iCurrentFigure)],'DefaultAxesColor',[0.1,0.1,0.1]);
end
%%

%%

figure(hfig)
if MyPicStruct.Modified
    n=InitDrawingParameter;
end

DrawInFigure(hfig);


SetXYTick(MyPicStruct.xTickleft,MyPicStruct.xTickright);
SetLegendYLabel(hfig);
% drawnow;

%% prepare data for later manipulating
associateParameter(hfig)
initFigure(hfig,MyPicStruct,handles)
%myDelay(1);
bResizable=1;
myResize(hfig, [], handles);

set(hfig,'Visible','on');
myXTickLabelTitle(handles)
MyPicStruct.Modified=1;


% profile off
% profile viewer
% td=toc


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

%--------------------------------------------------------------------------
function myKeyFunction(hObject, eventdata, handles)
global  MyPicStruct PicDescription HeightNumber WidthNumber ha YLeftorRight hOldFigure cfgitem5 bInitSize
global hAirFigure hAirView hAirPatch
global bResizable Loc2Axes
global hCursor1 hCursor2 hCursor3 hCursor4 htext
global myLeft myWidth iArrowStep xWindowWidth
global PageAxisNumbers;

%%  Manage the key function


hOldFigure=[];
[BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);

c=get(hObject,'CurrentCharacter');
k=get(hObject,'CurrentKey');

switch lower(k)
    case 'f5'  %  important function, browser in details
        
        % toggle the axes for L or R
        if isempty(YLeftorRight)
            YLeftorRight=0;
        elseif YLeftorRight==0
            YLeftorRight=1;
        elseif YLeftorRight==1
            YLeftorRight=0;
        end
        
        % display the cursor
        if isempty(hCursor1) || ~ishandle(hCursor1)
            hCursor1=annotation('line',[0 0],[0 1]);
            hCursor2=annotation('line',[1 1],[0 1],'color','r');
            hCursor3=annotation('line',[0 1],[0 0]);
            hCursor4=annotation('line',[0 1],[1 1],'color','r');
            htext=annotation('textbox',[0 0 0 0],'EdgeColor','none');
        else
            set(get(hCursor1,'parent'),'parent',gcf)
            set(get(hCursor2,'parent'),'parent',gcf)
            set(get(hCursor3,'parent'),'parent',gcf)
            set(get(hCursor4,'parent'),'parent',gcf)
            set(get(htext,'parent'),'parent',gcf)
        end
        return
    case 'f6'
        s=getOffset(gcf);
        return
    case 'f7'
        s=getCalibrationCoef(gcf);
        return
    case 'escape'
        if isempty(hCursor1) || ~ishandle(hCursor1)
        else
            delete(hCursor1);
            delete(hCursor2);
            delete(hCursor3);
            delete(hCursor4);
            delete(htext);
        end
        return
        
        
        %     case 'end'
        %         if length(HeightNumber)>PageAxisNumbers
        %             HeightNumber(1:end)=0;
        %             HeightNumber(end+1-PageAxisNumbers:end)=1;
        %             myResize(hObject, eventdata, handles)
        %         end
        %         return
        %     case 'home'
        %         if length(HeightNumber)>PageAxisNumbers
        %             HeightNumber(1:end)=0;
        %             HeightNumber(1:PageAxisNumbers)=1;
        %             myResize(hObject, eventdata, handles)
        %         end
        %         return
        %
        %
        %         set(handles.LayoutMode,'value',1);%defining the mode from 0 to 7
        %         PicDescription=[];
        %         %MyPicStruct.Modified=1;
        %         %HeightNumber(1:end)=1;
        %         hOldFigure=gcf;
        %         DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
        %         return
        %     case 'pageup'
        % %         s=ShowNextShot([], [],handles);
        % %         return
        %         if length(HeightNumber)>PageAxisNumbers
        %             index=find(HeightNumber,1,'first');
        %             if index-PageAxisNumbers>=1
        %                 HeightNumber(1:end)=0;
        %                 HeightNumber(index-PageAxisNumbers:index-1)=1;
        %             else
        %                 HeightNumber(1:end)=0;
        %                 HeightNumber(1:PageAxisNumbers)=1;
        %             end
        %             myResize(hObject, eventdata, handles)
        %         end
        %         return
        %     case 'pagedown'
        % %         s=ShowLastShot([], [],handles);
        % %         return
        %         if length(HeightNumber)>PageAxisNumbers
        %             index=find(HeightNumber,1,'last');
        %             if index+PageAxisNumbers<=length(HeightNumber)
        %                 HeightNumber(1:end)=0;
        %                 HeightNumber(index+1:index+PageAxisNumbers)=1;
        %             else
        %                 HeightNumber(1:end)=0;
        %                 HeightNumber(end+1-PageAxisNumbers:end)=1;
        %             end
        %             myResize(hObject, eventdata, handles)
        %         end
        %         return
        
        
        %% move the picture
    case 'v'
        %         s=mySizable(cfgitem5, [],handles);
        %         return
        position=get(ha,'position');
        L=length(position);
        if iscell(position)
            position=cell2mat(position);
            position(:,2)=position(:,2)-20;
            position=mat2cell(position,ones(1,L),4);
            set(ha,{'position'},position);
        else
            position(:,2)=position(:,2)-20;
            set(ha,'position',position);
        end
        
        return
    case 'n'
        position=get(ha,'position');
        L=length(position);
        if iscell(position)
            position=cell2mat(position);
            position(:,2)=position(:,2)+20;
            position=mat2cell(position,ones(1,L),4);
            set(ha,{'position'},position);
        else
            position(:,2)=position(:,2)+20;
            set(ha,'position',position);
        end
        
        return
    case 'b'
        position=get(ha,'position');
        L=length(position);
        if iscell(position)
            position=cell2mat(position);
            position(:,1)=position(:,1)-20;
            position=mat2cell(position,ones(1,L),4);
            set(ha,{'position'},position);
        else
            position(:,1)=position(:,1)-20;
            set(ha,'position',position);
        end
        
        return
    case 'c'
        position=get(ha,'position');
        L=length(position);
        if iscell(position)
            position=cell2mat(position);
            position(:,1)=position(:,1)+20;
            position=mat2cell(position,ones(1,L),4);
            set(ha,{'position'},position);
        else
            position(:,1)=position(:,1)+20;
            set(ha,'position',position);
        end
        
        return
        
        %%
    case {'r','R'}
        if MyPicStruct.Resizable==1
            MyPicStruct.Resizable=0;
            set(gcf,'resize','off');
        elseif MyPicStruct.Resizable==0
            MyPicStruct.Resizable=1;
            set(gcf,'resize','on');
        end
        return
    case {'m','M'}
        if MyPicStruct.ShowMenu==1
            MyPicStruct.ShowMenu=0;
            set(gcf,'MenuBar','none');
        elseif MyPicStruct.ShowMenu==0
            MyPicStruct.ShowMenu=1;
            set(gcf,'MenuBar','figure');
        end
        return
    case 't'
        s=ChangePictureConfiguration([], [],handles);
        return
    case 'z'
        s=myChangeLayer([], [],handles);
        return
    case 'f12'
        if MyPicStruct.MyTransparencyValue==1
            MyPicStruct.MyTransparencyValue=0.5;
        elseif MyPicStruct.MyTransparencyValue==0.5
            MyPicStruct.MyTransparencyValue=1;
        end
        MyPicStruct.Modified=1;
        hOldFigure=gcf;
        DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
        return
    case {'u','U'}
        xLimit=get(ha(1),'XLim');
        UpdataY(hObject,xLimit(1),xLimit(2));
%         MyPicStruct.xTickleft=xLimit(1);
%         MyPicStruct.xTickright=xLimit(2);
%        DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
        return
    case {'h','H'}
        Num=length(HeightNumber);
        for i=1:Num
            prompt{i}=strcat('height of axes',num2str(i));
            def{i}=num2str(HeightNumber(i));
        end
        dlg_title = 'Modify the Axis height';
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        for i=1:Num
            HeightNumber(i)=str2num(answer{i});
        end
        
        prompt=[];
        def=[];
        
        Num=length(WidthNumber);
        for i=1:Num
            prompt{i}=strcat('width of axes',num2str(i));
            def{i}=num2str(WidthNumber(i));
        end
        dlg_title = 'Modify the Axis height';
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        for i=1:Num
            WidthNumber(i)=str2num(answer{i});
        end
        if ishandle(hAirFigure)
            delete(hAirFigure)
        end
        bResizable=1;
        myResize(hObject, eventdata, handles)
        SetXYTick(MyPicStruct.xTickleft,MyPicStruct.xTickright);
        return
        
        
    case {'p','P'}
        if MyPicStruct.isPublish==0
            MyPicStruct.isPublish=1;
            MyPicStruct.DefaultTextFontWeight='bold';
            MyPicStruct.DefaultTextFontSize=14;
            MyPicStruct.DefaultAxesFontWeight='bold';
            MyPicStruct.DefaultAxesFontSize=14;
            MyPicStruct.DefaultAxesLineWidth=1;
            MyPicStruct.FigureWidth=800;
            MyPicStruct.FigureHeight=600;
            MyPicStruct.RightDigit=0;%control the fractional part of the YTickLabel
        elseif MyPicStruct.isPublish==1
            MyPicStruct.isPublish=0;
            
            MyPicStruct.DefaultTextFontWeight='bold';
            MyPicStruct.DefaultTextFontSize=14;
            MyPicStruct.DefaultAxesFontWeight='bold';
            MyPicStruct.DefaultAxesFontSize=14;
            MyPicStruct.DefaultAxesLineWidth=1;
            MyPicStruct.FigureWidth=800;
            MyPicStruct.FigureHeight=600;
            MyPicStruct.RightDigit=0;%control the fractional part of the YTickLabel

%             MyPicStruct.DefaultTextFontWeight='normal';
%             MyPicStruct.DefaultTextFontSize=12;
%             MyPicStruct.DefaultAxesFontWeight='normal';
%             MyPicStruct.DefaultAxesFontSize=12;
%             MyPicStruct.DefaultAxesLineWidth=1;
%             MyPicStruct.FigureWidth=0;
%             MyPicStruct.FigureHeight=0;
%             MyPicStruct.RightDigit=3;%control the fractional part of the YTickLabel
            
        end
        %         PicDescription=[];
        DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
        return;
    case {'y','Y'}
        if MyPicStruct.YLimitAuto==0
            MyPicStruct.YLimitAuto=1;
        elseif MyPicStruct.YLimitAuto==1
            MyPicStruct.YLimitAuto=0;
        end
        Struct2View(handles);
        DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
        return
    case {'s','S'}
        s=SetFigureSize(hObject, eventdata,handles);
        return
    case {'x','X'}
        s=SetFigureProperty([], eventdata,handles);
        return
    case {'k','K'}
        if MyPicStruct.YTickNum==3
            MyPicStruct.YTickNum=5;
        elseif MyPicStruct.YTickNum==5
            MyPicStruct.YTickNum=3;
        end
        DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
        return
    case {'L','l'}
        if MyPicStruct.LegendYLabelMode==0
            MyPicStruct.LegendYLabelMode=1;
        elseif MyPicStruct.LegendYLabelMode==1
            MyPicStruct.LegendYLabelMode=2;
        elseif MyPicStruct.LegendYLabelMode==2
            MyPicStruct.LegendYLabelMode=0;
        end
        DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
        return
    case {'W','w'}
        if MyPicStruct.yTickMarginMode==0
            MyPicStruct.yTickMarginMode=1;
        elseif MyPicStruct.yTickMarginMode==1
            MyPicStruct.yTickMarginMode=2;
        elseif MyPicStruct.yTickMarginMode==2
            MyPicStruct.yTickMarginMode=0;
        end
        DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
        return
    case {'o','O'}
%         s=myAddShadow([], [],[],0); % mouse input
        s=myAddArrowText();
        return
    case {'a','A'}
        s=myAddShadow([], [],[],1); % text input
        return
        if MyPicStruct.YAutoInteger==0
            MyPicStruct.YAutoInteger=1;
        elseif MyPicStruct.YAutoInteger==1
            MyPicStruct.YAutoInteger=0;
        end
        MyPicStruct.Modified=0;
        
        DrawCurves_Callback(handles.DrawCurves, eventdata, handles);
        return
        
        
end
%move the label
hLabel=getappdata(hObject,'ShadowHandle');

% move the data-showing window
%%--------------------------------------------------------
%force to redefine the function of arrow key

MyPicStruct.xright=str2double(get(handles.xRight,'String'));
MyPicStruct.xStep=str2double(get(handles.xStep,'String'));
MyPicStruct.xleft=str2double(get(handles.xLeft,'String'));


if isempty(iArrowStep) || iArrowStep==0
    iArrowStep=1;
end

if isempty(xWindowWidth)
    xWindowWidth=0;
end

%% Luo Cuiwen function , broswer the high sampling data in small windows
switch k
    
    case 'leftarrow'
        xWindowWidth=MyPicStruct.xright-MyPicStruct.xleft;
    case 'rightarrow'
        xWindowWidth=-(MyPicStruct.xright-MyPicStruct.xleft);
        
        
    case 'uparrow'
        if iArrowStep<1000
            iArrowStep=iArrowStep*10;
        end
        
        
    case 'downarrow'
        if iArrowStep>1
            iArrowStep=iArrowStep/10;
        end
    otherwise
        return
end

MyPicStruct.xright=MyPicStruct.xright-iArrowStep*xWindowWidth;
MyPicStruct.xleft=MyPicStruct.xleft-iArrowStep*xWindowWidth;



set(handles.xLeft,'string',num2str(MyPicStruct.xleft));
set(handles.xRight,'string',num2str(MyPicStruct.xright));
set(handles.xStep,'string',num2str(MyPicStruct.xStep));
UpdateShot_Callback([], eventdata, handles);
return

%%--------------------------------------------------------


%--------------------------------------------------------------------------
function myButtonMotion(hObject, eventdata, handles)
global MyPicStruct ha HeightNumber WidthNumber Loc2Axes YLeftorRight hfig
global hCursor1 hCursor2 hCursor3 hCursor4 htext
global trajectoryPoint mouseEventDown moveMouseEvent
persistent  eventInTime eventOutTime isInState isOutState bDrawConfigurationChannel

StartPoint=get(hObject,'CurrentPoint');  %new point
trajectoryPoint=[trajectoryPoint StartPoint'];

%
% EndPoint=get(hObject,'CurrentPoint');

if mouseEventDown
    initialPoint=getappdata(hObject,'StartPoint');
    hRbbox=getappdata(hObject,'hRbbox');
    
    Position=get(hObject,'Position');
    
    position=[initialPoint(1)/Position(3) StartPoint(2)/Position(4)    (StartPoint(1)-initialPoint(1))/Position(3) (initialPoint(2)-StartPoint(2))/Position(4)];
    set(hRbbox,'Position',position)
end

if ishandle(hfig)
    hcfg=getappdata(hfig,'hcfg');
else
    return
end
if bDrawConfigurationChannel
    
    if isempty(hcfg)
        return
    else
        hfconfiguration=hcfg.hfconfiguration;
    end
end
if moveMouseEvent; return; end;
k=get(hObject,'currentkey');


if isempty(mouseEventDown) || ~mouseEventDown
    
    if strcmp(k,'f5')
        %move the Line by mouse movement
        %2 is the former fix point and the 1 is the new moving point
        if isempty(hCursor1) || ~ishandle(hCursor1)
        else
            figPos=get(hObject,'position');
            set(hCursor1,'X',[StartPoint(1)/figPos(3) StartPoint(1)/figPos(3)])
            set(hCursor3,'Y',[StartPoint(2)/figPos(4) StartPoint(2)/figPos(4)])
            
            [Row,Col,Pos]=getGridPosition(hObject,StartPoint);
            indexLoc=Row+(Col-1)*(MyPicStruct.RowNumber);
            
            xLim=get(ha(indexLoc),'XLim');
            axesPos=get(ha(indexLoc),'position');
            
            X1=xLim(1)+(xLim(2)-xLim(1))*(StartPoint(1)-axesPos(1))/axesPos(3);
            xReferencePos=get(hCursor2,'X')*figPos(3);  %reference point   fixed older one
            X2=xLim(1)+(xLim(2)-xLim(1))*(xReferencePos(1)-axesPos(1))/axesPos(3);
            
            yReferencePos=get(hCursor4,'Y')*figPos(4);
            
            refPos=[xReferencePos(1) yReferencePos(1)]; % the point for reference
            [Row2,Col2,Pos2]=getGridPosition(hObject,refPos);
            indexLoc2=Row2+(Col2-1)*(MyPicStruct.RowNumber);
            
            [P1,L1,P2,L2]=getPositionLocation(hObject,StartPoint(2),yReferencePos(1));  %get pos from the y pos
            
            %        ha1=cell2mat(Loc2Axes(L1));%new moving point
            ha1=indexLoc;%new moving point
            
            
            if isempty(ha1)
                return
            end
            %        ha2=cell2mat(Loc2Axes(L2)); %older fixed point
            ha2=indexLoc2; %older fixed point
            
            [BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
            NTotal=sum(HeightNumber);
            HeightUnit=BkHeight/NTotal;
            
            
            %prepare the value
            if YLeftorRight==1 %left
                %older
                yLim=get(ha(ha1(1)),'YLim');
                Y1=yLim(1)+(yLim(2)-yLim(1))*(StartPoint(2)+1.5-P1*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L1));
                %new
                yLim=get(ha(ha2(1)),'YLim');
                Y2=yLim(1)+(yLim(2)-yLim(1))*(yReferencePos(1)+1.5-P2*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L2));
            elseif YLeftorRight==0 %right
                if length(ha1)>1
                    yLim=get(ha(ha1(2)),'YLim');  %second axis
                    Y1=yLim(1)+(yLim(2)-yLim(1))*(StartPoint(2)+1.5-P1*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L1));
                else
                    yLim=get(ha(ha1(1)),'YLim');
                    Y1=yLim(1)+(yLim(2)-yLim(1))*(StartPoint(2)+1.5-P1*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L1));
                end
                if length(ha2)>1
                    yLim=get(ha(ha2(2)),'YLim');   %second axis
                    Y2=yLim(1)+(yLim(2)-yLim(1))*(yReferencePos(1)+1.5-P2*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L2));
                else
                    yLim=get(ha(ha2(1)),'YLim');
                    Y2=yLim(1)+(yLim(2)-yLim(1))*(yReferencePos(1)+1.5-P2*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L2));
                end
            end
            
            
            if indexLoc==indexLoc2
                if YLeftorRight==1
                    i=1;
                    mytext={['x=',num2str(X1)];['y',num2str(i),'=',num2str(Y1)];['dx=',num2str(X2-X1)];['dy=',num2str(Y2-Y1)]};
                elseif YLeftorRight==0
                    i=2;
                    mytext={['x=',num2str(X1)];['y',num2str(i),'=',num2str(Y1)];['dx=',num2str(X2-X1)];['dy=',num2str(Y2-Y1)]};
                end
            else
                if YLeftorRight==1
                    i=1;
                    mytext={['x=',num2str(X1)];['y',num2str(i),'=',num2str(Y1)];['dx=',num2str(X2-X1)];['dy=','nan']};
                elseif YLeftorRight==0
                    i=2;
                    mytext={['x=',num2str(X1)];['y',num2str(i),'=',num2str(Y1)];['dx=',num2str(X2-X1)];['dy=','nan']};
                end
                
            end
            set(htext,'string',mytext,'Position',[StartPoint(1)/figPos(3) StartPoint(2)/figPos(4) 0.1 0.1])
        end
    end
    %% auto show channel menu
    if bDrawConfigurationChannel
        if ~ishandle(hfconfiguration);return;end;
        responseDelay=0.1; %in second
        cP=get(hObject,'CurrentPoint');
        currentTime=clock;
        
        pDrawCurves=get(hfconfiguration,'position');
        pDrawCurves(1)=pDrawCurves(1)+50;
        
        if cP(1)>pDrawCurves(1) && cP(1)<pDrawCurves(1)+pDrawCurves(3) % && cP(2)>pDrawCurves(2) && cP(2)<pDrawCurves(2)+pDrawCurves(4)
            if isempty(eventInTime)
                eventInTime=currentTime(6); %the 6 element is second
                eventOutTime=[];
                isInState=1;
            end
            
            if isInState && (currentTime(6)-eventInTime>responseDelay)
                set(hfconfiguration,'Position',getappdata(hfconfiguration,'size1'))
                isInState=0;
                moveMouseEvent=1;
            end
            return
        else
            if isempty(eventOutTime)
                eventOutTime=currentTime(6); %the 6 element is second
                eventInTime=[];
                isOutState=1;
            end
            if isOutState && (currentTime(6)-eventOutTime>responseDelay)
                ResizeDataProc2(handles)
                isOutState=0;
            end
        end
    end
    
end
%--------------------------------------------------------------------------


function myButtonDown(hObject, eventdata, handles)
global hAirFigure hAirView hAirPatch
global hLines ha  Location
global bFigActive iTotalFigNum
global  Lines2Axes Axes2Lines Axes2Loc Loc2Axes HeightNumber WidthNumber MyPicStruct PicDescription MyCurves LocationLeftRight NumShot
global trajectoryPoint mouseEventDown
trajectoryPoint=[];


mouseEventDown=1;
iCurrentIndex=getappdata(hObject,'iCurrentIndex');
if 0
    if ~isempty(bFigActive)
        if ~bFigActive(iCurrentIndex)==1
            bFigActive=zeros(1,iTotalFigNum);
            bFigActive(iCurrentIndex)=1;
        end
    else
        return
    end
end

if 1
    % check if load is needed
    MyCurveList=get(handles.lbCurves,'String');
    FileName=strcat('myFig',num2str(iCurrentIndex));
    cfgFile=fullfile(getDProot('temp'),FileName);
    if exist(cfgFile,'file')
        if isempty(MyCurveList)
            index=1;
        else
            oldMyCurves=MyCurves;
            load(cfgFile, 'MyCurves')
            MyCurveList1={MyCurves(:).ChnlName};
            MyCurves=oldMyCurves; % restore
            
            MyCurveList1=reshape(MyCurveList1,[],1);
            if length(MyCurveList1)~=length(MyCurveList)
                index=1;
            else
                
                indexLists=regexpi(MyCurveList,MyCurveList1,'start');
                index=cellfun(@isempty,indexLists);
            end
        end
        
        if sum(index)>0
            load(cfgFile, 'MyCurveList','MyPicStruct','PicDescription','MyCurves','Lines2Axes','Lines2Axes','Axes2Lines','Axes2Loc','Loc2Axes','HeightNumber','WidthNumber')
            MyCurveList={MyCurves(:).ChnlName};
            set(handles.lbCurves,'String',MyCurveList);%
            set(handles.lbCurves,'value',1);%
        end
    end
end


k=get(hObject,'currentkey');
selctType = get(hObject,'SelectionType');
if strmatch(k,'f6','exact')
    return
end

[BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
M=length(HeightNumber);


% [n,ha,MyPicStruct,hXLabel,PicDescription,HeightNumber,M,figLBWH,BkLeft,BkBottom,BkWidth,BkHeight]=getPicProperty(hObject);

StartPoint=get(hObject,'CurrentPoint');
setappdata(hObject,'StartPoint',StartPoint)
% k = waitforbuttonpress;
% finalRect=rbbox;
rect_pos=[StartPoint 50 50];
Position=get(hObject,'Position');
rect_pos=[rect_pos(1)/Position(3) rect_pos(2)/Position(4) rect_pos(3)/Position(3) rect_pos(4)/Position(4)];

hRbbox=annotation('rectangle',rect_pos,'Color','red') ;
setappdata(hObject,'hRbbox',hRbbox)


if strcmp(selctType,'extend')
    hAirFigure=findobj(0,'type','figure','Tag','AirFigure');
    if isempty(hAirFigure)
        airPos = get(0,'ScreenSize');
        airPos = airPos/6;
        PicPos = airPos;
        PicPos(1) = PicPos(2)+5;
        PicPos(2) = PicPos(2)+31;
        hAirFigure=figure('Position',PicPos,'MenuBar','none','Tag','AirFigure','Name','The AirView for Current Wave','Resize','off','Color','none','WindowButtonDownFcn',{@AirButtonDownFcn});
        hLines=getappdata(hObject,'hLines');
        BkLeft=BkLeft/5-17;
        BkBottom=BkBottom/5-13;
        BkWidth=BkWidth/5;
        BkHeight=BkHeight/5;
        NTotal=sum(HeightNumber);
        HeightUnit=BkHeight/(sum(HeightNumber));
        Location1={PicDescription.Location};%cell array is ok.
        Location=cell2mat(Location1);
        LeftRight1={PicDescription.Right};
        LeftRight=cell2mat(LeftRight1);
        
        CurrentAxes=0;
        hAirView=[];%init
        %Create axis and lines
        for i=1:M %for location
            Lnum=sum(HeightNumber(1:i));
            for j=0:1 %for LeftRight
                A=abs(Location-i)+abs(LeftRight-j);
                index=find(A==0);
                if ~isempty(index)
                    CurrentAxes=CurrentAxes+1;
                    hAirView(CurrentAxes)=axes('Units','pixels','Position',[1 1 1 1],'Box','on');
                    hLines=findobj(ha(CurrentAxes),'Type','line');
                    for ii=1:length(index)
                        hAirLines(index(ii))=line('Parent',hAirView(CurrentAxes),'Color',PicDescription(index(ii)).Color,'Marker',PicDescription(index(ii)).Marker,'LineStyle',PicDescription(index(ii)).LineStyle);
                        %hLines(index(ii))=line('Parent',ha(CurrentAxes),'Color',PicDescription(index(ii)).Color,'Marker',PicDescription(index(ii)).Marker,'LineStyle',PicDescription(index(ii)).LineStyle);
                    end
                    
                    %myXLim=get(ha(CurrentAxes),'XLim');
                    %myYLim=get(ha(CurrentAxes),'YLim');
                    myXData=get(hLines,'XData');
                    myYData=get(hLines,'YData');
                    %set the curves data
                    if length(index)>1
                        set(hAirLines(index),{'XData'},myXData,{'YData'},myYData);
                    else
                        set(hAirLines(index),'XData',myXData,'YData',myYData);
                    end
                    
                    
                    if HeightNumber(i)==0
                        set(hAirView(CurrentAxes),'Position',[2000+BkLeft BkBottom+BkHeight-HeightUnit*Lnum BkWidth HeightUnit]);%,'replace'
                        %                          set(ha(CurrentAxes),'Position',[2000+BkLeft BkBottom+BkHeight-HeightUnit*Lnum BkWidth HeightUnit]);%move out our sight
                    else
                        set(hAirView(CurrentAxes),'Position',[BkLeft BkBottom+BkHeight-HeightUnit*Lnum BkWidth HeightUnit*HeightNumber(i)]);%,'replace'
                        %                               set(ha(CurrentAxes),'Position',[BkLeft BkBottom+BkHeight-HeightUnit*Lnum BkWidth HeightUnit*HeightNumber(i)-GapHeight]);%set the size
                    end
                    
                end% if
            end
        end
        
        
        %set YLim
        yLimit=getappdata(hObject,'yLimit');
        [m1,n1]=size(yLimit);
        for i=1:n1
            yLim(i)={[yLimit(1,i),yLimit(2,i)]};
        end
        
        
        %set XLim
        if strmatch(get(handles.R1,'String'),'edit')
            MyPicStruct.xright=str2num(get(handles.xRight,'String'));
            MyPicStruct.xStep=str2num(get(handles.xStep,'String'));
            MyPicStruct.xleft=str2num(get(handles.xLeft,'String'));
        elseif strmatch(get(handles.R1,'String'),'popupmenu')
            Lstring=get(handles.xLeft,'string');
            Rstring=get(handles.xRight,'string');
            Sstring=get(handles.xStep,'string');
            MyPicStruct.xright=str2num(Rstring{get(handles.xRight,'value')});
            MyPicStruct.xStep=str2num(Sstring{get(handles.xStep,'value')});
            MyPicStruct.xleft=str2num(Lstring{get(handles.xLeft,'value')});
        end
        MyPicStruct.xTickright=MyPicStruct.xright;
        MyPicStruct.xTickleft=MyPicStruct.xleft;
        
        [L,S,R]=gettheXTick(MyPicStruct.xTickleft, MyPicStruct.xTickright);
        if S>0.0001
            MyPicStruct.xTickright=R;
            MyPicStruct.xTickleft=L;
            MyPicStruct.xStep=S;
        end
        
        xLim=[MyPicStruct.xTickleft MyPicStruct.xTickright];%get the x coordinate for non modified MyPicStruct
        hAirView=reshape(hAirView,length(hAirView),1);
        yLim=reshape(yLim,length(yLim),1);
        
        if length(hAirView)>1
            set(hAirView,{'XLim'},{xLim},{'YLim'},yLim);
        else
            set(hAirView,'XLim',xLim,'YLim',yLim{1});
        end
        
        if length(hAirView)>1
            set(hAirView,{'Color'},{'none'},{'XColor'},{'w'},{'YColor'},{'w'},{'XTick'},{[]},{'YTick'},{[]});
        else
            set(hAirView,'Color','none','XColor','w','YColor','w','XTick',[],'YTick',[]);
        end
        PicPos=get(hObject,'Position');
        %         hAirPatch=annotation('textbox',[finalRect(1)/PicPos(3) finalRect(2)/PicPos(4) finalRect(3)/PicPos(3) finalRect(4)/PicPos(4)],'FaceAlpha',0.5,...
        %                   'BackgroundColor','r','ButtonDownFcn','@myPatchButtonDownFcn,handles');,'EdgeColor','m'
        hAirPatch=annotation('textbox',[finalRect(1)/PicPos(3) finalRect(2)/PicPos(4) finalRect(3)/PicPos(3) finalRect(4)/PicPos(4)],...
            'BackgroundColor','none','LineWidth',1);
        %hAirPatch=annotation('textbox',[0 3/4 1/4 1/4],'FaceAlpha',0.5,'BackgroundColor','r');
        %hAirPatch=annotation('textbox',[0 0 1 1],'FaceAlpha',1);
        
        setappdata(hAirFigure,'hAxis',hAirView);
    else
    end
    figure(hObject);
    figure(hAirFigure);
    plotedit off
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function myButtonUp(hObject, eventdata, handles)
global MyPicStruct PicDescription hVECValue myVECChannels hLines ha hselectLine  Location Axes2Lines Loc2Axes
global hCursor1 hCursor2 hCursor3 hCursor4 HeightNumber WidthNumber
global trajectoryPoint indexLoc mouseEventDown

if mouseEventDown
    hRbbox=getappdata(hObject,'hRbbox');
    if ishandle(hRbbox)
        delete(hRbbox)
    end
end


mouseEventDown=0;
k=get(hObject,'currentkey');
if strmatch(k,'f6','exact')
    return
end






EndPoint=get(hObject,'CurrentPoint');
StartPoint=getappdata(hObject,'StartPoint');
k=get(hObject,'currentkey');
%%  gesture
gesType=getGesture(trajectoryPoint);


% endpoint is the focus position
[Row,Col,Pos]=getGridPosition(hObject,EndPoint);
indexLoc=Row+(Col-1)*(MyPicStruct.RowNumber);
indexAxis=Loc2Axes{indexLoc};

if    gesType==12
    ZoomIn(Row,Col)
    myResize(hObject, eventdata, handles)
    set(ha(indexAxis(1)),{'XTickLabelMode'},{'auto'});
    return
end
% if EndPoint(2)<StartPoint(2)  && abs(EndPoint(1)-StartPoint(1))/abs(EndPoint(2)-StartPoint(2))<0.2
if    gesType==11
    ZoomOut
    myResize(hObject, eventdata, handles)
    xlim= get(ha(indexAxis(1)),'xlim');
    SetXYTick(xlim(1),xlim(2))
    return
end







if ~isempty(strmatch(k,'f5','exact'))
    %move the Line by mouth drag
    if isempty(hCursor1) || ~ishandle(hCursor1)
    else
        figPos=get(hObject,'position');
        set(hCursor2,'X',[StartPoint(1)/figPos(3) StartPoint(1)/figPos(3)])
        set(hCursor4,'Y',[StartPoint(2)/figPos(4) StartPoint(2)/figPos(4)])
    end
end




if ~isempty(strmatch(k,'control','exact'))
    %move the Label by mouth drag
    hLabel=getappdata(hObject,'hLabel');
    if ~isempty(hLabel)
        ish=ishandle(hLabel);
        if ~ish(1)
            msgbox('Label is not OK')
        end
    end
    
    
    
    if MyPicStruct.PrintBrowseMode==1
        set(hLabel,{'XColor'},{'w'},{'YColor'},{'w'});
    elseif MyPicStruct.PrintBrowseMode==0
        set(hLabel,{'XColor'},{'k'},{'YColor'},{'k'});
    end
    if ~isempty(hLabel)
        CurrentPosition=get(hLabel(2),'Position');
        CurrentPosition(1)=StartPoint(1);
        CurrentPosition(3)=1;
        
        set(hLabel(2),'Position',CurrentPosition);
        setappdata(hLabel(2),'t',CurrentPosition(1));
        
        CurrentPosition=get(hLabel(4),'Position');
        CurrentPosition(2)=StartPoint(2);
        CurrentPosition(4)=1;
        
        set(hLabel(4),'Position',CurrentPosition);
        setappdata(hLabel(4),'t',CurrentPosition(2));
        
        %         UpdateOscillograph(hObject)
    end
    return
end



if ~isempty(StartPoint)
    xLeft=min(StartPoint(1),EndPoint(1));
    xRight=max(StartPoint(1),EndPoint(1));
    yBottom=min(StartPoint(2),EndPoint(2));
    yTop=max(StartPoint(2),EndPoint(2));
    %coordinate transformation
    [BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
    M=length(HeightNumber);
    n=length(PicDescription);
    
    
    
    %      [n,ha,MyPicStruct,hXLabel,PicDescription,HeightNumber,M,figLBWH,BkLeft,BkBottom,BkWidth,BkHeight]=getPicProperty(hObject);
    if isempty(n)
        return
    end
    
    
    
    if indexLoc<1 || indexLoc>length(ha)
        return
    end
    xLim=get(ha(indexLoc),'XLim');
    
    NTotal=sum(HeightNumber);
    HeightUnit=BkHeight/NTotal;
    
    if StartPoint(1)<EndPoint(1)
        %begin coordinate transformation
        %x coordinates
        xLeft=xLim(1)+(xLim(2)-xLim(1))*(xLeft-Pos(1))/Pos(3);
        xRight=xLim(1)+(xLim(2)-xLim(1))*(xRight-Pos(1))/Pos(3);
        
        
        [L,S,R]=gettheXTick(xLeft,xRight);
        if S>0.000001
            MyPicStruct.xTickright=R;
            MyPicStruct.xTickleft=L;
            MyPicStruct.xStep=S;
        end
        
        
        [P1,L1,P2,L2]=getPositionLocation(hObject,yBottom,yTop);
        % current focus on L2  (top location number)
        setappdata(0,'currentLine',L1);
        
        if L1==L2
            %set the YLim
            Location1={PicDescription.Location};%cell array is ok.
            Location=cell2mat(Location1);
            LeftRight1={PicDescription.Right};
            LeftRight=cell2mat(LeftRight1);
            
            CurrentAxes=0;
            for i=1:M %for location
                Lnum=sum(HeightNumber(1:i));
                for j=0:1 %for LeftRight
                    A=abs(Location-i)+abs(LeftRight-j);
                    index=find(A==0);
                    if ~isempty(index)
                        CurrentAxes=CurrentAxes+1;
                        if i==L1
                            yLim=get(ha(CurrentAxes),'YLim');
                            yB=yLim(1)+(yLim(2)-yLim(1))*(yBottom-P1*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L1));
                            yT=yLim(1)+(yLim(2)-yLim(1))*(yTop-P2*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L1));
                            yLim(1)=yB;%bottom
                            yLim(2)=yT;%top
                            set(ha(CurrentAxes),'YLim',yLim);
                            Yy=MyYTick(ha(CurrentAxes),MyPicStruct.YTickNum*HeightNumber(L1),MyPicStruct.RightDigit+2);
                        end%if i==L1
                    end% if
                end
            end
        else%if L1==L2
        end%if L1==L2
    elseif StartPoint(1)>EndPoint(1) %if StartPoint(1)<EndPoint(1)
        yLimit=getappdata(hObject,'yLimit');
        [m1,n1]=size(yLimit);
        for i=1:n1
            yLim=[yLimit(1,i),yLimit(2,i)];
            set(ha(i),'YLim',yLim);
            %             if HeightNumber(mod(PicDescription(i).Location-1,MyPicStruct.RowNumber)+1)==0
            %             else
            %                 indexLine=Axes2Lines{i};
            %                 Yy=MyYTick(ha(i),MyPicStruct.YTickNum*HeightNumber(mod(PicDescription(indexLine(1)).Location-1,MyPicStruct.RowNumber)+1),PicDescription(i).RightDigit);
            %             end
        end
        
        
        if strcmp(get(handles.xRight,'style'),'edit')
            MyPicStruct.xright=str2num(get(handles.xRight,'String'));
            MyPicStruct.xStep=str2num(get(handles.xStep,'String'));
            MyPicStruct.xleft=str2num(get(handles.xLeft,'String'));
        elseif strcmp(get(handles.xRight,'style'),'popupmenu')
            Lstring=get(handles.xLeft,'string');
            Rstring=get(handles.xRight,'string');
            Sstring=get(handles.xStep,'string');
            MyPicStruct.xright=str2num(Rstring{get(handles.xRight,'value')});
            MyPicStruct.xStep=str2num(Sstring{get(handles.xStep,'value')});
            MyPicStruct.xleft=str2num(Lstring{get(handles.xLeft,'value')});
        end
        MyPicStruct.xTickright=MyPicStruct.xright;
        MyPicStruct.xTickleft=MyPicStruct.xleft;
        [L,S,R]=gettheXTick(MyPicStruct.xTickleft, MyPicStruct.xTickright);
        if S>0.0001
            MyPicStruct.xTickright=R;
            MyPicStruct.xTickleft=L;
            MyPicStruct.xStep=S;
        end
        
    else%if StartPoint(1)<EndPoint(1)
        return
    end%if StartPoint(1)<EndPoint(1)
    SetXYTick(L,R)
    
    if sum(HeightNumber)+sum(WidthNumber)==2
        set(ha(indexLoc),{'XTickLabelMode'},{'auto'});
    end
    UpdateOscillograph(hObject);
end%~isempty(StartPoint)
setappdata(0,'MyPicStruct',MyPicStruct);



%--------------------------------------------------------------------------
function AirButtonDownFcn(hObject, eventdata)
global hAirFigure hAirView hAirPatch hfig
set(hAirFigure,'Renderer','zbuffer')
finalRect=rbbox;
PicPos=get(hAirFigure,'Position');
set(hAirPatch,'Position',[finalRect(1)/PicPos(3) finalRect(2)/PicPos(4) finalRect(3)/PicPos(3) finalRect(4)/PicPos(4)]);
updatezoom(hfig)
figure(hfig)
figure(hAirFigure)

%--------------------------------------------------------------------------
% function myCurveOK(hObject, eventdata, hfig)
function updatezoom(hfig)
global  Lines2Axes Axes2Lines Axes2Loc Loc2Axes HeightNumber MyPicStruct
global hAirFigure hAirView hAirPatch

[BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hObject);
% [n,ha,MyPicStruct,hXLabel,PicDescription,HeightNumber,M,figLBWH,BkLeft,BkBottom,BkWidth,BkHeight]=getPicProperty(hAirFigure);




ha=getappdata(hfig,'hAxis');
%NTotal=sum(HeightNumber);
AxesPos=get(hAirView(end),'position');

BkHeight=AxesPos(4)*sum(HeightNumber)/HeightNumber(end);
HeightUnit=BkHeight/sum(HeightNumber);
PatchPos=get(hAirPatch,'Position');
FigurePos=get(hAirFigure,'Position');

yBottom=PatchPos(2)*FigurePos(4);
yTop=yBottom+PatchPos(4)*FigurePos(4);
[P1,L1,P2,L2]=getPositionLocation(hAirFigure,yBottom,yTop);
if L1==L2
    indexmodified=Loc2Axes{L1};
    for CurrentAxes=1:length(indexmodified) %for location
        yLim=get(hAirView(indexmodified(CurrentAxes)),'YLim');
        yB=yLim(1)+(yLim(2)-yLim(1))*(yBottom-P1*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L1));
        yT=yLim(1)+(yLim(2)-yLim(1))*(yTop-P2*HeightUnit-BkBottom)/(HeightUnit*HeightNumber(L1));
        yLim(1)=yB;%bottom
        yLim(2)=yT;%top
        set(ha(indexmodified(CurrentAxes)),'YLim',yLim);
        Yy=MyYTick(ha(indexmodified(CurrentAxes)),MyPicStruct.YTickNum*HeightNumber(L1),MyPicStruct.RightDigit+2);
    end
end
AirXLim=get(hAirView(1),'XLim');
trange(1)=AirXLim(1)+(AirXLim(2)-AirXLim(1))*PatchPos(1);
trange(2)=trange(1)+(AirXLim(2)-AirXLim(1))*PatchPos(3);
[L,S,R]=gettheXTick(trange(1), trange(2));
if S>0.0001
    MyPicStruct.xTickright=R;
    MyPicStruct.xTickleft=L;
    MyPicStruct.xStep=S;
end

% set(ha,{'XLim'},{trange},{'XTick'},{[MyPicStruct.xTickleft:MyPicStruct.xStep:MyPicStruct.xTickright]},{'TickDir'}, {'in'},{'XTickLabel'},{[]});
% set(ha(end),'XTick',[MyPicStruct.xTickleft:MyPicStruct.xStep:MyPicStruct.xTickright],'TickDir', 'in','XTickLabelMode','auto','TickLength',[0.005 0.005]);
% --------------------------------------------------------------------

%delete(hObject)
function myDeleteFcn(hObject, eventdata, handles)


% global hAirFigure
% if ~isempty(hAirFigure) && ishandle(hAirFigure)
%     delete(hAirFigure);
% end
% delete(hObject);





function myPatchButton(hObject, eventdata, handles)
%finalRect=rbbox;

%----------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIG_2_AX_COORD
%
function P = fig_2_ax_coord(Pfig,axesH);
axPos = get(axesH,'Position');
xLim = get(axesH,'XLim');
yLim = get(axesH,'YLim');
conv2points = [axPos(3)/diff(xLim) axPos(4)/diff(yLim)];

P = [xLim(1) yLim(1)] + (Pfig - axPos(1:2))./conv2points;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONV_X_TO_FIG_COORD
%
function xFig = conv_x_to_fig_coord(xAx,axesH);
axPos = get(axesH,'Position');
xLim = get(axesH,'XLim');
conv = axPos(3)/diff(xLim);
xFig = (xAx - xLim(1))*conv + axPos(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONV_Y_TO_FIG_COORD
%
function yFig = conv_y_to_fig_coord(yAx,axesH);
axPos = get(axesH,'Position');
yLim = get(axesH,'YLim');
conv = axPos(4)/diff(yLim);
yFig = (yAx - yLim(1))*conv + axPos(2);



function [P1,L1]=getAxisLocation(hObject,Yp1);
global HeightNumber
M=length(HeightNumber);
% [n,ha,MyPicStruct,hXLabel,PicDescription,HeightNumber,M,figLBWH,BkLeft,BkBottom,BkWidth,BkHeight]=getPicProperty(hObject);
NTotal=sum(HeightNumber);
HeightUnit=BkHeight/NTotal;
%find Unit number
N1=ceil((BkBottom+BkHeight-Yp1)/(HeightUnit));
%initialization
P1=0;%Unit number
L1=M;%Location number


%get the Location by the Unit number
Lnum=0;
for j=1:M
    Lnum=Lnum+HeightNumber(j);
    if N1<=Lnum
        L1=j;
        P1=NTotal-Lnum;
        break
    end
end
% --------------------------------------------------------------------
%% most important for the layout
% --------------------------------------------------------------------

%--------------------------------------------------------------------------



%call by myResize


function initFigure(hfig,MyPicStruct,handles)

%% initializing the figure for drawing
%% set the default parameters
if MyPicStruct.isPublish  && MyPicStruct.FigureWidth>0
    set(hfig,'Units','pixels','Position',[10 32 MyPicStruct.FigureWidth MyPicStruct.FigureHeight]);
else
    scrsz = get(0,'ScreenSize');
    scrsz =0.95*scrsz;
    set(hfig,'Units','pixels','Position',[10 45 scrsz(3) scrsz(4)-100]);
end

%% set the default for all,do not want to change anymore when editing
% defaultObjProname='default' ObjectType PropertyName
set(groot,'DefaultTextFontWeight',MyPicStruct.DefaultTextFontWeight,'DefaultTextFontSize',MyPicStruct.DefaultTextFontSize,...
    'DefaultAxesFontWeight',MyPicStruct.DefaultAxesFontWeight,...
    'DefaultLegendFontWeight',MyPicStruct.DefaultTextFontWeight,'DefaultLegendFontSize',MyPicStruct.DefaultTextFontSize,...
    'DefaultAxesFontSize',MyPicStruct.DefaultAxesFontSize,'DefaultAxesLineWidth',MyPicStruct.DefaultAxesLineWidth,'DefaultLegendLineWidth',MyPicStruct.DefaultAxesLineWidth);%,...

% set(hfig,'DefaultTextFontWeight',MyPicStruct.DefaultTextFontWeight,'DefaultTextFontSize',MyPicStruct.DefaultTextFontSize,...
%     'DefaultAxesFontWeight',MyPicStruct.DefaultAxesFontWeight,...
%     'DefaultAxesFontSize',MyPicStruct.DefaultAxesFontSize,'DefaultAxesLineWidth',MyPicStruct.DefaultAxesLineWidth);%,...

%set the callback function
set(hfig,'WindowButtonDownFcn',{@myButtonDown,handles},'WindowButtonMotionFcn',{@myButtonMotion,handles},...
    'WindowButtonUpFcn',{@myButtonUp,handles},'ResizeFcn',{@myResize,handles},...
    'KeyPressFcn',{@myKeyFunction,handles},'DeleteFcn',{@myDeleteFcn,handles},'resize','off');

if MyPicStruct.ShowMenu
    set(hfig,'MenuBar','figure');
else
    set(hfig,'MenuBar','none');
end
%% default over


%% set menu
set(hfig,'UIContextMenu', []);
% figure(hfig)
cfgmenu=[];




hs=findobj(hfig,'Type','uimenu');
if ~isempty(hs)
    delete(hs)
end

%% create two menu in figure
cfgmenu=uimenu(hfig, 'Label', 'songDP');
menuSimulationWave=uimenu(hfig, 'Label', 'SimulationWave');
%% create submenu
cfgitem0 = uimenu(cfgmenu, 'Label', 'Help', 'Callback', {@ShowCommandHelp,handles});
cfgitem1= uimenu(cfgmenu, 'Label', 'ChangePictureConfiguration', 'Callback', {@ChangePictureConfiguration,handles});
cfgitem2 = uimenu(cfgmenu, 'Label', 'Draw Profiles', 'Callback', {@DrawProfile,handles});

if MyPicStruct.CurveNameMode==1;
    cfgitem3 = uimenu(cfgmenu, 'Label', 'ShowNextShot', 'Callback', {@ShowNextShot,handles});
    cfgitem4 = uimenu(cfgmenu, 'Label', 'ShowLastShot', 'Callback', {@ShowLastShot,handles});
end
cfgitem5 = uimenu(cfgmenu, 'Label', 'Sizable', 'Callback', {@mySizable,handles});
cfgitem6 = uimenu(cfgmenu, 'Label', 'AddShadow', 'Callback', {@myAddShadow,handles,1});
cfgitem7 = uimenu(cfgmenu, 'Label', 'ShowMenu', 'Callback', {@myShowMenu,handles});
cfgitem8 = uimenu(cfgmenu, 'Label', 'SetFigureSize', 'Callback', {@SetFigureSize,handles});
cfgitem9 = uimenu(cfgmenu, 'Label', 'ChangeLayer', 'Callback', {@myChangeLayer,handles});
cfgitem10 = uimenu(cfgmenu, 'Label', 'SetFigureProperty', 'Callback', {@SetFigureProperty,handles});
cfgitem11 = uimenu(cfgmenu, 'Label', 'SaveInHDF5', 'Callback', {@SaveInHDF5,handles});
cfgitem12 = uimenu(cfgmenu, 'Label', 'MarkLegend', 'Callback', {@MarkLegend,handles});
cfgitem20 = uimenu(cfgmenu, 'Label', 'loadConfiguration', 'Callback', {@loadConfiguration,handles});




cfgitem13 = uimenu(menuSimulationWave, 'Label', 'EditCurve', 'Callback', {@EditCurve,handles});
cfgitem14 = uimenu(menuSimulationWave, 'Label', 'ModifyTime', 'Callback', {@ModifyTime,handles});
cfgitem15 = uimenu(menuSimulationWave, 'Label', 'SaveInto2MDAS', 'Callback', {@SaveInto2MCCS,handles});
% cfgitem16 = uimenu(menuSimulationWave, 'Label', 'modifyChannelsInSIMFile', 'Callback', {@modifyChannelsInFile,handles});
cfgitem16 = uimenu(menuSimulationWave, 'Label', 'modifyChannelsInSIMFile', 'Callback', {@modifyDataInChannels4File,handles});
cfgitem17 = uimenu(menuSimulationWave, 'Label', 'Copy(*.inf,*.dat,*.xml)', 'Callback', {@CopyVEC,handles});
% uipanel


%% menu over
function associateParameter(hfig)
%% need to associate with figure
global MyCurveList MyPicStruct PicDescription  MyCurves
global  HeightNumber WidthNumber Lines2Axes Axes2Lines Axes2Loc Loc2Axes  LocationLeftRight hLines ha

setappdata(hfig,'MyCurveList',MyCurveList)
setappdata(hfig,'MyPicStruct',MyPicStruct)
setappdata(hfig,'PicDescription',PicDescription)
setappdata(hfig,'MyCurveList',MyCurveList)
setappdata(hfig,'MyCurves',MyCurves)

setappdata(hfig,'HeightNumber',HeightNumber)
setappdata(hfig,'WidthNumber',WidthNumber)
setappdata(hfig,'Lines2Axes',Lines2Axes)
setappdata(hfig,'Axes2Lines',Axes2Lines)
setappdata(hfig,'Axes2Loc',Axes2Loc)
setappdata(hfig,'Loc2Axes',Loc2Axes)
setappdata(hfig,'LocationLeftRight',LocationLeftRight)

setappdata(hfig,'hLines',hLines);
setappdata(hfig,'ha',ha);


