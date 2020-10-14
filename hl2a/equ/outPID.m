function [outputS]=outPID(inputS,init,kFactor,tdFactor,tiFactor,rcFactor)
% assignment
persistent  K TS TD TI RC Num Signals oldSignals

if (init==1)
    K=0.2;
    TS=1;%ms
    TD=0.03;%ms
    TI=5;%ms
    RC=3;
    Num=numel(inputS);
%     Signals=repmat(reshape(inputS,Num,1),1,3);
    Signals=zeros(Num,3);
end



if (init==2)
    Signals=oldSignals;% restore
end

oldSignals=Signals;% for restore

%adaptive factor kFactor

% K=K*kFactor;
% TD=TD*tdFactor;%ms
% TI=TI*tiFactor;%ms
% RC=RC*rcFactor;



% if kFactor>2
%     kFactor=2;
% elseif kFactor<0.4
%     kFactor=0.4;
% end
% kFactor=1;

% discrete coef
a(1)=K*TD/TS;
a(2)=-K*(1+2*TD/TS);
a(3)=K*(1+TD/TS+TS/TI);


% aging
Signals(:,1:2)=Signals(:,2:3);
Signals(:,3)=reshape(inputS,Num,1);
% filtering
Signals(:,3)=Signals(:,2)*(1/(RC+1))+Signals(:,3)*(RC/(RC+1));


% S1=Signals(:,1)'*a(1)
% S2=Signals(:,2)'*a(2)
% S3=Signals(:,3)'*a(3)

outputS=Signals*reshape(a,3,1);









