function [chi2,chi3,Xb,Yb]=getFieldNullConf(ap,Xp,Yp,elong)
%%
%       This program get the PF configuration for field Null                  
%       Developed by Song xianming 2013.11.22 
%
% input description
% C contour data

%%  at accurate boundary 
Numcoils=18;

pointNum=100;
% [Ip,ap1,Xp1,Yp1,elong1,tri,betap,li,alphaIndex]=getPlasma0D;
[Xb,Yb]=getClosedBoundary(Xp,Yp,ap,elong,pointNum);

fieldNullXY=[];
fieldNullXY(1,:)=Xb;
fieldNullXY(2,:)=Yb;


fluxPF1=getPFfluxAtBoundary(fieldNullXY);
% fluxPF1(:,3:10)=0; %turn off coils PF1, PF2, PF3
%  plot(X1,Y1,'.b')
% plot(X1(indexBoundary),Y1(indexBoundary),'+m')
pointNum=length(fieldNullXY);
% calculate the flux consumption needed
delPhi=1;  % inductance and resistance consumption
delPhi=ones(pointNum,1)*delPhi;  % constraint condition =b
bConstraint=[];
b=[delPhi;bConstraint];  % constraint condition =b
constraintMatrix=[];
% constraintMatrix(2,1:2)=[1 -1]; % make sure Icsu=Icsl
A=[fluxPF1;constraintMatrix];
% AX=b
iPF=A\b;
 save('C:\2w\equ\fieldNullConf','iPF','Xp','Yp','ap','elong')
chi2=norm(A*iPF-b);




bConstraint=zeros(Numcoils,1);
% Imax=[110 110 14.5 14.5 14.5 14.5 14.5 14.5 14.5 14.5 10 10 10 10 40 40 40 40]*1e3;% used as weight
% Imax=[110 110 14.5 14.5 14.5 14.5 14.5 14.5 14.5 14.5 40 40 40 40 40 40 40 40]*1e3;% used as weight
% weight=ones(Numcoils,1);% used as weight
% weight=1./weight;
% 
% bConstraint=bConstraint.*weight;
% constraintVector1=1./Imax.*weight';

constraintVector=zeros(Numcoils,1);
constraintIndex=3:10;  % the coils to be constrained
constraintVector(constraintIndex)=1;
constraintMatrix=diag(constraintVector);
constraintMatrix(2,1)=-1;
constraintMatrix(2,2)=1;

% constraintMatrix(3,1)=-1/12;
% constraintMatrix(4,1)=-1/12;
% constraintMatrix(5,1)=-1/10;
% constraintMatrix(6,1)=-1/10;
% constraintMatrix(7,1)=-1/9.6;
% constraintMatrix(8,1)=-1/9.6;
% constraintMatrix(9,1)=-1/9.2;
% constraintMatrix(10,1)=-1/9.2;

constraintMatrix(3,1)=-1/12.5;
constraintMatrix(4,1)=-1/12.5;
constraintMatrix(5,1)=-1/10;
constraintMatrix(6,1)=-1/10;
constraintMatrix(7,1)=-1/9.6;
constraintMatrix(8,1)=-1/9.6;
constraintMatrix(9,1)=-1/9.0;
constraintMatrix(10,1)=-1/9.0;

constraintMatrix(12,11)=-1;
constraintMatrix(12,12)=1;
constraintMatrix(14,13)=-1;
constraintMatrix(14,14)=1;
constraintMatrix(16,15)=-1;
constraintMatrix(16,16)=1;
constraintMatrix(18,17)=-1;
constraintMatrix(18,18)=1;


b=[delPhi;bConstraint];  % constraint condition =b
A=[fluxPF1;constraintMatrix];
iPF1=A\b;
fileName=[num2str(Xp) '_' num2str(ap) '_' num2str(elong)];
fileName=strrep(fileName,'.','d');


save(['C:\2w\equ\fieldNullConf' fileName],'iPF1','Xp','Yp','ap','elong')
chi3=norm(A*iPF-b);

return

