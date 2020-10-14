function    SetLegendYLabel(hfig)
%----------------------------------------------------------
global  MyPicStruct PicDescription Axes2Lines hLines ha
ChannelNames=getappdata(hfig,'ChannelNames');
AxesPower=getappdata(hfig,'AxesPower');
N=length(ha); %Axes number


if MyPicStruct.LegendYLabelMode==2  % text mode for fast draw
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
        %MyLabel='Ip(kA)'  % ip draw for zym
        set(get(ha(i),'YLabel'),'String',MyLabel,'Interpreter',MyPicStruct.Interpreter);
        LinesIndex=Axes2Lines(i);
        index=LinesIndex{:};
        j=PicDescription(index(1)).Right;
        %the following statement take a lot time to execute
        %         [h1,h2,h3,h4]=legend(hLines(index),ChannelNames{i},2-j);
        %       legend(hLines(index),ChannelNames{i},2-j);
        %       [h1,h2,h3,h4]=legend(hLines(index),ChannelNames{i},1);
        if iscell(ChannelNames{i}{1})
            legendChannelNames=ChannelNames{i}{1};
            if length(ChannelNames{i})>1
                for ii=2:length(ChannelNames{i})
                    legendChannelNames(ii)=ChannelNames{i}{ii};
                end
            end
        else
            legendChannelNames=ChannelNames{i};
        end
        if 0 %MyPicStruct.isPublish  % legend
            [h1,h2,h3,h4]=legend(hLines(index),legendChannelNames,2-j);
            set(h2(1:length(index)),{'Color'},({PicDescription(index).Color})',{'FontName'},{'Times New Roman'},{'FontSize'},{MyPicStruct.DefaultTextFontSize},{'Interpreter'},{'tex'});
            legend(ha(i),'boxoff');
        else % text
            indexLines=Axes2Lines{i};
            %             text(0.0,0.0,legendChannelNames,'Units','normalized','Parent',ha(i))
            for iL=1:length(indexLines)
                rightAxes=PicDescription(indexLines(iL)).Right;
                
                x=get(hLines(indexLines(iL)),'XData');
                y=get(hLines(indexLines(iL)),'YData');
                [ymax,I]=max(y);
                %                 text(x(I),ymax,legendChannelNames{iL},'Parent',ha(i),'VerticalAlignment','bottom','Color',PicDescription(indexLines(iL)).Color)
                if rightAxes
                    switch mod(iL-1,4)+1
                        case 3
                            x=0;y=0;vA='bottom';hA='left';
                        case 4
                            x=0;y=1;vA='top';hA='left';
                        case 1
                            x=1;y=0;vA='bottom';hA='right';
                        case 2
                            x=1;y=1;vA='top';hA='right';
                    end
                else
                    switch mod(iL-1,4)+1
                        case 1
                            x=0;y=0;vA='bottom';hA='left';
                        case 2
                            x=0;y=1;vA='top';hA='left';
                        case 3
                            x=1;y=0;vA='bottom';hA='right';
                        case 4
                            x=1;y=1;vA='top';hA='right';
                    end
                end
                
                text(x,y,['  ' legendChannelNames{iL} '   '],'Parent',ha(i),'Units','normalized','HorizontalAlignment',hA,'VerticalAlignment',vA,'Color',PicDescription(indexLines(iL)).Color)
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
elseif MyPicStruct.LegendYLabelMode==0  % 0=YLabel->Unit with legend->Channel name
    for i=1:N
        r=AxesPower(i);
        % power label
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
        
        
        LinesIndex=Axes2Lines(i);
        index=LinesIndex{1};
        MyLabel=[MyLabel PicDescription(index(1)).Unit];
        set(get(ha(i),'YLabel'),'String',MyLabel,'Interpreter',MyPicStruct.Interpreter);
        
        
        index=LinesIndex{:};
        j=PicDescription(index(1)).Right;
        
        
        if j==0
            myLocation='northwest';
        elseif j==1
            myLocation='northeast';
        end
        
        [h1,h2,h3,h4]=legend(hLines(index),PicDescription(index).ChnlName,'Location',myLocation);
        set(h2(1:length(index)),{'Color'},({PicDescription(index).Color})',{'FontName'},{'Times New Roman'},{'FontSize'},{MyPicStruct.DefaultTextFontSize},{'Interpreter'},{MyPicStruct.Interpreter});
        legend(ha(i),'boxoff');
    end
elseif MyPicStruct.LegendYLabelMode==1  % 1=YLabel->Channel Name without legend   %&& (MyPicStruct.LayoutMode==0 || MyPicStruct.LayoutMode==1 || MyPicStruct.LayoutMode==4)
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
            MyLabel=strcat('(10',sr,')');
        end
        ChannelNameMyLabel='';
        if ~isempty(strfind(MyLabel,'(')) && ~isempty(strfind(ChannelNames{i},'('))
            MyLabel=strrep(MyLabel, ')', '');
            ChannelNameMyLabel=strrep(ChannelNames{i}, '(', MyLabel);
        else
            ChannelNameMyLabel=strcat(ChannelNames{i},MyLabel);
        end
        %             set(get(ha(i),'YLabel'),'String',ChannelNameMyLabel,'Interpreter','tex');
        set(get(ha(i),'YLabel'),'String',ChannelNameMyLabel,'Interpreter',MyPicStruct.Interpreter);
        
        
    end
else
    
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
        LinesIndex=Axes2Lines(i);
        
        
        
        index=LinesIndex{:};
        CurrentChannel=PicDescription(index(1)).ChnlName;
        
        
        myPattern='\w*$';
        CurrentChannel=regexp(CurrentChannel, myPattern, 'match','once');
        %          CurrentChannel=regexprep(CurrentChannel,'_','\\_');
        
        
        
        
        
        
        
        myUnit=PicDescription(index(1)).Unit;
        if iscell(myUnit)
            myUnit=myUnit{1};
        end
        myPattern='\w*';
        myUnit=regexp(myUnit, myPattern, 'match','once');
        
        
        
        %         index=LinesIndex{1};
        if isempty(myUnit)
            MyLabel=CurrentChannel;
        else
            MyLabel=[CurrentChannel '(' MyLabel myUnit ')'];
            %                MyLabel=[ '(' MyLabel myUnit ')'];
        end
        
        %             set(get(ha(i),'YLabel'),'String',MyLabel,'Interpreter','tex');
        set(get(ha(i),'YLabel'),'String',MyLabel,'Interpreter',MyPicStruct.Interpreter);
        
        
        
        
        sShot={PicDescription(index).ChnlName};
        myPattern='^\w*';
        for ii=1:length(sShot)
            sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
        end
        
        
        
        %         sShot={PicDescription(index).ChnlName};
        %         myPattern='^\w*';
        %         for ii=1:length(sShot)
        %             sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
        %         end
        %
        %         sShot={PicDescription(index).ChnlName};
        %         myPattern='\w*(?=\w)';
        %         for ii=1:length(sShot)
        %             sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
        %         end
        %
        %         sShot={PicDescription(index).ChnlName};
        %         myPattern='\w*(?=/)';
        %         for ii=1:length(sShot)
        %             sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
        %         end
        %
        index=LinesIndex{:}; %new var
        j=PicDescription(index(1)).Right;
        %         [h1,h2,h3,h4]=legend(hLines(index),sShot,2-j);
        %         [h1,h2,h3,h4]=legend(hLines(index),PicDescription(index).ChnlName,2-j);
        if j==0
            [h1,h2,h3,h4]=legend(hLines(index),sShot,'Location','northwest');
        elseif j==0
            [h1,h2,h3,h4]=legend(hLines(index),sShot,'Location','northeast');
        end
        
        set(h2(1:length(index)),{'Color'},({PicDescription(index).Color})',{'FontName'},{'Times New Roman'},{'FontSize'},{MyPicStruct.DefaultTextFontSize},{'Interpreter'},{'none'});
        legend(ha(i),'boxoff');
    end
    
end


return

if 0
    %--------------------------------------------------------------------------------------------------------------------------------------------------
    %YLabel(same) and Legend(shot)
    if MyPicStruct.LayoutMode<0
        
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
            LinesIndex=Axes2Lines(i);
            
            
            
            index=LinesIndex{:};
            CurrentChannel=PicDescription(index(1)).ChnlName;
            
            
            myPattern='\w*$';
            CurrentChannel=regexp(CurrentChannel, myPattern, 'match','once');
            %          CurrentChannel=regexprep(CurrentChannel,'_','\\_');
            
            
            
            
            
            
            
            myUnit=PicDescription(index(1)).Unit;
            
            myPattern='\w*';
            myUnit=regexp(myUnit, myPattern, 'match','once');
            
            
            
            %         index=LinesIndex{1};
            if isempty(myUnit)
                MyLabel=CurrentChannel;
            else
                MyLabel=[CurrentChannel '(' MyLabel myUnit ')'];
            end
            
            set(get(ha(i),'YLabel'),'String',MyLabel,'Interpreter','tex');
            
            
            
            
            sShot={PicDescription(index).ChnlName};
            myPattern='^\w*';
            for ii=1:length(sShot)
                sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
            end
            
            
            
            %         sShot={PicDescription(index).ChnlName};
            %         myPattern='^\w*';
            %         for ii=1:length(sShot)
            %             sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
            %         end
            %
            %         sShot={PicDescription(index).ChnlName};
            %         myPattern='\w*(?=\w)';
            %         for ii=1:length(sShot)
            %             sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
            %         end
            %
            %         sShot={PicDescription(index).ChnlName};
            %         myPattern='\w*(?=/)';
            %         for ii=1:length(sShot)
            %             sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
            %         end
            %
            index=LinesIndex{:}; %new var
            j=PicDescription(index(1)).Right;
            %         [h1,h2,h3,h4]=legend(hLines(index),PicDescription(index).ChnlName,2-j);
            %         [h1,h2,h3,h4]=legend(hLines(index),sShot,2-j);
            if i==1
                [h1,h2,h3,h4]=legend(hLines(index),sShot,2);
                set(h2(1:length(index)),{'Color'},({PicDescription(index).Color})',{'FontName'},{'Times New Roman'},{'FontSize'},{MyPicStruct.DefaultTextFontSize},{'Interpreter'},{'tex'});
                legend(ha(i),'boxoff');
            end
        end
        
        return
    end
end
%--------------------------------------------------------------------------
%%








%%
%--------------------------------------------------------------------------
%if MyPicStruct.LayoutMode==10
%if MyPicStruct.LayoutMode>=0
if MyPicStruct.LayoutMode<0
    
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
        LinesIndex=Axes2Lines(i);
        
        
        
        index=LinesIndex{:};
        CurrentChannel=PicDescription(index(1)).ChnlName;
        
        
        myPattern='^\w*';
        CurrentChannel=regexp(CurrentChannel, myPattern, 'match','once');
        CurrentChannel=regexprep(CurrentChannel,'_','\\_');
        
        
        
        
        
        
        %         j=strfind(CurrentChannel,'/');
        %         if j
        %             L=size(CurrentChannel,2);
        %
        %             CurrentChannel=CurrentChannel(j+1:L);
        %         else
        %             CurrentChannel=CurrentChannel;
        %         end
        
        
        
        
        
        
        
        myUnit=PicDescription(index(1)).Unit;
        
        myPattern='\w*';
        myUnit=regexp(myUnit, myPattern, 'match','once');
        
        
        
        %         index=LinesIndex{1};
        if isempty(myUnit)
            MyLabel=CurrentChannel;
        else
            MyLabel=[CurrentChannel '(' MyLabel myUnit ')'];
        end
        
        set(get(ha(i),'YLabel'),'String',MyLabel,'Interpreter','tex');
        
        
        
        
        sShot={PicDescription(index).ChnlName};
        myPattern='\w*$';
        for ii=1:length(sShot)
            sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
        end
        
        
        
        %         sShot={PicDescription(index).ChnlName};
        %         myPattern='^\w*';
        %         for ii=1:length(sShot)
        %             sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
        %         end
        %
        %         sShot={PicDescription(index).ChnlName};
        %         myPattern='\w*(?=\w)';
        %         for ii=1:length(sShot)
        %             sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
        %         end
        %
        %         sShot={PicDescription(index).ChnlName};
        %         myPattern='\w*(?=/)';
        %         for ii=1:length(sShot)
        %             sShot(ii)={regexp(sShot{ii}, myPattern, 'match','once')};
        %         end
        %
        index=LinesIndex{:}; %new var
        j=PicDescription(index(1)).Right;
        %         [h1,h2,h3,h4]=legend(hLines(index),PicDescription(index).ChnlName,2-j);
        [h1,h2,h3,h4]=legend(hLines(index),sShot,2-j);
        set(h2(1:length(index)),{'Color'},({PicDescription(index).Color})',{'FontName'},{'Times New Roman'},{'FontSize'},{MyPicStruct.DefaultTextFontSize},{'Interpreter'},{'tex'});
        legend(ha(i),'boxoff');
    end
    
    return
end
%--------------------------------------------------------------------------



