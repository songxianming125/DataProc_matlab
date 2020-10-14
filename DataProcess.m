%RC filter
tRC=0.1; %tRC is RC timeconstant

i=1;
CurrentChannels='MyTempData/1:Ipf';
[y,x,NewChannel]=LoadNewCurve4Add(CurrentChannels);
[d,m]=size(x);
MyData(1:d,2*i-1)=x;
MyData(1,2*i)=y(1);%initial value
for j=2:d
    MyData(j,2*i)=tRC/(1+tRC)*y(j)+1/(1+tRC)*MyData(j-1,2*i);
end



i=i+1;
CurrentChannels='MyTempData/2:Rf';
[y,x,NewChannel]=LoadNewCurve4Add(CurrentChannels);
[d,m]=size(x);
MyData(1:d,2*i-1)=x;
MyData(1,2*i)=y(1);%initial value
for j=2:d
    MyData(j,2*i)=tRC/(1+tRC)*y(j)+1/(1+tRC)*MyData(j-1,2*i);
end



i=i+1;
CurrentChannels='MyTempData/3:Zf';
[y,x,NewChannel]=LoadNewCurve4Add(CurrentChannels);
[d,m]=size(x);
MyData(1:d,2*i-1)=x;
MyData(1,2*i)=y(1);%initial value
for j=2:d
    MyData(j,2*i)=tRC/(1+tRC)*y(j)+1/(1+tRC)*MyData(j-1,2*i);
end


save 'MyTempData' MyData;
