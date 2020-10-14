function [C,varargout]=getClosedContour(Cs)
%% extract the contours
%       This program extract the contours                  
%       Cs are many contours, only one closed contour can exist
%       Developed by Song xianming 2013.11.30 

% output
% Cc is contour in cell
% C is closed contour for plasma boundary


% prepare initial values
C=[];
Cc=[];
if nargout>1
    varargout{1}={};
end
if size(Cs,2)==0
    return
end

conNum=1;
C1=Cs;
pointNum=C1(2,1);
X=C1(1,2);
Y=C1(2,2);
Xend=C1(1,pointNum+1);
Yend=C1(2,pointNum+1);
if  ~(X~=Xend || Y~=Yend || pointNum<3 || max(abs(C1(2,2:pointNum+1)))>0.52)
    C=C1(:,1:pointNum+1);% only one closed contour
else
    Cc={C1(:,1:pointNum+1)};
    conNum=conNum+1;
end


while pointNum+1<size(C1,2)
    C1=C1(:,pointNum+2:end);
    pointNum=C1(2,1);
    X=C1(1,2);
    Y=C1(2,2);
    Xend=C1(1,pointNum+1);
    Yend=C1(2,pointNum+1);
    if  ~(~isempty(C) || X~=Xend || Y~=Yend || pointNum<3 || max(abs(C1(2,2:pointNum+1)))>0.52)
        C=C1(:,1:pointNum+1);% only one closed contour
    else
        if ~isempty(Cc)
            Cc(conNum)={C1(:,1:pointNum+1)};
        else
            Cc={C1(:,1:pointNum+1)};
        end
        conNum=conNum+1;
    end
end
if nargout>1
    %     varargout{1}=Cc;
    if ~isempty(Cc)
        varargout{1}=Cc{1};
    else
        varargout{1}=C;
    end
end

return
% 
% function [C,C1]=getClosedContour(C)
% C1=C;
% 
% pointNum=C(2,1);
% X=C(1,2);
% Y=C(2,2);
% Xend=C(1,pointNum+1);
% Yend=C(2,pointNum+1);
% 
% 
% while X~=Xend || Y~=Yend || pointNum<3
%     C=C(:,pointNum+2:end);
%     if size(C,2)==0
%         C=[]; %no closed contour found
%         return
%     end
%     pointNum=C(2,1);
%     X=C(1,2);
%     Y=C(2,2);
%     Xend=C(1,pointNum+1);
%     Yend=C(2,pointNum+1);
% end
% 
% C=C(:,1:pointNum+1);
% 
% if size(C,2)<size(C1,2)
%         C1=C1(:,pointNum+2:pointNum+C1(2,pointNum+2)+1);
% end







