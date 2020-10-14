function [indexBoundary,fieldNullXY]=getBoundaryByC(C)
%%
% This code get the Boundary coordinates from C data, C have one value, 
% at most two curves
% input description
% C is contour data for one value
%
% output description
% indexBoundary is the grid index of boundary
% fieldNullXY is the XY of C, smooth curve


%%
% Numcoils=18;
[X1,Y1]=getGrid;

%% H
dX=X1(1,2)-X1(1,1);  % grid size
dY=Y1(1,1)-Y1(2,1);

indexBoundary=[];
pointNum=C(2,1);
XY=C(:,2:pointNum+1); % contour point
indexBoundaryXY=XY;

%%  find the boundary
for i=1:pointNum
    indexB=find(sqrt((X1-XY(1,i)).^2/dX^2+(Y1-XY(2,i)).^2/dY^2)<=0.5);
    if length(indexB)~=1
        db=1;
    else
        indexBoundary=[indexBoundary indexB];
    end
end


 if pointNum+1<size(C,2)
    pointNum1=C(2,pointNum+2);
    XY=C(:,pointNum+3:pointNum+1+pointNum1+1);
    indexBoundaryXY=[indexBoundaryXY XY];
    for i=1:pointNum1
        
        indexB=find(sqrt((X1-XY(1,i)).^2/dX^2+(Y1-XY(2,i)).^2/dY^2)<=0.5);
        if length(indexB)~=1
            db=1;
        else
            indexBoundary=[indexBoundary indexB];
        end
    end
end


 if pointNum+1<size(C,2) && pointNum+1+pointNum1+1<size(C,2)
    pointNum2=C(2,pointNum+1+pointNum1+1+1);
    XY=C(:,pointNum+1+pointNum1+1+1+1:pointNum+1+pointNum1+1+pointNum2+1);
    indexBoundaryXY=[indexBoundaryXY XY];
    for i=1:pointNum2
        
        indexB=find(sqrt((X1-XY(1,i)).^2/dX^2+(Y1-XY(2,i)).^2/dY^2)<=0.5);
        if length(indexB)~=1
            db=1;
        else
            indexBoundary=[indexBoundary indexB];
        end
    end
end



%%


%%  find the boundary

indexBoundaryY=indexBoundaryXY(2,:);
% tailoring the curve by vertical coordinates
 Yline=1.1;
% Yline=1.3;
% Yline=1.4;
% Yline=0.8;
% Yline=1.0;
% Yline=1.1;
% Yline=0.9;

indexFieldNull= abs(indexBoundaryY)<Yline;
fieldNullXY=indexBoundaryXY(:,indexFieldNull);
fieldNullXY(:,end)=[];% cancel the repeat point
%%

