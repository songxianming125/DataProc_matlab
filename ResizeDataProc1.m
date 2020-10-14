function ResizeDataProc1(handles)%simplify the interface
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



b=scrsz(4)-4*hstep;

%?????????????????????
myheight=7;
mybottom=13;


set(handles.lbConfiguration,'Units','pixels','Position',[3*wstep,mybottom*h,0.99*w,myheight*h])
set(handles.lbCurves,'Units','pixels','Position',[4*wstep,mybottom*h,0.99*w,myheight*h])
set(handles.lbChannels,'Units','pixels','Position',[5*wstep,mybottom*h,0.99*w,myheight*h])



% 
set(handles.lbWarning,'Units','pixels','Position',[0,(mybottom)*h,2.985*wstep,4*h])
set(handles.aBrowser,'Units','pixels','Position',[0.2*wstep,0.8*h,5.77*wstep,(mybottom-1)*h])


return
