function [baseVec,varargout]=getBaseVec(fluxPFPoint,varargin)
%% find the base vector for position and shape control of plasma
numPoint=size(fluxPFPoint,1);
A=fluxPFPoint(:,3:18);
baseVec=zeros(numPoint,16);
y=zeros(numPoint,1);

for i=1:numPoint
    b=zeros(numPoint,1);
    b(i,1)=1;
    baseVec(i,:)=A\b;
    y(i,1)=norm(A*(baseVec(i,:))'-b);
end
if nargout>1
    varargout{1}=y;
end
