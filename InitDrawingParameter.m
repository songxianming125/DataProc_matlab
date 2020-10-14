function     n=InitDrawingParameter
%songxm
%version 3.0

%% drawing parameters + position parameters


% position parameters
global  HeightNumber WidthNumber Lines2Axes Axes2Lines Axes2Loc Loc2Axes  LocationLeftRight
% drawing parameters
global  MyPicStruct NumShot   PicDescription MyCurves
%% the layout of curves

if MyPicStruct.LayoutMode==10
    R=0;
    dlg_title = 'Set total Number of Shots';
    prompt = {'Set total Number of Shots'};
    def   = {num2str(NumShot)};
    num_lines= 1;
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    NumShot=str2num(answer{1}); % make sure the shot number is right
else
    NumShot=1;
end



%% fisrt set the drawing parameters
switch MyPicStruct.PrintBrowseMode% the default displaying mode
    case 0
        MyPicStruct.PicBackgroundColor='w';
        %MyPicStruct.LeftColor='b'; %control the color of left y axis
        %MyPicStruct.RightColor='r'; %control the color of right y axis
        %MyPicStruct.XColor='b';
    case 1
        MyPicStruct.PicBackgroundColor='k';
        %MyPicStruct.LeftColor=[0.3,0.7,0.90]; %control the color of left y axis
        %MyPicStruct.RightColor=[0.8,0.8,0.8]; %control the color of right y axis
        %MyPicStruct.XColor=[0.2,0.8,0.2];
end

if  MyPicStruct.XLimitMode==1%0=fixed limit or 1=natural limit
    MyPicStruct.xleft=MyCurves(1).xMin;
    MyPicStruct.xright=MyCurves(1).xMax;
    MyPicStruct.xTickleft=MyPicStruct.xleft;
    MyPicStruct.xTickright=MyPicStruct.xright;
end

[~,n]=size(MyCurves);
% n is the number of curves

%most important code for set the layout of the picture property
L=0;
ColorOrder=SetColorOrder;
[NColor,MColor]=size(ColorOrder);

%%
%special purpose
% if MyPicStruct.Debug1==2
%     MyPicStruct.PicTitle=strcat('Statistic results for ECRH Pre-ionization and Assisted Startup. (Shot:18161-18187)');
% else
% end
%%


