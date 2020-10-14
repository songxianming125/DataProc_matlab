function [dy, t]= getGradient(y1,t1)
%% force t1(1)=0; force tstep/dt as integer
tstep=0.10; % s  50ms
dt=t1(2)-t1(1);
DeltaT=t1(end)-t1(1);
numT=round(tstep/dt);
lengT=round(DeltaT/tstep);
t=t1(1)+tstep*(1:lengT)';
y=zeros(1,lengT);
for i=1:lengT-1
    tStart=1+(i-1)*numT;
    tEnd=i*numT;
    y(i) =mean(y1(tStart:tEnd));
end
dy=diff(y')/dt;
dy(end+1)=0;
end

