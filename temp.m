function [M,C,index,varargout]=temp(X1,Y1,M,MLimiter,Point,isDraw,varargin)
%% draw contour for flux
persistent h hpoint
if nargin>6
    initPlasma=varargin{1};  %for initPlasma, the step should be large
else
    initPlasma=0;
end
if nargout>3
    varargout{1}=[];
end


if initPlasma
    vStep=0.0005;
    okStep=0.0001;
else
    vStep=0.00005;
    %     vStep=0.001;
    okStep=0.000002;
end

isDrawPoint=0;
delay=2;
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
        %        MLimiter=M(indexLimiterCol); % sometimes the maximum is in topdown, without closed contour, so try leftright
        %        [v,indexLim]=max(MLimiter);
        %        XLimiter=X1(indexLimiter(indexLim(1)));
        %        YLimiter=Y1(indexLimiter(indexLim(1)));
        %        plot(XLimiter,YLimiter,'.m')
        %        %  [C,h] = contour(X1,Y1,M,v);
        %        C = contourc(X1(1,:),Y1(end:-1:1,1),M(end:-1:1,:),[v v]); %limiter contour
        %        C=getClosedContour(C);
        %        if  ~isempty(C)
        %            for ii=1:length(indexLim)
        %                XLimiter=X1(indexLimiter(indexLim(ii)));
        %                YLimiter=Y1(indexLimiter(indexLim(ii)));
        %                plot(XLimiter,YLimiter,'.b')
        %                gapLimiter(ii)=min(sqrt((C(1,2:end)-XLimiter).^2+ (C(2,2:end)-YLimiter).^2));
        %            end
        %            if min(gapLimiter)>0.01
        %                MLimiter=M(indexLimiterCol1); % sometimes the maximum is in topdown, without closed contour, so try leftright
        %                [v,indexLim]=max(MLimiter);
        %                XLimiter=X1(indexLimiter(indexLim(1)));
        %                YLimiter=Y1(indexLimiter(indexLim(1)));
        %                plot(XLimiter,YLimiter,'.m')
        %                %  [C,h] = contour(X1,Y1,M,v);
        %                C = contourc(X1(1,:),Y1(end:-1:1,1),M(end:-1:1,:),[v v]); %limiter contour
        %                C=getClosedContour(C);
        %                if  ~isempty(C)
        %                    for ii=1:length(indexLim)
        %                        XLimiter=X1(indexLimiter(indexLim(ii)));
        %                        YLimiter=Y1(indexLimiter(indexLim(ii)));
        %                        plot(XLimiter,YLimiter,'.b')
        %                        gapLimiter(ii)=min(sqrt((C(1,2:end)-XLimiter).^2+ (C(2,2:end)-YLimiter).^2));
        %                    end
        %                    if min(gapLimiter)>0.01
        %                        v=v-vStep;
        %                        for ik=1:30
        %                            C = contourc(X1(1,:),Y1(end:-1:1,1),M(end:-1:1,:),[v v]);
        %                            C=getClosedContour(C);
        %                            if ~isempty(C)
        %                                break;
        %                            end
        %                            v=v-vStep;
        %                        end
        %                    end
        %                end
        %            end
        %        end
    else
        
        if max(abs(C(2,2:end)))>0.52
            C=[];
        else
%             if isDraw
%                 [C,hisDraw] = contour(X1,Y1,M,v);
%                 pause(delay)
%                 delete(hisDraw)
%             end
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
    %         plot(X2(I3(i3),i3),Zlower1,'.g')  % upper or lower X point
    
    
    
    
    
    % plot(X1(I1(i1),i1),Y1(I1(i1),i1),'+r')  % X point
    % remove the point outside the plasma
    % dY=Y1(1,1)-Y1(2,1);
    % index1=find(abs(Y1)>1.3);
    % M(index1)=M(index1)-100;
    % draw contour
    % RSV2M(1,0)
    % if abs(v1-v2)<0.01
    %     v=max(vLower,vUpper);
    v=vLower;
    % v=max(v,vLimiter);
    
    
    
    %
    % if isDraw==1
    %     if ishandle(h)
    %         delete(h)
    %     end
    %         [C,h] = contour(X1,Y1,M,v);
    %         [C,h] = contour(X1,Y1,M,v+0.001);
    % else
    %%  try to find the last closed flux surface
    %     C=[];
    %     vStep=0.0001;
    %     vC=v;
    %     for ik=1:30
    %         C = contourc(X1(1,:),Y1(end:-1:1,1),M(end:-1:1,:),[vC vC]);
    %         C=getClosedContour(C);
    %         vC=vC+vStep;
    %         if ~isempty(C)
    %             break;
    %         end
    %     end
    %%