if n~=length(PicDescription);%1=Modified,0=Not Modified
    %set the PicTitle first
    MyPicStruct.CurveNameMode=3;
    %MyPicStruct.PicTitle='';
    
    Shots(1:n)={MyCurves(1:n).Shot};
    Shot=MyCurves(1).Shot;
    ChannelIndex = strmatch(Shot,Shots,'exact');
    if length(ChannelIndex)==n
        MyPicStruct.CurveNameMode=1;
        MyPicStruct.PicTitle=strcat('Shot:',Shot);
    else
        ChnlNames(1:n)={MyCurves(1:n).ChnlName};
        ChnlName=MyCurves(1).ChnlName;
        ChannelIndex = strmatch(ChnlName,ChnlNames,'exact');
        if length(ChannelIndex)==n
            MyPicStruct.CurveNameMode=2;
            MyPicStruct.PicTitle=ChnlName;
        else
            MyPicStruct.PicTitle=' ';
        end
    end
    
    
    % many shots comparison
    
    for i=1:n
        [~,nPicDescription]=size(PicDescription);
        %ini by struct
        PicDescription(i).IsStairs=MyPicStruct.IsStairs;
        PicDescription(i).YLimitAuto=MyPicStruct.YLimitAuto;
        PicDescription(i).Color=MyPicStruct.Color;
        PicDescription(i).Marker=MyPicStruct.Marker;
        PicDescription(i).LineStyle=MyPicStruct.LineStyle;
        
        PicDescription(i).RightDigit=MyPicStruct.RightDigit;
        PicDescription(i).XOffset=MyPicStruct.XOffset;
        PicDescription(i).YOffset=MyPicStruct.YOffset;
        PicDescription(i).Factor=MyPicStruct.Factor;
        PicDescription(i).LeftDigit=MyPicStruct.LeftDigit;
        %10 properties
        %%
        %ini by curve
        PicDescription(i).Unit=MyCurves(i).Unit;
        switch MyPicStruct.CurveNameMode;%1=Chnl,2=Shot,3=Chnl+Shot
            case 1
                PicDescription(i).ChnlName=MyCurves(i).ChnlName;
            case 2
                PicDescription(i).ChnlName=MyCurves(i).Shot;
            case 3 %{1,2,3}
                PicDescription(i).ChnlName=MyCurves(i).ChnlName;
                if isempty(strfind(MyCurves(i).ChnlName,'\'))
                    if isempty(strfind(MyCurves(i).ChnlName,'/'))
                        PicDescription(i).ChnlName=strcat(MyCurves(i).Shot,'\\',MyCurves(i).ChnlName);
                    end
                end
        end
        
        
        PicDescription(i).yMin=MyCurves(i).yMin;
        PicDescription(i).yMax=MyCurves(i).yMax;
        %4 properties
        %%
        
        %set layout properties
        % some may modify color or linestyle
        
        
        switch MyPicStruct.LayoutMode
            case 0
                %all in left
                L=L+1;
                R=0;
                PicDescription(i).Color=MyPicStruct.LeftColor;
            case 1
                %one left, one right
                if mod(i,2)==0
                    R=1;
                    PicDescription(i).Color=MyPicStruct.RightColor;
                else
                    R=0;
                    L=L+1;
                    PicDescription(i).Color=MyPicStruct.LeftColor;
                end
            case 2
                if mod(i,2)==0
                    R=1;
                else
                    L=1;
                    R=0;
                end
                NColorResidual=mod(i-1,NColor)+1;
                PicDescription(i).Color=ColorOrder(NColorResidual,:);
            case 3
                L=1;
                R=0;
                %Color y m c r g b w k(total=8)
                MyColor='rkbmcgy';
                PicDescription(i).Color=ColorOrder(mod(i-1,8)+1,:);
                %Marker + o * . x s d ^ v > < p h none (total=14)
                MyMarker='+o*.xsd^v><ph';
                PicDescription(i).Marker='.';%MyMarker(mod(i-1,13)+1);
                %MyPicStruct.Marker='.';
                %LineStyle  - .(-.) ,(--) :
                MyLineStyle=[{'-'},{'-.'},{'--'},{':'}];
                PicDescription(i).LineStyle='-';%MyLineStyle{mod(i-1,4)+1};
            case 4
                if i>n/2
                    R=0;
                    PicDescription(i).Color=MyPicStruct.RightColor;
                    L=mod(i-1,ceil(n/2))+1;
                else
                    R=0;
                    L=mod(i-1,ceil(n/2))+1;
                    PicDescription(i).Color=MyPicStruct.LeftColor;
                end
                
            case 5
                if mod(i,2)==0
                    R=0;
                    PicDescription(i).Color=MyPicStruct.RightColor;
                else
                    R=0;
                    L=L+1;
                    PicDescription(i).Color=MyPicStruct.LeftColor;
                end
                
            case 6
                FirstChannels=MyCurves(1).ChnlName;
                k=strfind(FirstChannels,'%');
                if k
                    FirstChannel=FirstChannels(1:k-1);
                else
                    FirstChannel=FirstChannels;
                end
                
                
                CurrentChannels=MyCurves(i).ChnlName;
                k=strfind(CurrentChannels,'%');
                if k
                    CurrentChannel=CurrentChannels(1:k-1);
                else
                    CurrentChannel=CurrentChannels;
                end
                
                
                
                if strcmp(FirstChannel,CurrentChannel)
                    L=1;
                    R=0;
                else
                    L=2;
                    R=0;
                end
                %Color y m c r g b w k(total=8)
                %MyColor='mcrgbky';
                %PicDescription(i).Color=MyColor(mod(i-1,7)+1);
                %MyColor='mcrgbky';
                PicDescription(i).Color=[floor((i+1)/2)/23 0.5-abs(floor((i-23)/2)/22) 1-floor((i+1)/2)/23];
                
                
                %Marker + o * . x s d ^ v > < p h none (total=14)
                MyMarker='+o*.xsd^v><ph';
                %MyPicStruct.Marker=MyMarker(mod(i-1,13)+1);
                PicDescription(i).Marker='.';
                %LineStyle  - .(-.) ,(--) :
                MyLineStyle=[{'-'},{'-.'},{'--'},{':'}];
                PicDescription(i).LineStyle=MyLineStyle{mod(i-1,4)+1};
            case 7
                if mod(i,2)==1
                    R=0;
                    L=1;
                else
                    R=0;
                    L=2;
                end
                
                MyColor='mcrgbky';
                PicDescription(i).Color=MyColor(mod(i-1,7)+1);
                PicDescription(i).Marker='none';
                PicDescription(i).LineStyle='-';
            case 8
                if i>n/2
                    R=0;
                    PicDescription(i).Color=MyPicStruct.RightColor;
                    L=mod(i-1,ceil(n/2))+1;
                else
                    R=1;
                    L=mod(i-1,ceil(n/2))+1;
                    PicDescription(i).Color=MyPicStruct.LeftColor;
                end
            case 9 % curves for one axes
                num=3;
                R=0;
                L=mod(i-1,ceil(n/num))+1;
                switch floor((i-1)/(n/num))
                    case 0
                        PicDescription(i).Color='r';
                    case 1
                        PicDescription(i).Color='k';
                    case 2
                        PicDescription(i).Color='m';
                    case 3
                        PicDescription(i).Color='b';
                end
            case 10
                
                L=mod(i-1,n/(NumShot))+1;
                %%
                MyColor='rkmcgbyrkmcgby';
                %                 PicDescription(i).Color=MyColor(mod(i-1,7)+1);
                PicDescription(i).Color=MyColor(ceil((NumShot)*i/n));
                
                
                %%
        end%switch
        
        %%
        % layout properties
        %PicDescription(i).Location= max( cell2mat( {PicDescription(:).Location}))+1; %%build up the initial PictureArrangement
        PicDescription(i).Location= L; %%build up the initial PictureArrangement
        PicDescription(i).Right=R;
        %%
    end%for i=1:n
else % n~=length(PicDescription)
    if 0
    if MyPicStruct.Modified==1  % may change the name or something, like modify layout and color
        for i=1:n
            %ini by struct
            switch MyPicStruct.LayoutMode
                case 0
                    %all in left
                    L=L+1;
                    R=0;
                    PicDescription(i).Color=MyPicStruct.LeftColor;
                case 1
                    %one left, one right
                    if mod(i,2)==0
                        R=1;
                        PicDescription(i).Color=MyPicStruct.RightColor;
                    else
                        R=0;
                        L=L+1;
                        PicDescription(i).Color=MyPicStruct.LeftColor;
                    end
                case 2
                    if mod(i,2)==0
                        R=1;
                    else
                        L=1;
                        R=0;
                    end
                    NColorResidual=mod(i-1,NColor)+1;
                    PicDescription(i).Color=ColorOrder(NColorResidual,:);
                case 3
                    L=1;
                    R=0;
                    %Color y m c r g b w k(total=8)
                    MyColor='mcrgbrky';
                    PicDescription(i).Color=MyColor(mod(i-1,8)+1);
                    %Marker + o * . x s d ^ v > < p h none (total=14)
                    MyMarker='+o*.xsd^v><ph';
                    PicDescription(i).Marker='.';%MyMarker(mod(i-1,13)+1);
                    %MyPicStruct.Marker='.';
                    %LineStyle  - .(-.) ,(--) :
                    MyLineStyle=[{'-'},{'-.'},{'--'},{':'}];
                    PicDescription(i).LineStyle='-';%MyLineStyle{mod(i-1,4)+1};
                case 4
                    if i>n/2
                        R=0;
                        PicDescription(i).Color=MyPicStruct.RightColor;
                        L=mod(i-1,ceil(n/2))+1;
                    else
                        R=0;
                        L=mod(i-1,ceil(n/2))+1;
                        PicDescription(i).Color=MyPicStruct.LeftColor;
                    end
                    
                case 5
                    if mod(i,2)==0
                        R=0;
                        PicDescription(i).Color=MyPicStruct.RightColor;
                    else
                        R=0;
                        L=L+1;
                        PicDescription(i).Color=MyPicStruct.LeftColor;
                    end
                    
                case 6
                    FirstChannels=MyCurves(1).ChnlName;
                    k=strfind(FirstChannels,'%');
                    if k
                        FirstChannel=FirstChannels(1:k-1);
                    else
                        FirstChannel=FirstChannels;
                    end
                    
                    
                    CurrentChannels=MyCurves(i).ChnlName;
                    k=strfind(CurrentChannels,'%');
                    if k
                        CurrentChannel=CurrentChannels(1:k-1);
                    else
                        CurrentChannel=CurrentChannels;
                    end
                    
                    
                    
                    if strcmp(FirstChannel,CurrentChannel)
                        L=1;
                        R=0;
                    else
                        L=2;
                        R=0;
                    end
                    %Color y m c r g b w k(total=8)
                    MyColor='rkmcgby';
                    PicDescription(i).Color=MyColor(mod(i-1,7)+1);
                    %Marker + o * . x s d ^ v > < p h none (total=14)
                    MyMarker='+o*.xsd^v><ph';
                    %MyPicStruct.Marker=MyMarker(mod(i-1,13)+1);
                    PicDescription(i).Marker='.';
                    %LineStyle  - .(-.) ,(--) :
                    MyLineStyle=[{'-'},{'-.'},{'--'},{':'}];
                    PicDescription(i).LineStyle=MyLineStyle{mod(i-1,4)+1};
                case 7
                    if mod(i,2)==1
                        R=0;
                        L=1;
                    else
                        R=0;
                        L=2;
                    end
                    
                    MyColor='mcrgbky';
                    PicDescription(i).Color=MyColor(mod(i-1,7)+1);
                    PicDescription(i).Marker='none';
                    PicDescription(i).LineStyle='-';
                case 8
                    if mod(i,2)==1
                        R=0;
                        L=1;
                    else
                        R=0;
                        L=2;
                    end
                case 9 % curves for one axes
                    num=3;
                    R=0;
                    L=mod(i-1,ceil(n/num))+1;
                    switch floor((i-1)/(n/num))
                        case 0
                            PicDescription(i).Color='r';
                        case 1
                            PicDescription(i).Color='k';
                        case 2
                            PicDescription(i).Color='m';
                        case 3
                            PicDescription(i).Color='b';
                    end
                case 10
                    MyColor='rkmcgby';
                    R=0;
                    L=mod(i-1,n/(NumShot))+1;
                    PicDescription(i).Color=MyColor(ceil((NumShot)*i/n));
            end%switch
            %NColorResidual=mod(i-1,NColor)+1;
            %PicDescription(i).Color=ColorOrder(NColorResidual,:);
            PicDescription(i).Location=L; %%build up the initial PictureArrangement
            PicDescription(i).Right=R;
            %Location(i)=PicDescription(i).Location;
        end%for i=
    end %strcmpi
    end
end %for n~=

if MyPicStruct.Debug1==1
    for i=1:n
        %PicDescription(i).Color=[floor((i+1)/2)/23 0.5-abs(floor((i-23)/2)/22) 1-floor((i+1)/2)/23];
        %PicDescription(i).LineStyle='-';
        if i<5
            PicDescription(i).Color='k';
        else
            PicDescription(i).Color='r';
        end
        PicDescription(i).LineStyle='-';
        
    end
end


[L,S,R]=gettheXTick(MyPicStruct.xTickleft, MyPicStruct.xTickright);
if S>0.0001
    MyPicStruct.xTickright=R;
    MyPicStruct.xTickleft=L;
    MyPicStruct.xStep=S;
end


%set the related parameters and functions
Location1={PicDescription.Location};%cell array is ok.
Location=cell2mat(Location1);
LeftRight1={PicDescription.Right};
LeftRight=cell2mat(LeftRight1);

%%  layout grid manipulate
M=max(Location);
MyPicStruct.AxesNum=M;%store the Axes number

%% second set the position parameters

%%  position setting
if 1 %length(Lines2Axes)~=n 
    %%
    %4 functions
    % Loc2Axes
    % Axes2Loc
    % Axes2Lines
    % Lines2Axes
    
    
    %initialization
    Lines2Axes=[];
    Axes2Lines={[]};
    Axes2Loc=[];
    Loc2Axes={[]};
    LocationLeftRight(1:M,1:2)=0;
    CurrentAxes=0;
    for i=1:M %for location
        L2A=[];
        for j=0:1 %for LeftRight
            A=abs(Location-i)+abs(LeftRight-j);
            index=find(A==0);
            if ~isempty(index)
                CurrentAxes=CurrentAxes+1;
                LocationLeftRight(i,1+j)=CurrentAxes;
                Axes2Loc(CurrentAxes)=i;
                L2A=[L2A CurrentAxes];
                Axes2Lines(CurrentAxes)={index};
            end% if
        end
        Loc2Axes(i)={L2A};
    end
    
    
    
    % Axes2Lines
    % Lines2Axes
    for ii=1:n
        i=PicDescription(ii).Location;
        j=PicDescription(ii).Right;
        CurrentAxes=LocationLeftRight(i,1+j);
        Lines2Axes(ii)=CurrentAxes;
    end
end


%% Column setting
% forced to used one column
defaultRowNumber=6;
%totalRowNumber=ceil(length(MyCurves)/NumShot);
if length(Loc2Axes)<=defaultRowNumber % length(Loc2Axes)
    MyPicStruct.RowNumber=length(Loc2Axes);
    MyPicStruct.ColumnNumber=1;
else
    MyPicStruct.RowNumber=defaultRowNumber; % length(Loc2Axes);
%     MyPicStruct.ColumnNumber=ceil(totalRowNumber/defaultRowNumber);
    MyPicStruct.ColumnNumber=ceil(length(Loc2Axes)/defaultRowNumber);
end

HeightNumber=[];%initialization
WidthNumber=[];
RowNumber=MyPicStruct.RowNumber;
ColumnNumber=MyPicStruct.ColumnNumber;

HeightNumber(1:RowNumber)=1;%for change height
WidthNumber(1:ColumnNumber)=1;

setappdata(gcf,'oldHeightNumber',HeightNumber)
setappdata(gcf,'oldWidthNumber',WidthNumber)
MyPicStruct.Modified=0;

% Lines to Location is known and the Location to Lines can be found through
% Loc2Axes plus Axes2Lines
%%
