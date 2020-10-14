function ResizeEF(handles)
%simplify the interface
%initializing the figure and its uicontrol
scrsz = get(0,'ScreenSize');
scrsz=[2 40 scrsz(3)-scrsz(1) scrsz(4)-scrsz(2)];
scrsz=scrsz*0.9;
set(handles.EF,'Units','pixels','Position',scrsz);
Rows=20;
Cols=10;
wstep=scrsz(3)/Cols;
hstep=scrsz(4)/Rows;
w=0.99*wstep;
h=0.94*hstep;

axisL=5.2;
axisW=4.6;
axisH=3.5;

b=0.5*hstep;
set(handles.Start,'Units','pixels','Position',[axisL*w,b,w,h])
set(handles.CurrentTime,'Units','pixels','Position',[(axisL+1.8)*w,b,w,h])
set(handles.End,'Units','pixels','Position',[(axisL+3.6)*w,b,w,h])


b=1*hstep;
set(handles.Shape,'Units','pixels','Position',[w/2,b,axisW*w,20*h])



b=1.5*hstep;
set(handles.Time,'Units','pixels','Position',[axisL*w-0.15*w,b,axisW*w+0.25*w,h/2])


b=b+1.5*hstep;
set(handles.Ip,'Units','pixels','Position',[axisL*w,b,axisW*w,axisH*h])
% set(handles.TimeLine,'Units','pixels','Position',[(axisL)*w,b,2,2*axisH*hstep+axisH*h])
% set(handles.TimeLine,'XTick',[],'YTick',[],'XTickLabel',[],'YTickLabel',[]);



x=[(axisL)*w (axisL)*w]/scrsz(3);
y=[b-2 b+2*axisH*hstep+axisH*h-2]/scrsz(4);
set(handles.hTimeLine,'X',x,'Y',y)



b=b+axisH*hstep;
set(handles.ZDv,'Units','pixels','Position',[axisL*w,b,axisW*w,axisH*h])
b=b+axisH*hstep;
set(handles.RDh,'Units','pixels','Position',[axisL*w,b,axisW*w,axisH*h])

set(handles.ZDv,'XTickLabel',[]);
set(handles.RDh,'XTickLabel',[]);

set(get(handles.Ip,'YLabel'),'Color','k','String','Ip(kA)')
set(get(handles.ZDv,'YLabel'),'Color','k','String','Dv(cm)')
set(get(handles.RDh,'YLabel'),'Color','k','String','Dh(cm)')

b=b+axisH*hstep;
set(handles.Info,'Units','pixels','Position',[axisL*w,b,axisW*w+0.15*w,1.5*hstep+3*h])


b=b+3*hstep+1.5*hstep;
set(handles.RunEF,'Units','pixels','Position',[axisL*w,b,w,h])
set(handles.minus,'Units','pixels','Position',[(axisL+1.2)*w,b,w/2,h])
set(handles.plus,'Units','pixels','Position',[(axisL+1.7)*w,b,w/2,h])
set(handles.autoComp,'Units','pixels','Position',[(axisL+2.4)*w,b,w,h])
set(handles.Load,'Units','pixels','Position',[(axisL+3.6)*w,b,w,h])

b=b+1*hstep;
set(handles.CurrentShot,'Units','pixels','Position',[axisL*w,b,w,h])
set(handles.ShotNumber,'Units','pixels','Position',[(axisL+1.2)*w,b,w,h])
set(handles.Step,'Units','pixels','Position',[(axisL+2.4)*w,b,w,h])
set(handles.Limiter,'Units','pixels','Position',[(axisL+3.6)*w,b,w,h])


set(handles.Step,'Enable','off')
set(handles.Limiter,'Enable','off')
% set(handles.RunEF,'Enable','off')
% set(handles.autoComp,'Enable','off')

% %FontWeight setting 
% names=fieldnames(handles);
% for i=2:length(names)
%     h=getfield(handles,names{i});
%     if strmatch(get(h,'type'),'uicontrol')
% %         set(h,'FontWeight','bold','fontsize',14)
%         set(h,'fontsize',12)
%     end
% end
% 

return