%     [Xf,Yf]=getGridFine;
%     Mf= interp2(X1,Y1,M,Xf,Yf,'spline');
%     C=[];
%     
%     %     [C,h] = contour(Xf,Yf,Mf,v);
%     %     delete(h)
%     
%     delV=phiCenter-v;
%     vStep=delV/2;
%     isClosed=0;
%     
%     for ik=1:32
%         C = contourc(Xf(1,:),Yf(end:-1:1,1),Mf(end:-1:1,:),[v v]);
%         [C,C1]=getClosedContour(C);
%         if ~isempty(C) && min(C(2,2:end))>-0.52
%             
%             %             [Ct,h] = contour(Xf,Yf,Mf,v);
%             %             delete(h)
%             vStep=vStep/2;
%             v=v-vStep;
%             isClosed=1;
%         else
%             %             [Ct,h] = contour(Xf,Yf,Mf,v);
%             %             delete(h)
%             if isClosed
%                 vStep=vStep/2;
%             end
%             v=v+vStep;
%         end
%         
%         if vStep<0.00002*delV && isClosed
%             break
%         end
%         
%         %     [C,h] = contour(Xf,Yf,Mf,v);
%         %     delete(h)
%     end
%     %     [C,h] = contour(Xf,Yf,Mf,v-[-80:10:80]*vStep*1000);
%     %      delete(h)
%     if isClosed
%         v=v+vStep*2;
%         C = contourc(Xf(1,:),Yf(end:-1:1,1),Mf(end:-1:1,:),[v v]);
%         [C,C1]=getClosedContour(C);
%     else
%         C=[];
%     end
%     
    %%
    
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
    %     v=v-0.8*vStep;
    if 0
        [C,h2] = contour(Xf,Yf,Mf,v-[-20:1:20]*0.01);
        [C,h1] = contour(Xf,Yf,Mf,v,'k');
        pause(delay)
        delete(h1)
        delete(h2)
    end
    
    C = contourc(Xf(1,:),Yf(end:-1:1,1),Mf(end:-1:1,:),[v v]);
    % fast and less points
    %      C = contourc(X1(1,:),Y1(end:-1:1,1),M(end:-1:1,:),[v v]);
    [C,C1]=getClosedContour(C);
     
    %%  end find the exact contour
else % limiter configuration
    %     Ip=Ip*1;
end

%% calculate the current density
if isempty(C)
    [C,h] = contour(X1,Y1,M,v-[-80:10:80]*vStep*100);
    M=[];
    C=[];
    index=[];
    return
else
    if isDraw
        delV=phiCenter-v;
        numContour=10;
        vStep=delV/numContour;
        
        [~,hisDraw1] = contour(X1,Y1,M,v+[1:numContour]*vStep,'m');
        [~,hisDraw2] = contour(X1,Y1,M,v+[-3:2]*vStep/3,'b');
        [~,hisDraw3]= contour(X1,Y1,M,v,'r');
        set(hisDraw3,'linewidth',3)
        Dh1=((min(C(1,2:end))+max(C(1,2:end)))/2-1.65);
        Dv1=((min(C(2,2:end))+max(C(2,2:end)))/2);
        hisDraw4=plot(1.65+Dh1,Dv1,'+r');

        pause(delay*3)
        delete(hisDraw1)
        delete(hisDraw2)
        delete(hisDraw3)
        delete(hisDraw4)
    end
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
M=(M-phiBoundary)/delPhi;  %modify flux

index=find(M>0);
index=intersect(index,index1);

Fit.M=M;  % Matrix, modified phi in grid 
Fit.C=C;  % two row matrix, main contour
Fit.C1=C1; % two row matrix, secondary contour
Fit.Mout=Mout; % Matrix, original phi
Fit.phi=v; % scalar , phi in boundary
Fit.phiCenter=phiCenter; % scalar , phi in center
Fit.index=index; % vector, index for plasma


return


%%
[C,h] = contour(X1,Y1,M,v-[-80:10:80]*vStep*100);
% clabel(C,h)
colorbar;
delete(h)

