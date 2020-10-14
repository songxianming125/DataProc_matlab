function constraintMatrix=setConstraintMatrixSN(constraintMatrix,varargin)
%% set the constraint coeficient
% for Single Null 


%CS upper=lower
constraintMatrix(2,1)=-1;  
constraintMatrix(2,2)=1;

%PF1-4 is part of CS
if nargin>1
    %plasma shape control
    switch varargin{1}
        case 1
 load('Ratio','r')
            constraintMatrix(3,1)=-r(3);
            constraintMatrix(4,1)=-r(4);
            constraintMatrix(5,1)=-r(5);
            constraintMatrix(6,1)=-r(6);
            constraintMatrix(7,1)=-r(7);
            constraintMatrix(8,1)=-r(8);
            constraintMatrix(9,1)=-r(9);
            constraintMatrix(10,1)=-r(10);
            
            
%             constraintMatrix(3,1)=-1/8;
%             constraintMatrix(4,1)=-1/8;
%             constraintMatrix(5,1)=-1/22;
%             constraintMatrix(6,1)=-1/16;
%             constraintMatrix(7,1)=1/11;
%             constraintMatrix(8,1)=-1/40;
%             constraintMatrix(9,1)=1/13;
%             constraintMatrix(10,1)=1/11.5;
    end
else % field null configuration 
    % z=1.2 test
    constraintMatrix(3,1)=-1/8.9;
    constraintMatrix(4,1)=-1/8.9;
    constraintMatrix(5,1)=-1/8.4;
    constraintMatrix(6,1)=-1/8.4;
    constraintMatrix(7,1)=-1/8.0;
    constraintMatrix(8,1)=-1/8.0;
    constraintMatrix(9,1)=-1/7.8;
    constraintMatrix(10,1)=-1/7.8;
end


%upper!=lower for PF5-8



