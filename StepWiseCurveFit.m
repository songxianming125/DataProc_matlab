function [varargout]=StepWiseCurveFit(varargin)
%%%********************************************************%%%
%%%This program is to fit the curve by a stepwise linear way%%%
%%%       Written by Ren donghong 2008/02/01                %%%
%%%      modified by Song xianming 2008/09/25/              %%%
%%%********************************************************%%%
%%%********************************************************%%%
%%%********************************************************%%%
%%%********************************************************%%%
%%%********************************************************%%%
%varargin description
% should have 3 input
% there are two way to input data
    % 1) y,x,X
    % 2) shotnumber, channelname, vecchannelname
    
    
%varargout description
% there are six way to output
    % 1) Y
    % 2) Y,X
    % 3) Y,X,fitY,fitX
    % 4) Y,X,fitY,fitX,Yfit
    % 5) Y,X,fitY,fitX,Yfit,vecY
    % 6) Y,X,fitY,fitX,Yfit,vecY,expY



vecY=[];
if isscalar(varargin{1}) && isnumeric(varargin{1}) && ischar(varargin{2}) && ischar(varargin{3})
    shotnumber=varargin{1};
    vecchannelname=varargin{2};
    channelname=varargin{3};
    [y,x]=hl2adb(shotnumber,channelname);
    if isempty(x)
        msgbox(['no curve for:' channelname])
        return
    end
    [vecY,X]=hl2adb(shotnumber,vecchannelname);
    if isempty(X)
        msgbox(['no curve for:' vecchannelname])
        return
    end
    if nargin>3
        if nargin>4
            factor=varargin{5}; %unit tranformation
        else
            factor=1;
        end
        offsetchannelname=varargin{4};
        [y1,x1]=hl2adb(shotnumber,offsetchannelname);
        if isempty(x1)
            msgbox(['no curve for:' offsetchannelname])
            return
        end
        %input data adjusting
        index=find(x<x1(1));
        if isempty(index)
            index=find(x1<x(1));
            if ~isempty(index)
                x1(index)=[];
                y1(index)=[];
                x1(1)=x(1);
            end
        else
            x(index)=[];
            y(index)=[];
            x(1)=x1(1);
        end

        index=find(x>x1(end));
        if isempty(index)
            index=find(x1>x(end));
            if ~isempty(index)
                x1(index)=[];
                y1(index)=[];
                x1(end)=x(end);
            end
        else
            x(index)=[];
            y(index)=[];
            x(end)=x1(end);
        end
        
        if length(x)>length(x1)
            index=interp1(x,[1:length(x)],x1,'nearest','extrap');
            x=x1;
            y=y(index)+factor.*y1;
        elseif length(x)<=length(x1)
            index=interp1(x1,[1:length(x1)],x,'nearest','extrap');
            y=y+factor.*y1(index);
        end
    end
elseif isvector(varargin{1}) && isvector(varargin{2}) && isvector(varargin{3}) && isnumeric(varargin{1})
    y=varargin{1};
    x=varargin{2};
    X=varargin{3};
    vecY=[];
else
    msgbox('input parameter is wrong')
    return
end

%input data adjusting, make sure x(1)<=X<=x(end)
index=find(x<X(1));
if isempty(index)
    index=find(X<x(1));
    if length(index)>1
        X(index(1:end-1))=[];
        vecY(index(1:end-1))=[];
    end
    X(1)=x(1);
else
    x(index)=[];
    y(index)=[];
    x(1)=X(1);
end

index=find(x>X(end));
if isempty(index)
    index=find(X>x(end));
    if length(index)>1
        X(index(2:end))=[];
%         vecY(index(2:end))=[];
    end
    X(end)=x(end);
else
    x(index)=[];
    y(index)=[];
    x(end)=X(end);
end

[X, m, n] = unique(X);
if ~isempty(vecY)
    vecY=vecY(m);
end




Z=[];     %for store the fit data
Y=[];
kA=zeros(1,length(X)-1);%for slope
kr=zeros(1,length(X)-1);%for corrcoef
% index0=interp1(x,[1:length(x)],[X(1)],'nearest','extrap');%first index
for i=1:(length(X)-1)
    %for segmenting the curve
    index1=interp1(x,[1:length(x)],[X(i)],'nearest','extrap');  % the involved node
    index2=interp1(x,[1:length(x)],[X(i+1)],'nearest','extrap')-1;  %from the involved node to just before the next node
    if index2>index1  %it is supposed to be right
        yy=y(index1:index2);   %divide the curve into many segment for fitting       将y数组分成若干个数组，对每一段进拟合处理
        xx=x(index1:index2);
        A=polyfit(xx,yy,1);  %n=1 mean linear fitting;  A is the coeficient
        %         A(1) is the slope     %直线的斜率
        if abs(A(1))<eps
            A(1)=eps;
        end
        kA(i)=1/abs(A(1));
        k=abs(corrcoef(xx',yy'));
        kr(i)=k(1,2);
        
        z=polyval(A,xx);     %拟合以后的数据
        Z=[Z;z];      %归并为一个数组
    elseif index2<index1  %supposed never happen
        continue  %jump by one point
    elseif index2==index1 %when two point overlay
        Z=[Z;y(index1)];      %move on by one point
        kA(i)=1;
        kr(i)=1;
    end
    
    
    
end

Z=[Z;Z(end)];      %???  add one element for remaining the length of curve


%经过以上处理，我们看到很多嘈杂信号变成直线，但是每条直线的连接处不可避免的出现跳跃间断点
%我们有必要对它再次处理，以下处理可以利用：取相邻的两个间断点的加权平均值


Y=[Z(1)];
for j=2:(length(X)-1)
    index=interp1(x,[1:length(x)],[X(j)],'nearest','extrap')-1;%-index0; %the index just before the involved node
    % for weighted adjusting
    if index<1 %not supposed to occur
        index=1;
    elseif index>=length(Z)%not supposed to occur
        index=length(Z)-1;
    end
    %weight factor   
    w1=kr(i-1)*kA(i-1)*kA(i-1)*(X(j)-X(j-1));  % weighted by range, correlation coefficient and slope
    w2=kr(i)*kA(i)*kA(i)*(X(j+1)-X(j));
    if w1+w2>0
        pp=(w1*Z(index)+w2*Z(index+1))/(w1+w2);  %weighted average
    else
        pp=Z(index);
    end
    Y=[Y;pp];
end
Y=[Y;Z(length(Z))];

fitX=x; %make sure the x and y the same length
fitY=Z; %stepwise fitting, not continuing


Yfit=interp1(X,Y,x,'linear');%continuing fitting
figure
% plot(x,y,'g',fitX,fitY,'.b',X,Y,'-dr')
plot(x,y,'g',fitX,fitY,'.b',X,Y,'-dr',x,Yfit+0.2,'-y')
if nargout>0
    varargout{1}=Y;
end
if nargout>1
    varargout{2}=X;
end
if nargout>3
    varargout{3}=fitY;
    varargout{4}=fitX;
end
if nargout>4
    varargout{5}=Yfit;
end

if nargout>5
    if isempty(vecY)
        varargout{6}=[];
    else
        varargout{6}=vecY;
    end
end
if nargout>6
    varargout{7}=y;
end

if nargout>7
    disp('output parameter are wrong')
end
