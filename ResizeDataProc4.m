function ResizeDataProc4(handles)
%simplify the interface
%initializing the figure and its uicontrol
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


b=2*3*hstep;
set(handles.NumDown,'Units','pixels','Position',[0,b,3*w/4,2*h])
set(handles.ShotNumber,'Units','pixels','Position',[3*w/4,b,3*w/2,2*h])
set(handles.NumUp,'Units','pixels','Position',[3*3*w/4,b,3*w/4,2*h])




%--------------------------------------------------------------------------
b=2*2*hstep;
set(handles.CurrentShot,'Units','pixels','Position',[0,b,3*w/2,2*h])
set(handles.ShotOK,'Units','pixels','Position',[3*w/2,b,3*w/2,2*h])


%--------------------------------------------------------------------------
b=2*1*hstep;
set(handles.LayoutMode,'Units','pixels','Position',[0,b-0.0*h,3*w/2,2*h])
set(handles.UpdateShot,'Units','pixels','Position',[3*w/2,b,3*w/2,2*h])

%--------------------------------------------------------------------------
b=0*hstep;
set(handles.ShotTogether,'Units','pixels','Position',[0,b,3*w/2,2*h])
set(handles.DrawCurves,'Units','pixels','Position',[3*w/2,b,3*w/2,2*h])

b=scrsz(4)-2*4*hstep;
set(handles.shotPanel,'Units','pixels','Position',[0,b,3*w,h*10])
set(handles.lbWarning,'Units','pixels','Position',[0,9*h,2.985*wstep,4.0*h])


%--------------------------------------------------------------------------


return
