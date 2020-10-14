function t=TimeTailor(x,x1)
%songxm for formula calculating
%input data adjusting
% the common time interval is reserved.
index=find(x<x1(1));
if isempty(index)
    index=find(x1<x(1));
    if ~isempty(index)
        x1(index)=[];
        x1(1)=x(1);
    end
else
    x(index)=[];
    x(1)=x1(1);
end

index=find(x>x1(end));
if isempty(index)
    index=find(x1>x(end));
    if ~isempty(index)
        x1(index)=[];
        x1(end)=x(end);
    end
else
    x(index)=[];
    x(end)=x1(end);
end

%the low frequency is reserved
if length(x)>=length(x1)
    t=x1;
else
    t=x;
end


