function [Point,varargout]=setControlPoint(Point,varargin)
global  isRZIp

%% set the point in contour for target
% outputType function
% 0 simple output
% 1 8 points output
% 2 move output
if nargin>0
    outputType=varargin{1};
else
    outputType=0;
end

delX=0;
delY=0;

switch outputType
	%% simple output
    case 0
	%% 8 point control method
    case 1        
        X=Point(1,:);
        Y=Point(2,:);
        
        [Z1,indexMax] =max(Y);
        Z5=min(Y);
        Z2=Z1-(Z1-Z5)/4;
        Z3=0;
        Z4=Z1-3*(Z1-Z5)/4;
        
        
        Xmax=X(indexMax(1));
        YL=Y(X<Xmax);
        XL=X(X<Xmax);
        YR=Y(X>Xmax);
        XR=X(X>Xmax);
        
        %counterclockwise
        index1=find(Y==Z1, 1, 'first');
        index5=find(Y==Z5, 1, 'first');
        
        [~,index2] =min(abs(YL-Z2));
        [~,index3] =min(abs(YL-Z3));
        [~,index4] =min(abs(YL-Z4));
        
        [~,index6] =min(abs(YR-Z4));
        [~,index7] =min(abs(YR-Z3));
        [~,index8] =min(abs(YR-Z2));
        
        
        XC=[X(index1) XL([index2(1) index3(1) index4(1)]) X(index5) XR([index6(1) index7(1) index8(1)])];
%         XC(5)=XC(5)+0.02;
%         XC(6)=XC(6)+0.02;
        %change the bottom point
