function ResizeDataProc(handles)
%simplify the interface
%initializing the figure and its uicontrol
scrsz = get(0,'ScreenSize');
scrsz=[2 40 scrsz(3)-scrsz(1) scrsz(4)-scrsz(2)];
scrsz=scrsz*0.85;
set(handles.DP,'Units','pixels','Position',scrsz);
Rows=20;
Cols=6;
wstep=scrsz(3)/Cols;
hstep=scrsz(4)/Rows;
w=0.99*wstep;
h=0.94*hstep;

% setappdata(handles.shotPanel,'myWidth',w) %for size control
% setappdata(handles.shotPanel,'myHeight',h) %for size control
%--------------------------------------------------------------------------
b=3*hstep;
set(handles.NumDown,'Units','pixels','Position',[0,b,w/4,h])
set(handles.ShotNumber,'Units','pixels','Position',[w/4,b,w/2,h])
set(handles.NumUp,'Units','pixels','Position',[3*w/4,b,w/4,h])

set(handles.xLeft,'Units','pixels','Position',[0,b,w/2,h])
set(handles.xRight,'Units','pixels','Position',[w/2,b,w/2,h])

set(handles.ClearAll,'Units','pixels','Position',[0,b,w/2,h])
set(handles.ClearOne,'Units','pixels','Position',[w/2,b,w/2,h])

set(handles.R3,'Units','pixels','Position',[0,b,w/2,h])
set(handles.R4,'Units','pixels','Position',[w/2,b,w/2,h])



%--------------------------------------------------------------------------
b=2*hstep;
set(handles.CurrentShot,'Units','pixels','Position',[0,b,w/2,h])
set(handles.ShotOK,'Units','pixels','Position',[w/2,b,w/2,h])

set(handles.AddCurve,'Units','pixels','Position',[0,b,w/2,h])
set(handles.InterpPeriod,'Units','pixels','Position',[w/2,b,w/2,h])

set(handles.MoveUp,'Units','pixels','Position',[0,b,w/2,h])
set(handles.MoveDown,'Units','pixels','Position',[w/2,b,w/2,h])

set(handles.Debug1,'Units','pixels','Position',[0,b,w/2,h])
set(handles.Debug2,'Units','pixels','Position',[w/2,b,w/2,h])

%--------------------------------------------------------------------------
b=1*hstep;
set(handles.LayoutMode,'Units','pixels','Position',[0,b-0.0*h,w/2,h])
set(handles.UpdateShot,'Units','pixels','Position',[w/2,b,w/2,h])

set(handles.LoadCurve,'Units','pixels','Position',[0,b,w/2,h])
set(handles.DataMode,'Units','pixels','Position',[w/2,b-0.05*h,w/2,h],'Enable','on')

set(handles.AccessSpeed,'Units','pixels','Position',[0,b,w/2,h],'Enable','off')
set(handles.SortMode,'Units','pixels','Position',[w/2,b,w/2,h])

set(handles.GetParameter,'Units','pixels','Position',[0,b,w/2,h])
set(handles.Modify,'Units','pixels','Position',[w/2,b,w/2,h])
%--------------------------------------------------------------------------
b=0*hstep;
set(handles.ShotTogether,'Units','pixels','Position',[0,b,w/2,h])
set(handles.DrawCurves,'Units','pixels','Position',[w/2,b,w/2,h])

set(handles.CConfiguration,'Units','pixels','Position',[0,b,w/2,h])
set(handles.CChannels,'Units','pixels','Position',[w/2,b,w/2,h])

set(handles.EqualFormula,'Units','pixels','Position',[0,b,w/2,h],'Enable','off')
set(handles.DefineFormula,'Units','pixels','Position',[w/2,b,w/2,h],'Enable','off')

set(handles.YMode,'Units','pixels','Position',[0,b,w/2,h],'Enable','off')
set(handles.InitPic,'Units','pixels','Position',[w/2,b,w/2,h],'Enable','off')







%--------------------------------------------------------------------------
b=scrsz(4)-1*hstep;

set(handles.Configuration,'Units','pixels','Position',[3*wstep,b,w,h])
set(handles.Curves,'Units','pixels','Position',[4*wstep,b,w,h])
set(handles.tChannels,'Units','pixels','Position',[5*wstep,b,w,h])






b=scrsz(4)-4*hstep;
set(handles.shotPanel,'Units','pixels','Position',[0,b,w,h*5])
set(handles.inputPanel,'Units','pixels','Position',[1*wstep,b,w,h*5])
set(handles.channelPanel,'Units','pixels','Position',[1.99*wstep,b,w,h*5])
set(handles.otherPanel,'Units','pixels','Position',[1.99*wstep,b,w,h*5])

%?????????????????????
set(handles.lbConfiguration,'Units','pixels','Position',[3*wstep,9*h,0.99*w,11.2*h])
set(handles.lbCurves,'Units','pixels','Position',[4*wstep,9*h,0.99*w,11.2*h])
set(handles.lbChannels,'Units','pixels','Position',[5*wstep,9*h,0.99*w,11.2*h])



% 
set(handles.lbWarning,'Units','pixels','Position',[0,9*h,2.985*wstep,8.0*h])
set(handles.aBrowser,'Units','pixels','Position',[0.2*wstep,0.8*h,5.77*wstep,8.15*h])

%FontWeight setting 
names=fieldnames(handles);
for i=2:length(names)
    h=getfield(handles,names{i});
    if strmatch(get(h,'type'),'uicontrol')
%         set(h,'FontWeight','bold','fontsize',14)
        set(h,'fontsize',12)
    end
end


return
