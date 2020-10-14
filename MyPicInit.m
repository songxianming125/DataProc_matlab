function y=MyPicInit
%the data here will control the drawing behavor
%prepare for the figure
DataFlag=1;%1=HL2A,2=Tore Supra
Oscillograph=0;
scrsz = get(0,'ScreenSize');

%for debug
PicStruct.Debug1=0;
PicStruct.Debug2=0;
PicStruct.Debug3=0;
PicStruct.Debug4=0; %control the YTick mode 0=song mode ,1=conventional mode
PicStruct.Debug5=0;%for browser information



PicStruct.version='20200304';%version check
PicStruct.isPublish=0;  %0=no publish 1=publish
PicStruct.myleft=0.1;
PicStruct.mybottom=0.1;%ceil(0.08*scrsz(4));
PicStruct.mywidth=0.85;
PicStruct.myheight=0.75;
PicStruct.timeUnit='s';  %s or ms


switch DataFlag
    case 1
        PicStruct.xleft=-2;
        PicStruct.xright=7;
%         PicStruct.xleft=0;
%         PicStruct.xright=2000;
        PicStruct.xStep=0.001;
        PicStruct.BackgroundLeft=100;%control the emphasis area by background
        PicStruct.Backgroundwidth=0; %control the emphasis area by background
    case 2
        PicStruct.xleft=-5;
        PicStruct.xright=40;
        PicStruct.xStep=5;
        PicStruct.BackgroundLeft=-500;%control the emphasis area by background
        PicStruct.Backgroundwidth=0; %control the emphasis area by background
end
PicStruct.Backgroundheight=5;%pixels number
PicStruct.BackgroundLayer='back';%'back';%'front'
PicStruct.Oscillograph=Oscillograph;
PicStruct.xTickleft=PicStruct.xleft;
PicStruct.xTickright=PicStruct.xright;
PicStruct.labelX=-0;
PicStruct.AxesNum=1;
PicStruct.DeletePic=1;

PicStruct.Marker='.';%'none';
PicStruct.LineStyle='-';
PicStruct.XOffset=0;
PicStruct.YOffset=0;
PicStruct.Factor=1;

PicStruct.Color='b';
PicStruct.BackgroundColor='k'; %control the emphasis area by background
PicStruct.PicBackgroundColor='w'; %control pic background
PicStruct.XColor='k'; %control the color of x axis
PicStruct.YColor='c'; %control the color of y axis
PicStruct.LeftColor='k'; %control the color of left y axis
PicStruct.RightColor='r'; %control the color of right y axis



%picture property
PicStruct.YLabelMode=0; %YLabelMode 0=no, 1=yes, 2=textmode
PicStruct.LayoutMode=0;%=1,2,3,4,5 for details see initDrawingParameter
PicStruct.XLimitMode=0; %0=fixed limit or 1=natural limit
PicStruct.LeftDigit=0;%control the integer part of the YTickLabel
PicStruct.GridMode='on';
PicStruct.PrintBrowseMode=0; %0=print mode;1=browse mode
PicStruct.YLimitAuto=1;  %0=manual, 1=auto full 
PicStruct.YAutoInteger=1; %0=not integer;1=autointeger
PicStruct.YTickNum=5;
PicStruct.LegendYLabelMode=2;%0=YLabel->Unit with legend->Channel name,1=YLabel->Channel Name without legend, 2=text mode for fast draw
PicStruct.FloatingMode=1; %0=floating mode with science format 1=fixed-point, try to use integer 
PicStruct.GapMode=0; %0=no gap between axes with songxm style YTick, 1=with gap together with conventional YTick



%default style
if PicStruct.isPublish==0
    PicStruct.DefaultTextFontWeight='normal';
    PicStruct.DefaultTextFontSize=12;
    PicStruct.DefaultAxesFontWeight='normal';
    PicStruct.DefaultAxesFontSize=12;
    PicStruct.DefaultAxesLineWidth=1;
    PicStruct.FigureWidth=0;
    PicStruct.FigureHeight=0;
    PicStruct.RightDigit=2;%control the fractional part of the YTickLabel
elseif PicStruct.isPublish==1
    PicStruct.DefaultTextFontWeight='normal';
    PicStruct.DefaultTextFontSize=12;
    PicStruct.DefaultAxesFontWeight='normal';
    PicStruct.DefaultAxesFontSize=12;
    PicStruct.DefaultAxesLineWidth=1;
    PicStruct.FigureWidth=450;
    PicStruct.FigureHeight=750;
    PicStruct.RightDigit=2;%control the fractional part of the YTickLabel
%     PicStruct.DefaultTextFontWeight='bold';
%     PicStruct.DefaultTextFontSize=16;
%     PicStruct.DefaultAxesFontWeight='bold';
%     PicStruct.DefaultAxesFontSize=16;
%     PicStruct.DefaultAxesLineWidth=2;
%     PicStruct.FigureWidth=800;
%     PicStruct.FigureHeight=600;
%     PicStruct.RightDigit=1;%control the fractional part of the YTickLabel
end



PicStruct.DefaultTextHorizontalAlignment='right';



PicStruct.MyTransparencyValue=0.5;  %0=transparency 1= no transparency
PicStruct.CurveNameMode=3;%1=Chnl,2=Shot,3=Chnl+Shot
PicStruct.PicTitle=[];  %string for title
PicStruct.LeftShadowColor='b';%Shadow color for left label
PicStruct.RightShadowColor='r';%shadow color for right label
PicStruct.MultiWindows=0;%1=Multiple Windows, 0=single Windows
PicStruct.Modified=1;%1=new or Modified,0=use again, Not Modified
PicStruct.Resizable=0;%1=Resizable,0=Not Resizable
% PicStruct.ReservedFigureNames=[{'DP'} {'songxm'} {'WaveEdit'} {'Formula'}];%1=Resizable,0=Not Resizable
PicStruct.ReservedFigureNames=[{'DP'} {'songxm'} {'WaveEdit'}];%1=Resizable,0=Not Resizable
PicStruct.IsStairs=0; %0=without, 1=with
PicStruct.ShowMenu=0;  %1=yes 0= no

%% 2017/04/06
PicStruct.RowNumber=1; %
PicStruct.ColumnNumber=1; %
PicStruct.GapWidth=100;%control the gap width 
PicStruct.GapHeight=20; %control the gap height

% PicStruct.myleft=0.1;
% PicStruct.mybottom=0.1;%ceil(0.08*scrsz(4));
% PicStruct.mywidth=0.85;
% PicStruct.myheight=0.75;

PicStruct.Interpreter='tex'; % 0='none', 1='tex', 2='latex'
PicStruct.yTickMarginMode=0; % 0=small margin, 1=normal margin, 2=big margin
y=PicStruct;
