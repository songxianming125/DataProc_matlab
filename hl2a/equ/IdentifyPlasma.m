function  [M_norm,index,C,varargout]=IdentifyPlasma(gFit,M,MLimiter,varargin)
% 2014/11/22 by Song Xianming

% find the flux value of the plasma boundary
%% input
% gFit = constant
% M = the flux matrix
% MLimiter = the flux at limiter
% initFactor=varargin{1} the factor to accelerate the boundary finding


%% output
% M = the modified flux matrix
% index = the area of plasma current
% v = the flux value of plasma boundary
% C = the boundary
% C1 = the SOL leg
% phiCenter = the flux at current center

%% draw contour for flux
%% argument in
% persistent h hpoint
if nargin>=4
    initFactor=varargin{1}; % typically 10
    vStep=gFit.vStep*initFactor;
    okStep=gFit.okStep*initFactor;
else
    vStep=gFit.vStep;
    okStep=gFit.okStep;
end
isDrawPoint=0;


delay=gFit.delay;
X1=gFit.X1;  % Matrix, X1 in grid
Y1=gFit.Y1;  % Matrix, Y1 in grid
Point=gFit.Point;  % Matrix, point in limiter
isDraw=gFit.isDraw;  % scalar, 0=no draw, 1=draw



% isDrawPoint=0;
isNear=1;  % the contour is near the v


[phiCenter,indexMax]=max(M(:));

[m1,n1]=size(M);

% check if plasma is limited
XX=Point(1,:);
YY=Point(2,:);


%% limiter or divertor

% find the flux at limiter

[v,indexLim]=max(MLimiter);
XLimiter=XX(indexLim(1));
YLimiter=YY(indexLim(1));

% plot(XLimiter,YLimiter,'.b')
if isDraw
    %     [C,h] = contour(X1,Y1,M,v);
end
C = contourc(X1(1,:),Y1(end:-1:1,1),M(end:-1:1,:),[v v]); %limiter contour
[C,C1]=getClosedContour(C);

if ~isempty(C) % no limiter configuration, the closed contour not in the limiter
    for ii=1:length(indexLim)
        XLimiter=XX(indexLim(ii));
        YLimiter=YY(indexLim(ii));
        plot(XLimiter,YLimiter,'.b')
        gapLimiter(ii)=min(sqrt((C(1,2:end)-XLimiter).^2+ (C(2,2:end)-YLimiter).^2));
    end
    if min(gapLimiter)>0.01
        C=[]; % nolimiter configuration
    else
        if max(abs(C(2,2:end)))>0.52
            C=[];
        end
    end
end

%% divertor configuration
if isempty(C) % no limiter configuration, the closed contour not in the limiter
    
    %find the X point in a small area
    % find the upper X point
    
    offsetX=fix(m1/4);
    offsetY=fix(n1*1/4);
    
    N=M(offsetX:offsetX*2,offsetY:offsetY*3);% upper X point
    
    [V1,I1] = min(N,[],1);
    [V2,I2] = max(N,[],2);
    [v1,i1] = max(V1);
    [v2,i2] = min(V2);
    
    Zupper=Y1(offsetX+I1(i1),offsetY+i1); % the upper X point, define the top of plasma
    
    %% spline result is almost the same as direct calculation
    % upper X point
    
    
    Xstart=X1(offsetX+I1(i1),offsetY+i1-1);
    Xend=X1(offsetX+I1(i1),offsetY+i1+1);
    Ystart=Y1(offsetX+I1(i1)-1,offsetY+i1);
    Yend=Y1(offsetX+I1(i1)+1,offsetY+i1);
    
    pointNum=33;
    
    [X2,Y2]=meshgrid(linspace(Xstart,Xend,pointNum),linspace(Ystart,Yend,pointNum));
    Z2= interp2(X1,Y1,M,X2,Y2,'spline');
    %%
    
    %find the accurate flux value
    [V3,I3] = min(Z2,[],1);
    [V4,I4] = max(Z2,[],2);
    [v3,i3] = max(V3);
    [v4,i4] = min(V4);
    vUpper=(v3+v4)/2;
    
    Zupper1=Y2(I3(i3),i3);
    if isDrawPoint==1
        %         plot(X2(I3(i3),i3),Zupper1,'.b')  % upper or lower X point
    end
    
    % find the lower X point
    %     indexOffset=fix(m1/2);
    %  fix(n1*1/4):fix(n1*3/4) position is in the center
    N=M(offsetX*2:offsetX*3,offsetY:offsetY*3);   % lower X point
    
    [V1,I1] = min(N,[],1);
    [V2,I2] = max(N,[],2);
    [v1,i1] = max(V1);
    [v2,i2] = min(V2);
    
    Zlower=Y1(offsetX*2+I1(i1),offsetY+i1);
    
    %% spline result is almost the same as direct calculation
    
    % lower X point
    Xstart=X1(offsetX*2+I1(i1),offsetY+i1-1);
    Xend=X1(offsetX*2+I1(i1),offsetY+i1+1);
    Ystart=Y1(offsetX*2+I1(i1)-1,offsetY+i1);
    Yend=Y1(offsetX*2+I1(i1)+1,offsetY+i1);
    pointNum=33;
    [X2,Y2]=meshgrid(linspace(Xstart,Xend,pointNum),linspace(Ystart,Yend,pointNum));
    Z2= interp2(X1,Y1,M,X2,Y2,'spline');
    %%
    
    %find the accurate flux value
    [V3,I3] = min(Z2,[],1);
    [V4,I4] = max(Z2,[],2);
    [v3,i3] = max(V3);
    [v4,i4] = min(V4);
    vLower=(v3+v4)/2;
    
    Zlower1=Y2(I3(i3),i3);
    if isDrawPoint==1
    end
    v=vLower;
    
    %% find the exact contour
    [Xf,Yf]=getGridFine;
    Mf= interp2(X1,Y1,M,Xf,Yf,'spline');
    C=[];
    
    isClosed=0;
    isOpen=0;
    isOK=0;
    if ~isNear
        delV=phiCenter-v;
        vStep=delV/100;
    end
    
    %     for ik=1:32
    for ik=1:30
        C = contourc(Xf(1,:),Yf(end:-1:1,1),Mf(end:-1:1,:),[v v]);
        C=getClosedContour(C);
        if ~isempty(C)  % closed contour
            if isOK
                break
            end
            if isOpen
                vStep=vStep/2;
            else
                vStep=vStep*2;
            end
            v=v-vStep;
            isClosed=1;
        else  % no closed contour
            if isOK
                v=v+vStep;
                break
            end
            if isClosed
                vStep=vStep/2;
            else
                vStep=vStep*2;
            end
            v=v+vStep;
            isOpen=1;
        end
        if isClosed && isOpen && vStep<okStep
            isOK=1;
        end
    end

    if 1
