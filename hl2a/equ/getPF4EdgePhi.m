function [dI,varargout]=getPF4EdgePhi(jPlasma,C,iCS,varargin)
%%
%       This program calculated the PF current variation by Ramping Up Plasma                 
%       Developed by Song xianming 2013.11.16 
%
% input description
% C contour data
% jPlasma plasam current density


% CS current is given, find the PF current except CS


Numcoils=18;

%%  at accurate boundary 
[indexBoundary,indexBoundaryXY]=getBoundaryByC(C);

fluxPlasma1=getappdata(0,'fluxPlasma1');
fluxPF1=getappdata(0,'fluxPF1');
% load('fluxPlasmaCSN','fluxPlasma1')
% load('fluxPFCSN','fluxPF1')
% load('fluxPlasmaC','fluxPlasma1')
% load('fluxPFC','fluxPF1')

if isempty(fluxPlasma1)
    [fluxPF1,fluxPlasma1]=getFluxCoefAtBoundary(indexBoundaryXY);
%     save('fluxPlasmaC','fluxPlasma1')
%     save('fluxPFC','fluxPF1')
    save('fluxPlasmaCSN','fluxPlasma1')
    save('fluxPFCSN','fluxPF1')
    setappdata(0,'fluxPlasma1',fluxPlasma1)
    setappdata(0,'fluxPF1',fluxPF1)
end



%% flux fraction contributed by plasma
fluxInBoundaryByPlasma=fluxPlasma1*jPlasma; %1A flux
fluxInBoundaryByCS=fluxPF1(:,1:2)*[iCS;iCS]; %1A flux


    %% find the control current in PF coils
%     bConstraint=zeros(Numcoils,1); %no constraint for PF5-8
%     b=[-fluxInBoundaryByPlasma-fluxInBoundaryByCS;bConstraint(1:Numcoils-8)];  %flux by PF(1-8) cancel the flux by Plasma +CS
%     constraintIndex=3:10;  % the coils to be constrained
    
    b=-fluxInBoundaryByPlasma-fluxInBoundaryByCS;  %flux by PF(1-8) cancel the flux by Plasma +CS; no constraint
    
%     bConstraint(constraintIndex)=1;
%     constraintMatrix=diag(bConstraint);
%     constraintMatrix=setConstraintMatrixSN(constraintMatrix,1);
%     A=[fluxPF1;constraintMatrix(1:Numcoils-8,:)];
    A=fluxPF1(:,3:18);  %no constraint


    % AX=b
    dI=A\b;
    chi2=norm(A*dI-b);
    
%% output
if nargout==2
    varargout{1}=chi2;
end
%%
return

