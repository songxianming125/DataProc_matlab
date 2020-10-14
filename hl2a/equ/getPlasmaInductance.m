function [M,varargout]=getPlasmaInductance(jPlasma,C,fluxPlasma,fluxPF,Iex,varargin)
[X1,Y1]=getGrid;
M=jPlasma'*fluxPF;  %mutual inductance
Iex=getPFcurrent(6);
delTotalPhi=dot(M,Iex);

Iex=getPFcurrent(3);
delTotalPhi=dot(M,Iex);

Iex=getPFcurrent(4);
delTotalPhi=dot(M,Iex);


% M(2)=(M(1)+M(2))/2;  % plasma inductance
% M(1)=jPlasma'*fluxPlasma*jPlasma;  % plasma inductance


% up down symmetry
jPlasma1=reshape(jPlasma,size(X1));
jPlasma1=(jPlasma1+flipud(jPlasma1))/2;
jPlasma=reshape(jPlasma1,[129*65 1]);


%% H
dX=X1(1,2)-X1(1,1);
dY=Y1(1,1)-Y1(2,1);
indexBoundary=[];
vPhi=C(1,1);
pointNum=C(2,1);
indexBoundaryXY=[];
XY=C(:,2:pointNum+1);
indexBoundaryXY=[indexBoundaryXY XY];

%%
close all
RSV2M(1,0)

for i=1:pointNum
    
    indexB=find(sqrt((X1-XY(1,i)).^2/dX^2+(Y1-XY(2,i)).^2/dY^2)<=0.5);
    if length(indexB)~=1
        db=1;
    else
        indexBoundary=[indexBoundary indexB];
    end
    plot(X1(indexB),Y1(indexB),'+m')
end

indexBoundaryLR=fliplr(indexBoundary);
rUD=(X1(indexBoundaryLR)-X1(indexBoundary)).^2+(Y1(indexBoundaryLR)+Y1(indexBoundary)).^2;
indexAsym=find(rUD);
plot(X1(indexBoundary(indexAsym)),Y1(indexBoundary(indexAsym)),'+b')

indexBoundary1=[];

if pointNum<size(C,2)-1
    XY=C(:,pointNum+3:end);
    pointNum=C(2,pointNum+2);
    
    
    for i=1:pointNum
        
        indexB=find(sqrt((X1-XY(1,i)).^2/dX^2+(Y1-XY(2,i)).^2/dY^2)<=0.5);
        if length(indexB)~=1
            db=1;
        else
            indexBoundary1=[indexBoundary1 indexB];
        end
        plot(X1(indexB),Y1(indexB),'+m')
    end
end
indexBoundaryXY=[indexBoundaryXY XY];

indexBoundaryLR1=fliplr(indexBoundary1);
rUD=(X1(indexBoundaryLR1)-X1(indexBoundary1)).^2+(Y1(indexBoundaryLR1)+Y1(indexBoundary1)).^2;
indexAsym=find(rUD);
plot(X1(indexBoundary1(indexAsym)),Y1(indexBoundary1(indexAsym)),'+b')


indexBoundary=[indexBoundary indexBoundary1];

%%  at accurate boundary 
[fluxPF1,fluxPlasma1]=getFluxCoefAtBoundary(indexBoundaryXY);



%% flux fraction contributed by plasma
fluxInBoundaryByPlasma=fluxPF(indexBoundary,:)*Iex';
%%   

%% find the control current in PF coils
% indexOdd=1:2:17;
% indexEven=2:2:18;
% bConstraint=zeros(18,1);
% bConstraint(indexOdd)=Iex(indexOdd);



% b=[-fluxInBoundaryByPlasma+vPhi;bConstraint];  %constraint condition =b  Icsu=-80e3
b=fluxInBoundaryByPlasma;  %constraint condition =b  Icsu=-80e3
% Imax=[110 110 14.5 14.5 14.5 14.5 14.5 14.5 14.5 14.5 20 20 20 20 40 40 40 40]*1e3;%kA
% constraintMatrix=diag(1./Imax);


% bConstraint(indexOdd)=1;


% constraintMatrix=diag(bConstraint); % 
% constraintMatrix(1,1)=1; % make sure Icsu=-80e3
% indexBoundaryVertical=reshape(indexBoundary,[length(indexBoundary) 1]);

% A=[fluxPF(indexBoundary,:);constraintMatrix];
A=fluxPF(indexBoundary,:);
% AX=b
iPF=A\b;

