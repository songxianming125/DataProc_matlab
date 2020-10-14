function j=plasmaMove(j,row,col)
oldDim=size(j);
[X1,Y1]=getGrid;
j=reshape(j,size(X1));

if row>0 % move downward
    j(row+1:end,:)=j(1:end-row,:);
    j(1:row,:)=0;
else  % move upward
    j(1:end-row,:)=j(row+1:end,:);
    j(end-row+1:end,:)=0;
end

if col>0 % move right
    j(:,col+1:end)=j(:,1:end-col);
    j(:,1:col)=0;
else  % move left
    j(:,1:end-col)=j(:,col+1:end);
    j(:,end-col+1:end)=0;
end

j=reshape(j,oldDim); % return to the old dimension