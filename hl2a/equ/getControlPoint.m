function [Point,varargout]=getControlPoint(C,isManual)
% get the point in contour 
fieldNullXY=C(:,3:end); % one section contour % no repeating point/ unique.

if  isManual==0
    % automaticall set some point, focus on points near X points
    X=fieldNullXY(1,:);
    Y=fieldNullXY(2,:);
    [Zx,indexXpoint] =min(Y);
    numPoint=length(X);
    if numPoint>100
        X=circshift(X,[11-indexXpoint 0]); % lower X point is in the 11 point.
        Y=circshift(Y,[11-indexXpoint 0]);
%         index=[1:20 21:4:numPoint]; %cancel some points to focus on X point, weighting it much more
        index=1:4:numPoint; % homo
        X=X(index);
        Y=Y(index);
    end
    Point=[X;Y];
elseif isManual==1 
    % manual set some point, usually 8 points
    setY=[1 0.8 -0.8 -1];
    
    X=fieldNullXY(1,:);
    Y=fieldNullXY(2,:);
    
%     % draw the same number vertical line
%     XX=[X;X];
%     YY=[Y;Y+0.0001];
%     h=plot(XX,YY,'.','LineWidth',1); %plasma
    
    [Ymax,indexMax] =max(Y);
    Xmax=X(indexMax(1));
    
    YL=Y(X<Xmax);
    XL=X(X<Xmax);
    YR=Y(X>Xmax);
    XR=X(X>Xmax);
    for i=1:length(setY)
        [dY,index] =min(abs(YL-setY(i)));
        PL(1:2,i)=[XL(index);YL(index)];
        [dY,index] =min(abs(YR-setY(i)));
        PR(1:2,i)=[XR(index);YR(index)];
    end
    
    Point=[PL PR];
    
    %draw the same number vertical line
    X=Point(1,:);
    Y=Point(2,:);
    XX=[X;X];
    YY=[Y;Y+0.0001];
    h=plot(XX,YY,'.','LineWidth',1); %plasma
    
elseif isManual==2
    % the closest point to PF coil
    X=fieldNullXY(1,:);
    Y=fieldNullXY(2,:);
    XCenter=[748 748 912 912 912 912 912 912 912 912 1092 1092 1501 1501 2500 2500 2760 2760]/1000; %m 11/09/15
    YCenter=[860.575 -860.575 194 -194 582 -582 970 -970 1358 -1358 1753 -1753 1790 -1790 1200 -1200 480 -480]/1000;%m
    for i=3:length(XCenter)
        [dY,index] =min(sqrt((XCenter(i)-X).^2+(YCenter(i)-Y).^2));
        Point(1:2,i-2)=[X(index);Y(index)];
    end
    %draw the same number vertical line
    X=Point(1,:);
    Y=Point(2,:);
    XX=[X;X];
    YY=[Y;Y+0.0001];
    h=plot(XX,YY,'.','LineWidth',1); %plasma
end

if nargout>1
    X=Point(1,:);
    Y=Point(2,:);
    [v,IX] = sort(X,'descend');
    [v,IY] = sort(Y,'descend');
    varargout{1}=[IX(1:2) IX(end-1:end)]; % index of first 2 and last 2 X
    varargout{2}=[IY(1:2) IY(end-1:end)]; % index of first 2 and last 2 Y
elseif nargout>3
    disp('too many output')
end

