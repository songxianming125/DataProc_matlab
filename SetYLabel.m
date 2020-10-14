function    SetLegendYLabel(hfig);
%----------------------------------------------------------
AxesPower=getappdata(hfig,'AxesPower');
ha=getappdata(hfig,'hAxis');
N=length(ha); %Axes number




for i=1:N
    r=AxesPower(i);
    if r==0
        MyLabel=' ';
    else
        s1=num2str(r);
        L1=size(s1,2);
        sr='';
        for j=1:L1
            sr=strcat(sr,'^',s1(j));
        end
        %MyUnit=strcat(CurveUnit{i},'(\times10',sr,')');
        %MyUnit=strcat(strtok(CurveUnit,char(0)),'(10',sr,')');
        %MyUnit=strcat(strtok(CurveUnit,char(0)),char(13),char(10),'(10',sr,')');
        MyLabel=strcat('(10',sr,')');
    end
    set(get(ha(i),'YLabel'),'String',MyLabel,'Interpreter','tex');
    %set(ha(i),'YLabel',MyLabel);
end



return


  
    xlim([MyPicStruct.xleft MyPicStruct.xright]);
    MLim=get(gca,'YLim');

%----------------------------------------------------------
 if MyPicStruct.YLabelMode==0
    if existAxes
        hText=findobj(get(gca,'children'),'Type','text');
        set(hText,'String',MyUnit);
    else
        hText=text(MyPicStruct.labelX,MLim(2),MyUnit);
    end
    
    
    %Adjust the position
    PosText=get(hText,'position');
    ExtentText=get(hText,'extent');
    CurrentXLim=get(gca,'XLim');
    PosText(2)=MLim(2);
    

    if R
        PosText(1)=1.01*CurrentXLim(2);
        set(hText,'Position',PosText,'Color',MyCurves.Color);
    else
        PosText(1)=CurrentXLim(1)-ExtentText(3);
        set(hText,'Position',PosText,'Color',MyCurves.Color);

    end
    
    
elseif MyPicStruct.YLabelMode==1
    if MyPicStruct.Debug1==1
        if ilegend
            MyUnit='';
        else
            MyUnit='';
        end
    end

    ylabel(MyUnit);
end