del1=norm(A*iPF-b);
del2=norm(A*Iex'-b);



dI=iPF'-Iex;
sI=sum(dI);



testFlux1=fluxPlasma*jPlasma*3e6;
testFlux1=reshape(testFlux1,size(X1));
testFlux2=fluxPF*iPF;
testFlux2=reshape(testFlux2,size(X1));


testFlux=testFlux1+testFlux2;
close all
RSV2M(1,0)
v=vPhi+(-5:5)*0.002;
[C,h] = contour(X1,Y1,testFlux,v);%,10);-1e-5 -9e-6 -8e-6-7e-6 -6.8e-6 -6.5e-6                'LineWidth',2,...
clabel(C,h,v)




%% flux fraction contributed by plasma
fluxInBoundaryByPlasma=fluxPlasma1*jPlasma*3e6;
[innerX,indexInner]=min(X1(indexBoundary));
[outerX,indexOuter]=max(X1(indexBoundary));
% delPhi=fluxInBoundaryByPlasma(indexBoundary(indexOuter))-fluxInBoundaryByPlasma(indexBoundary(indexInner));
%%   

%% find the control current in PF coils
indexOdd=1:2:17;
indexEven=2:2:18;
bConstraint=zeros(18,1);
bConstraint(indexOdd)=Iex(indexOdd);
bConstraint(2)=Iex(2);



b=[-fluxInBoundaryByPlasma+vPhi;bConstraint];  %constraint condition =b  Icsu=-80e3
% Imax=[110 110 14.5 14.5 14.5 14.5 14.5 14.5 14.5 14.5 20 20 20 20 40 40 40 40]*1e3;%kA
% constraintMatrix=diag(1./Imax);


bConstraint(indexOdd)=1;
bConstraint(2)=1;

constraintMatrix=diag(bConstraint); % 
% constraintMatrix(1,1)=1; % make sure Icsu=-80e3
% indexBoundaryVertical=reshape(indexBoundary,[length(indexBoundary) 1]);

A=[fluxPF1;constraintMatrix];
% AX=b
iPF=A\b;

del1=norm(A*iPF-b);
del2=norm(A*Iex'-b);



dI=iPF'-Iex;
sI=sum(dI);



testFlux1=fluxPlasma*jPlasma*3e6;
testFlux1=reshape(testFlux1,size(X1));

testFlux2=fluxPF*iPF;
testFlux2=reshape(testFlux2,size(X1));

testFlux=testFlux1+testFlux2;
close all
RSV2M(1,0)
v=vPhi+(-5:5)*0.002;
[C,h] = contour(X1,Y1,testFlux,v);%,10);-1e-5 -9e-6 -8e-6-7e-6 -6.8e-6 -6.5e-6                'LineWidth',2,...
clabel(C,h,v)



%%
    
% plot(X1,Y1,'.b')
pointNum=length(indexBoundary);

delPhi=ones(pointNum,1)*1;  %constraint condition =b
b=[delPhi;zeros(18,1)];  %constraint condition =b
Imax=[110 110 14.5 14.5 14.5 14.5 14.5 14.5 14.5 14.5 20 20 20 20 40 40 40 40]*1e3;%kA
constraintMatrix=diag(1./Imax);
constraintMatrix(2,1:2)=[1 -1]; % make sure Icsu=Icsl
A=[fluxPF(indexBoundary,:);constraintMatrix];
% AX=b


% delI=fluxPF(indexBoundary,:)\delPhi;
delI=A\b;


delFlux=fluxPF*delI;
delPhi1=delFlux(indexBoundary);
delPercent=(delPhi-delPhi1)./delPhi;
[delBoundary,indexMax]=max(abs(delPercent));
plot(X1(indexBoundary(indexMax)),Y1(indexBoundary(indexMax)),'dr')


indexInside=find(jPlasma>0);
delPhi1=delFlux(indexInside);
delPercent=(delPhi(1)-delPhi1)./delPhi(1);
[delInside,indexMaxInside]=max(abs(delPercent));
plot(X1(indexInside(indexMaxInside)),Y1(indexInside(indexMaxInside)),'om')


% delPhi2=dot(M,delI);

varargout{1}=iPF;




%  save('C:\2w\delIex','delI')

% isoFlux=reshape(delFlux,size(X1));
% v=[0.999 0.99 1 1.01 1.001]
% [C,h] = contour(X1,Y1,isoFlux,v);%,10);-1e-5 -9e-6 -8e-6-7e-6 -6.8e-6 -6.5e-6                'LineWidth',2,...
% colorbar
% clabel(C,h,v)
% index=intersect(index,index1);
% 
% 
% 
% [XCenter,YCenter,W,H,NX,NY,N,R,L,S,Imax,C, Labels]=GetPFParameter;
% index1=find(sqrt((X1-XCenter(15)).^2+(Y1-YCenter(15)).^2/1.5)>0.45);
% index=intersect(index,index1);
% 

return

