function ResizeDataProc2(handles)
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




%--------------------------------------------------------------------------


b=scrsz(4)-4*hstep;

%?????????????????????
myheight=20;
mybottom=0;


set(handles.lbConfiguration,'Units','pixels','Position',[3*wstep,mybottom*h,0.99*w,myheight*h])
set(handles.lbCurves,'Units','pixels','Position',[4*wstep,mybottom*h,0.99*w,myheight*h])
set(handles.lbChannels,'Units','pixels','Position',[5*wstep,mybottom*h,0.99*w,myheight*h])



% 
set(handles.lbWarning,'Units','pixels','Position',[0,10*h,2.985*wstep,7*h])
set(handles.aBrowser,'Units','pixels','Position',[0.2*wstep,0.8*h,2.7*wstep,9*h])

return
