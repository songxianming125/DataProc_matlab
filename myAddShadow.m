function s=myAddShadow(hObject, eventdata,handles,mode)
global hfig MyPicStruct HeightNumber

[BkLeft,BkBottom,BkWidth,BkHeight]=getAxesProperty(hfig);
PicPos=get(hfig,'Position');
ha=getappdata(hfig,'hAxis');
axisPosition=get(ha(1),'position');
BkWidth=axisPosition(3);


if mode==3
    
    set(groot,'defaultLineLineWidth',3)
    
    dlg_title = 'Add a Shadow';
    prompt = {'x1','x2','y1','y2','LineSpec','text','axis 1= top'};
    def     = {num2str(MyPicStruct.xleft),num2str(MyPicStruct.xright),'0','0', '--ro','comment','1'};
    num_lines= 1;
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    
    x1=str2double(answer{1});
    x2=str2double(answer{2});
    y1=str2double(answer{3});
    y2=str2double(answer{4});
    
    
    LineSpec=answer{5};
    mycomment=answer{6};
    axisIndex=str2double(answer{7});
    
    
else
    if mode==2
        dlg_title = 'Add a row Shadow';
        prompt = {'ShadowColor','MyTransparencyValue 1=n 0=y','start=0','end=10','comment','axis 1= top','shadowHeight'};
        def     = {MyPicStruct.LeftShadowColor,num2str(MyPicStruct.MyTransparencyValue),num2str(MyPicStruct.xleft),num2str(MyPicStruct.xright),'comment','1','0.5'};
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        ShadowColor=answer{1};
        ShadowTransparencyValue=str2double(answer{2}); %#ok<*ST2NM>
        
        
        ShadowLeft=str2double(answer{3});
        ShadowLeft1=str2double(answer{4});
        mycomment=answer{5};
        axisIndex=str2double(answer{6});
        shadowHeight=str2double(answer{7});
        
        
    elseif mode==1
        dlg_title = 'Add a column Shadow';
        prompt = {'ShadowColor','MyTransparencyValue 1=n 0=y','start=0','end=10','comment'};
        def     = {MyPicStruct.LeftShadowColor,num2str(MyPicStruct.MyTransparencyValue),num2str(MyPicStruct.xleft),num2str(MyPicStruct.xright),'comment'};
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        ShadowColor=answer{1};
        ShadowTransparencyValue=str2double(answer{2}); %#ok<*ST2NM>
        
        
        ShadowLeft=str2double(answer{3});
        ShadowLeft1=str2double(answer{4});
        mycomment=answer{5};
        
    else mode==0
        dlg_title = 'Add a Shadow';
        prompt = {'ShadowColor','MyTransparencyValue 1=n 0=y','comment'};
        def     = {MyPicStruct.LeftShadowColor,num2str(MyPicStruct.MyTransparencyValue),'comment'};
        num_lines= 1;
        answer  = inputdlg(prompt,dlg_title,num_lines,def);
        ShadowColor=answer{1};
        ShadowTransparencyValue=str2double(answer{2}); %#ok<*ST2NM>
        
        
        [ShadowLeft,~]=ginput(1);
        [ShadowLeft1,~]=ginput(1);
        mycomment=answer{3};
        
    end
    ShadowWidth=abs(ShadowLeft1-ShadowLeft);
    ShadowLeft=min(ShadowLeft,ShadowLeft1);
    
    
    
    
    %[l b w h];
    
    
    xLim=get(ha(1),'XLim');%debug
    myLeft=BkLeft+BkWidth*(ShadowLeft-xLim(1))/(xLim(2)-xLim(1)); %debug
    %myWidth=BkWidth*ShadowWidth/(xLim(2)-xLim(1));
    myWidth=BkWidth*ShadowWidth/(xLim(2)-xLim(1));
    
    
end




if mode==3
    
    axes(ha(axisIndex))
    hold on
    plot([x1 x2],[y1 y2],LineSpec)
    HeightUnit=BkHeight/sum(HeightNumber(:));
    verticalPosition=HeightUnit*(sum(HeightNumber(axisIndex:end))-HeightNumber(axisIndex));
    textPositionY=(BkBottom-2+verticalPosition+0.5*HeightUnit)/PicPos(4);
    
    myArrowText=annotation(hfig,'textarrow',[0.3 0.4],[textPositionY textPositionY],'String',mycomment);
    % set(hshadow,'EdgeColor','none','BackgroundColor',ShadowColor,'FaceAlpha',ShadowTransparencyValue)%,'EraseMode ','xor')%,'FaceAlpha',ShadowTransparencyValue
    s=0;
    
    
else
    if mode==2
        % row shawdow
        axes(ha(axisIndex))
        hold on

        HeightUnit=BkHeight/sum(HeightNumber(:));
        verticalPosition=HeightUnit*(sum(HeightNumber(axisIndex:end))-HeightNumber(axisIndex));
        shawdowPosition=[myLeft/PicPos(3) (BkBottom-2+verticalPosition)/PicPos(4) myWidth/PicPos(3) HeightUnit*shadowHeight/PicPos(4)];
        textPositionY=(BkBottom-2+verticalPosition+0.5*HeightUnit)/PicPos(4);
        
    else
        % column shawdow
        shawdowPosition=[myLeft/PicPos(3) (BkBottom-2)/PicPos(4) myWidth/PicPos(3) BkHeight/PicPos(4)];
        textPositionY=0.4;
    end
    
    
    hshadow=annotation(hfig,'textbox',shawdowPosition);%,'EraseMode ','xor','BackgroundColor','w')
    set(hshadow,'EdgeColor','none','BackgroundColor',ShadowColor,'FaceAlpha',ShadowTransparencyValue)%,'EraseMode ','xor')%,'FaceAlpha',ShadowTransparencyValue
    
    %%  comment
    myArrowText=annotation(hfig,'textarrow',[0.3 0.4],[textPositionY textPositionY],'String',mycomment);
    s=0;end
return









