function [outputS]=RZIpPID(inputS,init)
%% standard PID controller
% assignment
global Ip
persistent  K TS TD TI RC Num Signals a

if (init==1)
    K=Ip*5e3;
    TD=0.1;%ms
    TI=0.1;%ms
    TS=1;%ms
    RC=3;
    Num=numel(inputS);
    Signals=zeros(Num,3);
    % discrete coef
    a(1)=K*TD/TS;
    a(2)=-K*(1+2*TD/TS);
    a(3)=K*(1+TD/TS+TS/TI);
end




% aging
% Signals(:,1:2)=Signals(:,2:3); %the same as the next line
Signals=circshift(Signals,[0 -1]);


Signals(:,3)=reshape(inputS,Num,1);
% filtering
Signals(:,3)=Signals(:,2)*(1/(RC+1))+Signals(:,3)*(RC/(RC+1));


% S1=Signals(:,1)'*a(1)
% S2=Signals(:,2)'*a(2)
% S3=Signals(:,3)'*a(3)

outputS=Signals*reshape(a,3,1);
