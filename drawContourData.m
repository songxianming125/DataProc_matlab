function hisDraw = drawContourData(C,v)
%% 
% DRAWCONTOURDATA the short description(H1 line help)
% SYNTAX
% [output] = DRAWCONTOURDATA(A)
% option=1 means the item is necessary, option=0 means the item is optional
% input
% option  VarName             DataType           Meaning
% 0       V                   int/double         the loop voltage in V
% 0       num                 int                the number of element
%
% output:
% option    VarName             DataType        Meaning      
% 0         X                    double          X coordinates
% 0         Y                    double          Y coordinates
% 0         I                    double          The total current in A
% 0         S                    double          current density in A/m2
% 0         L                    double    the length from the start point
% 
% 
% INPUT PARAMETERS
% if nargin==0
% elseif nargin==1
%     C=varargin{1};
% elseif nargin==2
%     C=varargin{1};
%     C=varargin{2};
% elseif nargin==3
%     C=varargin{1};
%     C=varargin{2};
%     C=varargin{3};
% elseif nargin>3
%     disp('too many input parameters for function drawContourData')
% end
%
% DESCRIPTION
% Exhaustive and long description of functionality of drawContourData.
%
% Examples:
% description of example for drawContourData
% >> [output] = drawContourData(A);
%
% See also:
% ALSO1, ALSO2
%
% References:
% [1] A. Einstein, Die Grundlage der allgemeinen Relativitaetstheorie,
%     Annalen der Physik 49, 769-822 (1916).
% Author: Dr. Xianming SONG
% Email: songxm@swip.ac.cn
% Copyright (c) %Southwestern Institute of Physic, PO. Box 432#, Chengdu, China. 1966-2015
% All Rights Reserved.
% Version 1.0 , Created on: 09-Apr-2015 12:57:13

% write down your codes from here.


height=1.4;
hNum=0;




while size(C,2)>1
    C1=C(:,2:C(2,1)+1);
    if C(1,1)==v
        hNum=hNum+1;
        hisDraw(hNum)=plot(C1(1,:),C1(2,:),'-k', 'LineWidth',1.5);
    else
        if  max(max(abs(C1(2,:))))>height
            %             hNum=hNum+1;
            %             hisDraw(hNum)=plot(C1(1,:),C1(2,:),'--b');
        else
            if size(C1,2)>10
                hNum=hNum+1;
                hisDraw(hNum)=plot(C1(1,:),C1(2,:),'--b', 'LineWidth',0.2);
            else
                hNum=hNum+1;
                hisDraw(hNum)=plot(C1(1,:),C1(2,:),'+r');
            end
        end
    end
    
    C(:,1:C(2,1)+1)=[];
    
    
end




% OUTPUT PARAMETERS
% if nargout==1
%     varargout{1}=R;
% elseif nargout==2
%     varargout{1}=R;
%     varargout{2}=S;
% elseif nargout==3
%     varargout{1}=R;
%     varargout{2}=S;
%     varargout{3}=V;
% elseif nargout>3
%     disp('too many output parameters for function drawContourData')
% end
