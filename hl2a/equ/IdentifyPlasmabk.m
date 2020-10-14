function [M,C,index]=IdentifyPlasma(X1,Y1,M,MLimiter,Point,isDraw)
%% draw contour for flux
global Ip

index=[];
isDrawPoint=1;
vStep=0.0001;
[m1,n1]=size(M);

% check if plasma is limited
XX=Point(1,:);
YY=Point(2,:);


%% limiter or divertor

% find the flux at limiter    

[v,indexLim]=max(MLimiter);
XLimiter=XX(indexLim(1));
YLimiter=YY(indexLim(1));

plot(XLimiter,YLimiter,'.b')
if isDraw
    [C,h] = contour(X1,Y1,M,v);
end
C = contourc(X1(1,:),Y1(end:-1:1,1),M(end:-1:1,:),[v v]); %limiter contour
C=getClosedContour(C);

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
       Ydivertor=min(C(2,:));
        if Ydivertor<-0.45
            C=[];
        end
   end
end

%% divertor configuration
if isempty(C) % no limiter configuration, the closed contour not in the limiter

    %find the X point in a small area
    % find the upper X point
    N=M(1:fix(m1/2),fix(n1*1/4):fix(n1*3/4));% upper X point
    
    [V1,I1] = min(N,[],1);
    [V2,I2] = max(N,[],2);
    [v1,i1] = max(V1);
    [v2,i2] = min(V2);
    
    Zupper=Y1(I1(i1),i1); % the upper X point, define the top of plasma
    
    %% spline result is almost the same as direct calculation
    % upper X point
    
    if i1==1
        i1=i1+1;
    end
    if I1(i1)==1
        I1(i1)=I1(i1)+1;
    end
    
    
    Xstart=X1(I1(i1),i1-1);
    Xend=X1(I1(i1),i1+1);
    Ystart=Y1(I1(i1)-1,i1);
    Yend=Y1(I1(i1)+1,i1);
    
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
        plot(X2(I3(i3),i3),Zupper1,'.b')  % upper or lower X point
    end
    
    % find the lower X point
    indexOffset=fix(m1/2);
   %  fix(n1*1/4):fix(n1*3/4) position is in the center
    N=M(indexOffset+1:fix(m1),fix(n1*1/4):fix(n1*3/4));   % lower X point
    
    [V1,I1] = min(N,[],1);
    [V2,I2] = max(N,[],2);
    [v1,i1] = max(V1);
    [v2,i2] = min(V2);
    
    Zlower=Y1(I1(i1)+indexOffset,i1);
    
    %% spline result is almost the same as direct calculation
    
    % lower X point
    if i1==1
        i1=i1+1;
    end
    if I1(i1)+indexOffset==129
        I1(i1)=I1(i1)-1;
    end
    Xstart=X1(I1(i1)+indexOffset,i1-1);
    Xend=X1(I1(i1)+indexOffset,i1+1);
    Ystart=Y1(I1(i1)+indexOffset-1,i1);
    Yend=Y1(I1(i1)+indexOffset+1,i1);
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
        plot(X2(I3(i3),i3),Zlower1,'.g')  % upper or lower X point
    end
    
    
    
    
    
    
    % plot(X1(I1(i1),i1),Y1(I1(i1),i1),'+r')  % X point
    % remove the point outside the plasma
    % dY=Y1(1,1)-Y1(2,1);
    % index1=find(abs(Y1)>1.3);
    % M(index1)=M(index1)-100;
    % draw contour
    % RSV2M(1,0)
    % if abs(v1-v2)<0.01
    v=max(vLower,vUpper);
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
    [Xf,Yf]=getGridFine;
    Mf= interp2(X1,Y1,M,Xf,Yf,'spline');
    C=[];
    for ik=1:30
        C = contourc(Xf(1,:),Yf(end:-1:1,1),Mf(end:-1:1,:),[v v]);
        C=getClosedContour(C);
        v=v+vStep;
        if ~isempty(C)
            break;
        end
    end
 %%   
    %
    % [C,h] = contour(Xf,Yf,Mf,v);%,10);-1e-5 -9e-6 -8e-6-7e-6 -6.8e-6 -6.5e-6
    %
  %  [C,h] = contour(X1,Y1,M,v);
    % clabel(C,h)
    % colorbar;
else % limiter configuration
    Ip=Ip*1;
end

%% calculate the current density
if isempty(C)
    [C,h] = contour(X1,Y1,M,v-[-80:10:80]*vStep);
    M=[];
    C=[];
    index=[];
    return
end
%% show some information
% isDrawPoint=1;
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

