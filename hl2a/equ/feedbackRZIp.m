function [iPF,dU,Iex,dFlux]=feedbackRZIp(Iex,j,Point,IX,IY,init,varargin)
% IX,IY is for position control
% There are 8 points totally
% RF control Z position 
% VF control R position

global Ip
persistent iPFs 
% global RR LL MM 

%% update Green Function at boundary
% Green function for points at boundary
if size(Point,2)~=8
    msgbox('should be 8 points')
    return
end

[fluxPlasmaPoint,fluxPFPoint]=getBoundaryGreenFn(Point);



if init==1 
    iPFs=zeros(2,5);
end


flux=fluxPlasmaPoint*j*Ip+fluxPFPoint*reshape(Iex,length(Iex),1);

dZ=(flux(2)-flux(4)-flux(6)+flux(8))/2/Ip;
dR=(-flux(2)-flux(4)+flux(6)+flux(8))/2/Ip;
dRZ=[dZ;dR];
dRZ=RZIpPID(dRZ,init);  %pid controller

b=flux-flux(1);
dFlux=(max(b)-min(b));



iPFs=circshift(iPFs,[0 -1]);

iPFs(:,5)=dRZ';
disp(iPFs)

% iPF=-[0 0 0 0 0 0 0 0 0 0 0 0 0 0 dRZ(1) -dRZ(1) dRZ(2) dRZ(2)]; %PF7 PF8
% iPF=-[0 0 0 0 0 0 1.8*dRZ(1) -1.8*dRZ(1) 0 0 0 0 0 0 0 0 dRZ(2) dRZ(2)]; %PF3 PF8

iPF=[0 dRZ(2) -dRZ(1) 0 0 0 0 0 0 0 0]; % dRZ(1)=vertical dRZ(2)=radial 

%% PS
% circuitIndex=1:18;% all coils
% numCircuit=length(circuitIndex);


% Names={'p','0','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L'};
% isSeries=zeros(numCircuit,1); %circuit style for connecting, parallel/series
% 
% [RR,LL,MM]=modifyRM(circuitIndex,isSeries);
% dU=iPF*(diag(LL)+MM+MM');% iPF= dIdt, dt=1ms; V inductance consumption; real matrix calculation  A s mOhmic mH
dU=0;
%% PS over

Iex=Iex+iPF;


end

%%



