function [iPF,dU,Iex,dFlux]=feedbackControl(Ip,Iex,j,Point,IX,IY,init,varargin)
% IX,IY is for position control
%% HL2A Coils
% OH   1
% VF   2
% RF   3
% MP1U  4
% MP2U  5
% MP3U  6
% MCU  7
% MP1L  8
% MP2L  9
% MP3L  10
% MCL  11
%%




global RR LL MM isOffsetPF7
persistent iPFs 


% select the freedom
if isOffsetPF7
    index=2:3; %PF1-8
else
    index=[2:3 8:11]; %PF1-8
end


%% update Green Function at boundary
% Green function for points at boundary

[fluxPlasmaPoint,fluxPFPoint]=getBoundaryGreenFn(Point); % smart enough to know whether it is needed to update.


if init==1 
    iPFs=zeros(length(index),5);
    disp(['index=' num2str(index)])
end


flux=fluxPlasmaPoint*j*Ip+fluxPFPoint*reshape(Iex,length(Iex),1);
% flux=fluxPlasmaPoint*j+fluxPFPoint*reshape(Iex,length(Iex),1);
b=flux-flux(1);
% b=flux-sum(flux(:))/numel(flux);
% b=flux;
% [baseVec,y]=getBaseVec(fluxPFPoint);
% k=getPIDpara(b,init);  %pid controller
dFlux=(max(b)-min(b));

% different point have different weight.  2014.2.12
   b=getPID(b,init);  %pid controller

% k=getPID(dFlux,init);  %pid controller
% b=k*b;


%  b=0.3*b;
 
disp([ '/dFlux=' num2str(dFlux)])
%% constraint
%     isConstraint=0;
%     if isConstraint
%         Numcoils=16;  %coil without CS
%         bConstraint=zeros(Numcoils,1);
%         constraintVector=zeros(Numcoils,1);
%         constraintIndex=1:Numcoils;  % the coils to be constrained
%         constraintVector(constraintIndex)=1;
%         constraintMatrix=diag(constraintVector);
%         %     constraintMatrix=setConstraintMatrix(constraintMatrix);
%         b=[b;bConstraint];  % constraint condition =b
%         A=[fluxPFPoint(:,3:18);constraintMatrix];
% 
%         weight=[ones(size(Point,2),1); 1.e-4*ones(Numcoils,1)];
%         weight=diag(weight);
%         % weighting the element
%         A=weight*A;
%         b=weight*b;
%     else
%         A=fluxPFPoint(:,3:18);
%         b=b;
%         % power weighting
%         numPoints=length(b);
%         vecIndex=1:numPoints;
%         upperDelIndex=2*min(abs(vecIndex-IY(1)),numPoints-abs(vecIndex-IY(1)))./numPoints;
%         lowerDelIndex=2*min(abs(vecIndex-IY(end)),numPoints-abs(vecIndex-IY(end)))./numPoints;
% %         upperDelIndex=2*min(abs(vecIndex-IY(1)),numPoints-abs(vecIndex-IY(1)))./numPoints;
% %         lowerDelIndex=2*min(abs(vecIndex-IY(end)),numPoints-abs(vecIndex-IY(end)))./numPoints;
%          weight=diag(6.^upperDelIndex+6.^lowerDelIndex);
% %         weight=1;
% 
%         A=weight*A;
%         b=weight*b;
%     end
%%



A=fluxPFPoint(:,index);

%%  
%constraint condition    
if ~isOffsetPF7
        b=[b;0;0];
        constraintVector=zeros(2,length(index));
        index1L= index==8;
        index3L= index==10;
        
        
        %  MP1L=MP3L
        constraintVector(1,index1L)=1;
        constraintVector(1,index3L)=-1;
        
        
        index2L= index==9;
        indexMC= index==11;
        %  MP2L=MC
        constraintVector(2,index2L)=1;
        constraintVector(2,indexMC)=-1;
        A=[A;constraintVector];
end
%%








iRegulate=A\b;
y1=norm(A*iRegulate-b);
disp([ '/norm=' num2str(y1)])

%%
% %     y2=sum(y(:));
%     iPFvec=b'*baseVec;
%     iRegulate=iPFvec';
%%
%     y=norm(A*iRegulate-b);
%     p=[Point;((A*iRegulate-b)./(6.^upperDelIndex+6.^lowerDelIndex)')'];

%%

iPFs=circshift(iPFs,[0 -1]);




iPFs(:,5)=iRegulate';
disp(-iPFs)
iMax=max(abs(iRegulate));

if iMax>1000
%     iRegulate=2000*iRegulate/iMax;
end


iPF=zeros(size(Iex));
%% make sure is feedback not feedforward
iPF(index)=-iRegulate;  

%% voltage calculation
% circuitIndex=1:18;% all coils
% numCircuit=length(circuitIndex);
% 
% Names={'p','0','1U','1L','2U','2L','3U','3L','4U','4L','5U','5L','6U','6L','7U','7L','8U','8L'};
% isSeries=zeros(numCircuit,1); %circuit style for connecting, parallel/series
% [RR,LL,MM]=modifyRM(circuitIndex,isSeries);
% dU=iPF*(diag(LL)+MM+MM');% iPF= dIdt, dt=1ms; V inductance consumption; real matrix calculation  A s mOhmic mH



Iex=Iex+iPF;
dU=zeros(size(iPF));

% flux=fluxPlasmaPoint*j*Ip+fluxPFPoint*reshape(Iex,length(Iex),1);
% % flux=fluxPlasmaPoint*j+fluxPFPoint*reshape(Iex,length(Iex),1);
% b=flux-flux(1);

end

%%