%         ZC=[Y(index1) YL([index2(1) index3(1) index4(1)]) Y(index5)+5*delY YR([index6(1) index7(1) index8(1)])];
        ZC=[Y(index1) YL([index2(1) index3(1) index4(1)]) Y(index5) YR([index6(1) index7(1) index8(1)])];
        
        
  %      Point=[XC+0.02;ZC];
         Point=[XC;ZC];
        
        X=Point(1,:);
        Y=Point(2,:);
        if isRZIp
            index=2:2:8;
        else
            index=1:1:8;
        end
        XX=[X(index);X(index)];
        YY=[Y(index);Y(index)+0.0001];
        h=plot(XX,YY,'.','LineWidth',1); %plasma
        
	%% simple output
    case 2
        Point(1,:)=Point(1,:)+delX;
        Point(2,:)=Point(2,:)+delY;
        %% build a bean shape
        %     setY=0.7;
        %     setZ=1.1;
        %
        %     X=Point(1,:);
        %     Y=Point(2,:);
        %
        %
        %     [Ymax,indexMax] =max(Y);
        %     Xmiddle=X(indexMax(1));
        %
        %
        %
        %     indexArcInner1=find(X<Xmiddle);
        %     indexArcInner2=find(abs(Y)<setY);
        %     indexArcInner3=find(abs(Y)<setZ);
        %
        %
        %
        %
        %     indexArcInner=intersect(indexArcInner1,indexArcInner2);
        %     [dY,indexCrit] =min(abs(Y(indexArcInner1)-setY));
        %     Xcrit=X(indexArcInner1(indexCrit(1)));
        %
        %     X(indexArcInner)=Xcrit-2.*(X(indexArcInner)-Xcrit);
        %
        %
        %
        %     indexArcInner1=intersect(indexArcInner1,indexArcInner3);
        %     [dY,indexCrit] =min(abs(Y(indexArcInner1)-setZ));
        %     Xcrit1=X(indexArcInner1(indexCrit(1)));
        %
        %
        %    offset=min(-X(indexArcInner1)+Xcrit1);
        %
        %     X(indexArcInner1)=Xcrit1-0.1.*((-X(indexArcInner1)+Xcrit1-offset)*5).^0.5;
        %
        %
        %     indexArcInner1=find(X>Xmiddle);
        %     X(indexArcInner1)=X(indexArcInner1)*0.92;
        %     X=X+0.06;
        %
        %     Ytop=1.172;
        %     indexPoint=find(abs(Y)<Ytop);
        %     X=X(indexPoint);
        %     Y=Y(indexPoint);
        %
        %     Point=[X;Y];
        %
        %     [v,IX] = sort(X,'descend');
        %     [v,IY] = sort(Y,'descend');
        %     varargout{1}=[IX(1:2) IX(end-1:end)]; % index of first 2 and last 2 X
        %     varargout{2}=[IY(1:2) IY(end-1:end)]; % index of first 2 and last 2 Y
        % return
        %
        %
        % %  %% move and shaping
        % % if nargin>1
        % %     setShape=varargin{1};
        % %     Ztop=setShape.top;
        % %     Rx=setShape.Rx;
        % %     Zx=setShape.Zx;
        % %     Xout=setShape.Xout;
        % %     Xin=setShape.Xin;
        % % else
        % %     Ztop=1.03;
        % %     Rx=1.48;
        % %     Zx=-1.08;
        % %     Xout=2.43;
        % %     Xin=1.13;
        % % %     Xtop=1.48;
        % % %     Zout=0;
        % % %     Zin=0;
        % % end
        %
        %
        % % XC=Point(1,:);
        % % ZC=Point(2,:);
        % % Ztop1=max(ZC);
        % % [Zx1,indZlower]=min(ZC);
        % % Rx1=XC(indZlower(1));
        % % Xout1=max(XC);
        % % Xin1=min(XC);
        % %
        % % % stretch in Z direction
        % % indX=find(ZC>Zx1);
        % % ZC(indX)=Zx+(Ztop-Zx)./(Ztop1-Zx1).*(ZC(indX)-Zx1);
        % % %hold on
        % % ZC(ZC==Zx1)=Zx;
        % %
        % %
        % % %divide the point by its R location, greater than X point or less than.
        % % indLeft=find(XC<Rx1);
        % % indRight=find(XC>Rx1);
        % % %hold on
        % % XC(XC==Rx1)=Rx;
        % % %stretch in x direction
        % % XC(indRight)=Rx+(Xout-Rx)./(Xout1-Rx1).*(XC(indRight)-Rx1);
        % % XC(indLeft)=Rx+(Xin-Rx)./(Xin1-Rx1).*(XC(indLeft)-Rx1);
        % % Point=[XC;ZC];
        % %
        % % X=Point(1,:);
        % % Y=Point(2,:);
        % % XX=[X;X];
        % % YY=[Y;Y+0.0001];
        % % h=plot(XX,YY,'.','LineWidth',1); %plasma
        % %
        % % [v,IX] = sort(XC,'descend');
        % % [v,IY] = sort(ZC,'descend');
        % % varargout{1}=[IX(1:2) IX(end-1:end)]; % index of first 2 and last 2 X
        % % varargout{2}=[IY(1:2) IY(end-1:end)]; % index of first 2 and last 2 Y
        % % return
        %
    case 10  % Big Bang expand
        % find the X point
        X=Point(1,:);
        Y=Point(2,:);
        
        [maxY,indexMax] =max(Y);
        [minY,indexMin] =min(Y);
        upperX=X(indexMax);
        lowerX=X(indexMin);
        
        maxLength=((maxY-minY)^2+(upperX-lowerX)^2)^0.5;
        rubberLength=(((Y-minY).^2+(X-lowerX).^2).^0.5)/maxLength;
        
        X=X+0.06*(X-lowerX).*rubberLength+0.08*(Y-minY).*rubberLength;
        Y=Y+0.06*(Y-minY).*rubberLength;
        
        Point(1,:)=X;
        Point(2,:)=Y;
            
        
        
end

[~,IX] = sort(Point(1,:),'descend');
[~,IY] = sort(Point(2,:),'descend');
varargout{1}=[IX(1:2) IX(end-1:end)]; % index of first 2 and last 2 X
varargout{2}=[IY(1:2) IY(end-1:end)]; % index of first 2 and last 2 Y


return
