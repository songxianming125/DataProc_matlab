function testSimulation()
%% test the simulation result
%% HL2A Coils
% OH   1
% VF   2
% RF   3
% MP1U  4
% MP2U  5
% MP3U  6
% MCU  7
% MP1L  8
% MP2L  9
% MP3L  10
% MCL  11
global betap alphaIndex shapeType limiterRadius
global Iex FilledType isOffsetPF7 isRZIp
isOffsetPF7=1;
clc;
delay=0.1;
isMovie=0;
isRZIp=0;
limiterRadius=0.4;


gFit=getappdata(0,'gFit');
if isempty(gFit)
    gFit=globalFit;
    setappdata(0,'gFit',gFit)
end


%% Init2M
shapeType=gFit.shapeType;

myVideofile=['c:\hl2a\data\' shapeType '3MA.avi'];
% myVideofile=['c:\2w\data\' shapeType '3MA.mp4'];
if exist(myVideofile,'file')
    delete(myVideofile);
end

if isMovie
%     writerObj = VideoWriter(myVideofile,'MPEG-4');
    writerObj = VideoWriter(myVideofile);
    writerObj.FrameRate = 5;  %¿ØÖÆÖ¡Êý
    open(writerObj);
end




[Ip,ap,Xp,Yp,chi,tri,betap,li,alphaIndex]=getPlasma0D(shapeType);

%% preparing Ip and Iex
% [Iex,Ip]=getPFcurrent(shapeType);

if 0
    CurrentShot=26924;
    t0=680;
    t1=681;
    [iPF,tm]=hl2adb(CurrentShot,{'FbBoh' 'FbBv' 'FbIrf' 'FbMp1' 'FbMp2'},t0,t1,1,'FBC');
    index=[1 4];
    iPF(:,index)=-iPF(:,index); %the sign of current Ioh and Imp1 is reversed
    iPF(2:end,:)=[];
    
    
    Iex=[iPF(1,1:3)  0 0 0 0 iPF(1,4:5) iPF(1,4:5)]*1e3;
    
    [Ip,tIp]=hl2adb(CurrentShot,{'FEx_Ip'},t0,t1,1,'fbc');
    Ip(2:end,:)=[];
    Ip=Ip*1e3;
else
    Iex=[ -0.1949    1.5530    0.1996         0         0         0         0    1.5579    1.7757    1.5579    1.7757]*1e4; % A
    Ip= 1.6020e+05; %A
    betap=1.6;
end
% %% get from scenario data
% di=500;
% t1=3001;
% load(['d:\data\equ\' shapeType '3MA'],'t','iPF','Ip')
% 
% t=t1;
% 
% Ip=Ip(t);
% Iex=iPF(t,:);

%% first plasma
% Ip=0.2e6;
% Iex=[-60 -60 0 0 0 0 0 0 0 0 0 0 -25.5 -25.5 0 0 -2.78 -2.78]*1.0e3;



% betap=0.22;


%% Limiter 3MA

% Iex=[-85 -85 0.155 0.155 3.095 3.095 9.855 9.855 10.34 10.34 11.65 11.65 6.56 6.56 -34.095 -34.095 -16.15 -16.15]*1e3; % t=3.0s limiter
%  Ip=3e6;
% betap=0.6;

%  Ip=3e6;
% betap=0.6;

%%


FilledType=sign(Iex);
close all


%% RSV2M(1,0)

yy=DrawBackground(0.4);

hPlasma=gca;
hfig=gcf;

% scrsz = get(0,'ScreenSize');
% set(hfig,'Position',[scrsz(1)*.9   scrsz(2)*.9+30 scrsz(3)*.5 scrsz(4)*.85])

set(gcf,'Renderer','zbuffer');


set(hfig,'KeyPressFcn',{@myKeyFunction,shapeType},'resize','off');

% set(gca,'position',[.05  .05  .5  .90])
axisNum=8;
Names={'p','0','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L'};

[BkLeft,BkBottom,BkWidth,BkHeight]=setAxesPosition(hfig);
HeightUnit=BkHeight/axisNum/2;
x=1:100;
y=zeros(1,100);
% 
% for k=1:8
%     ha(k)=axes('Parent',hfig,'Units','points','Box','on','XTickLabel',[]);
%     
%     set(ha(k),'Position',[BkLeft BkBottom+BkHeight-260-HeightUnit*k BkWidth HeightUnit]);%set the size
%     
%     hLines(k)=line('Parent',ha(k),'Color','r','Marker','none','LineWidth',2,...
%         'DisplayName',Names{1+2*k});
%     set(hLines(k),'XData',x,'YData',y);  %x and y are always cell
% end
%     set(ha(8),'XTickLabelMode','auto');
% 

        
axes(hPlasma)
isDraw=1;


% Iex=Iex
% cla


%% preparing Fit struct

CurrentTime=1;

        Fit(CurrentTime).vStep=gFit.vStep*10; % initial flux step for geting plasma boundary in V.S
        Fit(CurrentTime).okStep=gFit.okStep*10;  % minimum flux step for geting plasma boundary V.S
%         Iex(3)=Iex(3)+1000;  %A
        fluxByPF=gFit.fluxPF*Iex'; % should transpose
        
        Fit(CurrentTime).fluxByPF=fluxByPF; % flux contributed by PF
        Fit(CurrentTime).Iex=Iex; % PF current
        
        Fit(CurrentTime).Ip=Ip; % plasma current
        if Iex(8)>1e3
            Fit(CurrentTime).Xp=gFit.Xp; % plasma geo center radial position
            Fit(CurrentTime).Yp=-0.05; % plasma geo center vertical position
        else
            Fit(CurrentTime).Xp=gFit.Xp; % plasma geo center radial position
            Fit(CurrentTime).Yp=gFit.Yp; % plasma geo center vertical position
        end
        Fit(CurrentTime).betap=betap; % plasma betap
        Fit(CurrentTime).betap=1.6; % plasma betap


%% preparing Fit struct over





j=[];
[j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
[j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
[j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% Fit(CurrentTime).betap=1.2; % plasma betap
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% Fit(CurrentTime).betap=0.6; % plasma betap
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% Fit(CurrentTime).betap=1.2; % plasma betap
% 
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% Fit(CurrentTime).betap=0.6; % plasma betap
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
% 

h=line(C(1,2:end),C(2,2:end),'Color','r');
h1=line(C(1,2:end),C(2,2:end),'Color','m');% target
h2=line(C(1,2:end),C(2,2:end),'Color','k');
h3=line(C1(1,2:end),C1(2,2:end),'Color','k'); % second curve
h4=line(C1(1,2:end),C1(2,2:end),'Color','m'); % target

% return

if isMovie
    frame = getframe(gcf);
    writeVideo(writerObj,frame);
end



htext=title('iterative process','color','k','edge','b','BackgroundColor',[.7 .6 .9],'FontSize',16);

for ii=1:1
    set(htext,'BackgroundColor',[ii/10 1-ii/10 1])
    set(h,'XData',C(1,2:end),'YData',C(2,2:end))
    [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
    if isempty(C)
        ii=0;
    end
    set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
    set(h3,'XData',C1(1,2:end),'YData',C1(2,2:end))
%     if isMovie
%         frame = getframe(gcf);
%         writeVideo(writerObj,frame);
%     end
    pause(delay)
end

[Point,IX,IY]=getControlPoint(C,0);
% [Point,IX,IY]=setControlPoint(Point,2);
set(h1,'XData',Point(1,1:end),'YData',Point(2,1:end))

%offset the current of VS PS
% if isOffsetPF7
%     Iex(15)=(Iex(15)+Iex(16))/2;
%     Iex(16)=Iex(15);
% end

% [Point,IX,IY]=setControlPoint(Point,1); % 8 points
 [Point,IX,IY]=setControlPoint(Point,10); % Big Bang
 %[Point,IX,IY]=setControlPoint(Point,0); % all point
%  load('Point','Point','IX','IY')

set(h1,'XData',Point(1,1:end),'YData',Point(2,1:end))



% Point=getControlPoint(C,1);
set(htext,'string','set target','color','k','edge','b','BackgroundColor',[.7 .9 .9])
    if isMovie
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    if isMovie
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    if isMovie
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
% pause(2)

set(htext,'string','iterative process','color','k','edge','r')

% 
nLoop=1;
for ii=1:nLoop
    set(htext,'BackgroundColor',[ii/nLoop 1 1-ii/nLoop])
    set(h,'XData',C(1,2:end),'YData',C(2,2:end))
    [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
    set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
    set(h3,'XData',C1(1,2:end),'YData',C1(2,2:end))
    
    %     if isMovie
%         frame = getframe(gcf);
%         writeVideo(writerObj,frame);
%     end
    pause(delay)
end

set(htext,'string','feedback control','color','k','edge','r')
pause(2*delay)
    set(htext,'BackgroundColor',[ii/20 1 1-ii/20])
    init=1;
    
    if isRZIp
        [iPF,dU,Iex,dFlux]=feedbackRZIp(Iex,j,Point,IX,IY,init); %  1 is init label
    else
        [iPF,dU,Iex,dFlux]=feedbackControl(Ip,Iex,j,Point,IX,IY,init); %  1 is init label
    end
    %% update Iex
        fluxByPF=gFit.fluxPF*Iex'; % should transpose
        Fit(CurrentTime).fluxByPF=fluxByPF; % flux contributed by PF
        Fit(CurrentTime).Iex=Iex; % PF current
    %%
    set(h,'XData',C(1,2:end),'YData',C(2,2:end))
    [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
    if isempty(C)
        msgbox('no closed contour');
        return
    end
    set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
    set(h3,'XData',C1(1,2:end),'YData',C1(2,2:end))
    pause(delay)
    
    
 XLimOld=get(hPlasma,'XLim');
 YLimOld=get(hPlasma,'YLim');
 XLimNew=[1.18 2.08];
 YLimNew=[-0.9 0.5];
%  XLimNew=[1.4 1.7];
%  YLimNew=[-0.7 -0.3];
 
 nFrame=1;   
for ii=1:nFrame    
    set(hPlasma,'XLim',XLimOld+(XLimNew-XLimOld)*ii/nFrame,'YLim',YLimOld+(YLimNew-YLimOld)*ii/nFrame)
    if isMovie
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    pause(delay)
end

%% feedback control
nLoop=20;
init=0;
disp(['initial iPF=' num2str(Iex)])

%%  modify the current
if 1
%     indexMP13=[8 10];
     indexMP13=10;
    Iex(indexMP13)=Iex(indexMP13)-2000; % PF current
    indexMP2C=11;
    Iex(indexMP2C)=0; % MC
    Fit(CurrentTime).Iex=Iex; % PF current
end





for ii=1:nLoop
    set(htext,'string',['feedback control/ f=' num2str(ii)])
    if ii==20
        %         idebug=20;
        %         [Point,IX,IY]=getControlPoint(C,0);
        %         save('Point','Point','IX','IY')
        %         set(h1,'XData',Point(1,1:end),'YData',Point(2,1:end))
        %         [iPF,dU,Iex,dFlux]=feedbackControl(Iex,j,Point,IX,IY,init); %  1 is init label
    end
    
    set(htext,'BackgroundColor',[1-ii/nLoop 1 1-ii/nLoop])
    if isRZIp
        [iPF,dU,Iex,dFlux]=feedbackRZIp(Iex,j,Point,IX,IY,init); %  1 is init label
    else
        [iPF,dU,Iex,dFlux]=feedbackControl(Ip,Iex,j,Point,IX,IY,init); %  1 is init label
    end
    
    %% update Iex
        fluxByPF=gFit.fluxPF*Iex'; % should transpose
        Fit(CurrentTime).fluxByPF=fluxByPF; % flux contributed by PF
        Fit(CurrentTime).Iex=Iex; % PF current
        disp(Iex)
    %%
    set(h,'XData',C(1,2:end),'YData',C(2,2:end))
    
    [j,M,C,C1,v,index,phiCenter]=getPlasmaCurrent(j,gFit,Fit(CurrentTime));
    if isempty(C)
        disp(Iex)
        msgbox(['no closed contour/ ' num2str(ii)]);
        return
    end
    
    
    set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
    set(h3,'XData',C1(1,2:end),'YData',C1(2,2:end))
    %    pause(1)
    if isMovie
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    %     disp(IY)
    %     disp(Point(1,:))
    pause(delay)
    if dFlux<0.00002
        break
    end

    %     pause(3)
    %%
    %
    %
%     if dFlux<0.01
%         set(h,'XData',C(1,2:end),'YData',C(2,2:end))
%         [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
%          set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
%         pause(delay)
%         set(h,'XData',C(1,2:end),'YData',C(2,2:end))
%         [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
%          set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
%         pause(delay)
%     end
%     if dFlux<0.005
%         break
%         set(h,'XData',C(1,2:end),'YData',C(2,2:end))
%         [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
%          set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
%         pause(delay)
%         set(h,'XData',C(1,2:end),'YData',C(2,2:end))
%         [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
%          set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
%         pause(delay)
%     end
    %     pause(1)
    %
    %     if isMovie
    %         frame = getframe(gcf);
    %         writeVideo(writerObj,frame);
    %     end

%%
end

% save('c:\hl2a\data\equ\jAndC','j','C','Iex','Ip','betap')
% save('c:\hl2a\data\equ\jAndC20985','j','C','Iex','Ip','betap')

 return
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 


% first RZIP then iso-flux
isRZIp=0;
isOffsetPF7=1;


set(htext,'string','feedback control','color','k','edge','r')
pause(2*delay)
    init=1;
    
    if isRZIp
        [iPF,dU,Iex,dFlux]=feedbackRZIp(Iex,j,Point,IX,IY,init); %  1 is init label
    else
        [iPF,dU,Iex,dFlux]=feedbackControl(Iex,j,Point,IX,IY,init); %  1 is init label
    end
    fluxByPF=fluxPF*Iex'; % should transpose
    set(h,'XData',C(1,2:end),'YData',C(2,2:end))
    [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
    if isempty(C)
        msgbox('no closed contour');
        return
    end
     set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
    pause(delay)
    
    
 XLimOld=get(hPlasma,'XLim');
 YLimOld=get(hPlasma,'YLim');
 XLimNew=[0.8 2.9];
 YLimNew=[-1.6 1.6];
 
 nFrame=1;   
for ii=1:nFrame    
    set(hPlasma,'XLim',XLimOld+(XLimNew-XLimOld)*ii/nFrame,'YLim',YLimOld+(YLimNew-YLimOld)*ii/nFrame)
    if isMovie
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    pause(delay)
end

%% feedback control
nLoop=37;
init=0;

for ii=1:nLoop
    set(htext,'string',['feedback control/ f=' num2str(ii)])
    if ii==20
        %         idebug=20;
        %         [Point,IX,IY]=getControlPoint(C,0);
        %         save('Point','Point','IX','IY')
        %         set(h1,'XData',Point(1,1:end),'YData',Point(2,1:end))
        %         [iPF,dU,Iex,dFlux]=feedbackControl(Iex,j,Point,IX,IY,init); %  1 is init label
    end
    
    set(htext,'BackgroundColor',[1-ii/nLoop 1 1-ii/nLoop])
    if isRZIp
        [iPF,dU,Iex,dFlux]=feedbackRZIp(Iex,j,Point,IX,IY,init); %  1 is init label
    else
        [iPF,dU,Iex,dFlux]=feedbackControl(Iex,j,Point,IX,IY,init); %  1 is init label
    end
    fluxByPF=fluxPF*Iex'; % should transpose
    set(h,'XData',C(1,2:end),'YData',C(2,2:end))
    [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
    if isempty(C)
        disp(Iex)
        msgbox(['no closed contour/' num2str(ii)]);
        return
    end
    
    
    
    set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
    %    pause(1)
    if isMovie
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    %     disp(IY)
    %     disp(Point(1,:))
    pause(delay)
    if dFlux<0.002
        break
    end

    %     pause(3)
    %%
    %
    %
%     if dFlux<0.01
%         set(h,'XData',C(1,2:end),'YData',C(2,2:end))
%         [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
%          set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
%         pause(delay)
%         set(h,'XData',C(1,2:end),'YData',C(2,2:end))
%         [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
%          set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
%         pause(delay)
%     end
%     if dFlux<0.005
%         break
%         set(h,'XData',C(1,2:end),'YData',C(2,2:end))
%         [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
%          set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
%         pause(delay)
%         set(h,'XData',C(1,2:end),'YData',C(2,2:end))
%         [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
%          set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
%         pause(delay)
%     end
    %     pause(1)
    %
    %     if isMovie
    %         frame = getframe(gcf);
    %         writeVideo(writerObj,frame);
    %     end

%%
end







save('jAndC','j','C','Iex','Ip','betap')
% Yp=-0.025;
Yp=0;

% j=getPlasmaCurrent(fluxPlasma,fluxByPF);
set(htext,'string','iterative process','color','b','edge','r')
pause(2*delay)
disp(Iex)
nLoop=10;

for ii=1:nLoop
    set(htext,'string',['iterative process/ f=' num2str(ii)])
    set(htext,'BackgroundColor',[ii/40 1-ii/40 0])
    set(h,'XData',C(1,2:end),'YData',C(2,2:end))
    [j,C]=getPlasmaCurrent(fluxPlasma,fluxByPF,j,isDraw);
    set(h2,'XData',C(1,2:end),'YData',C(2,2:end))
    if isMovie
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    pause(delay)
end
% 
% X=Point(1,:);
% Y=Point(2,:);
% plot(X,Y,'r')
% frame = getframe(gcf);
% writeVideo(writerObj,frame);
if isMovie
    close(writerObj);
end
return




% Iex=movePlasma(Iex,di)
% fluxPF=PFCoef*Iex'; % should transpose
% j=getPlasmaCurrent(fluxPlasma,fluxPF);
% [j,C,ind,M,Mmax]=getPlasmaCurrent(fluxPlasma,fluxPF,j);
% [X1,Y1]=getGrid;
% [C,h] = contour(X1,Y1,M,10);%,10);-1e-5 -9e-6 -8e-6-7e-6 -6.8e-6 -6.5e-6   
% 



function [BkLeft,BkBottom,BkWidth,BkHeight]=setAxesPosition(hfig);
% This program is developed by Dr.Song Xianming
% set the Axes property
% LBWH
%Southwestern Institute of Physics, China
%%
set(hfig,'Units','pixels')
BkLeft=400;
BkBottom=32;
BkWidth=380;
BkHeight=600;


function myKeyFunction(hObject, eventdata, shapeType)
global Iex
c=get(hObject,'CurrentCharacter');
k=get(hObject,'currentkey');
if strmatch(k,'f6','exact')
    disp(Iex)
    pause
end








%% test over