%         [C,h2] = contour(Xf,Yf,Mf,v-[-20:1:20]*0.01);
        [C,h1] = contour(Xf,Yf,Mf,v,'k');
        pause(delay)
        delete(h1)
%         delete(h2)
    end
    
    C = contourc(Xf(1,:),Yf(end:-1:1,1),Mf(end:-1:1,:),[v v]);
    % fast and less points
    %      C = contourc(X1(1,:),Y1(end:-1:1,1),M(end:-1:1,:),[v v]);
    [C,C1]=getClosedContour(C);
     
    %%  end find the exact contour
else % limiter configuration
    %     Ip=Ip*1;
end
if isempty(C)
    [C,h] = contour(X1,Y1,M,v-[-80:10:80]*vStep*100);
    M=[];
    C=[];
    index=[];
    return
else
    
end
%% show some information
isDrawPoint=0;
if isDrawPoint==1
    
    
    %     Zupper=max(C(2,2:end))
    %     Zlower=min(C(2,2:end))
    %
    %     index1=find(Y1<Zupper);
    %     index2=find(Y1>Zlower);
    %     index1=intersect(index1,index2);
    %
    %
    %     Xright=max(C(1,2:end))
    %     Xleft=min(C(1,2:end))
    %
    %     index2=find(X1<Xright);
    %     index3=find(X1>Xleft);
    %
    %     index2=intersect(index3,index2);
    %     index1=intersect(index1,index2);
    %
    %     [phiCenter,indexMax]=max(M(index1));
    %
    %     XCurrentCenter=X1(index1(indexMax(1)))
else
    ZC=C(2,2:end);
    Zupper=max(ZC);
    [Zlower,indZlower]=min(ZC);
    %     Xlower=ZC(indZlower)
    
    
    index1=find(Y1<Zupper);
    index2=find(Y1>Zlower);
    index1=intersect(index1,index2);
    
    
    Xright=max(C(1,2:end));
    Xleft=min(C(1,2:end));
    %     XpGeo=(Xright+Xleft)/2
    %     dX=(Xright-Xleft)
    %     dZ=(Zupper-Zlower)
    %     elong=dZ/dX
    index2=find(X1<Xright);
    index3=find(X1>Xleft);
    
    index2=intersect(index3,index2);
    index1=intersect(index1,index2);
    [phiCenter,indexMax]=max(M(index1));
end

phiBoundary=v;
delPhi=phiCenter-phiBoundary; %
Mout=M;
if isempty(delPhi) || isempty(phiBoundary)
    iiii=1;
end

% normalized for GS equation
M_norm=(M-phiBoundary)/delPhi;  %modify flux

index=find(M_norm>0);
index=intersect(index,index1);

%% argument out

% M=Mout;  %deadly wrong

%% calculate the current density
if 0
        hShow=ShowShape(gFit,Mout,v,phiCenter,C,index);
end

if nargout>=4
    varargout{1}=C1;
end
if nargout>=5
    varargout{2}=v;
end
if nargout>=6
    varargout{3}=phiCenter;
end
return


%%
figure
p=DrawBackground(gFit.limiterRadius);
[C,h2] = contour(Xf,Yf,Mf,[20:1:20]*0.1);
[C,h1] = contour(Xf,Yf,Mf,v,'k');
%         pause(delay)
%         delete(h1)
%         delete(h2)
%%
figure
p=DrawBackground(gFit.limiterRadius);
%             [C,h] = contour(X1,Y1,M,[-20:1:20]*0.01);
[C,h] = contour(X1,Y1,M,v);
%%
sourceLen=numel(index);
X2=reshape(X1(index),1,sourceLen);%
Y2=reshape(Y1(index),1,sourceLen);%
XX=[X2;X2];
YY=[Y2;Y2+0.0001];
h=plot(XX,YY,'.','LineWidth',1); %plasma
%%
XX=C(1,2:end);
YY=C(2,2:end);
% h=plot(XX,YY,'.','LineWidth',0.5); %plasma
h=plot(XX,YY,'r','LineWidth',1); %plasma
%%

%%

