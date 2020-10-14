function [dIex,varargout]=i2iEvolution(Iex,Ip,dIp,dt,Rp,L,fluxPF,C,varargin)
%%
%       This program calculated the PF current evolution                  
%       Developed by Song xianming 2013.11.16 
%
% input description
% i2i means from plasma current to PF current
% L plasma self inductance
% C contour data
% jPlasma plasam current density




% load('Flux4Plasma8','fluxPlasma')
% load('Flux4PF8','fluxPF')

[X1,Y1]=getGrid;



%%  find the boundary
[indexBoundary,fieldNullXY]=getBoundaryByC(C);

    
%  plot(X1,Y1,'.b')
% plot(X1(indexBoundary),Y1(indexBoundary),'+m')
pointNum=length(indexBoundary);
% calculate the flux consumption needed

% L=jPlasma'*fluxPlasma*jPlasma;  % plasma self inductance
delPhi=L*dIp+Rp*Ip*dt;  % inductance and resistance consumption
delPhi=-ones(pointNum,1)*delPhi;  % constraint condition =b
b=[delPhi;zeros(18,1)];  % constraint condition =b

% Imax=[110 110 14.5 14.5 14.5 14.5 14.5 14.5 14.5 14.5 40 40 40 40 40 40 40 40]*1e3;% delta I weight
Imax=[110 110 14.5 14.5 14.5 14.5 14.5 14.5 14.5 14.5 10 10 10 10 40 40 40 40]*1e3;% delta I weight
constraintMatrix=diag(1./Imax);
% constraintMatrix(2,1:2)=[1 -1]; % make sure Icsu=Icsl
A=[fluxPF(indexBoundary,:);constraintMatrix];
% AX=b


% delI=fluxPF(indexBoundary,:)\delPhi;
dIex=A\b;
% dIex(2:2:18)=dIex(1:2:17);




% delFlux=fluxPF*dIex;
% delPhi1=delFlux(indexBoundary);
% delPercent=(delPhi-delPhi1)./delPhi;
% [delBoundary,indexMax]=max(abs(delPercent));
% plot(X1(indexBoundary(indexMax)),Y1(indexBoundary(indexMax)),'dr')
% 
% 
% indexInside=find(jPlasma>0);
% delPhi1=delFlux(indexInside);
% delPercent=(delPhi(1)-delPhi1)./delPhi(1);
% [delInside,indexMaxInside]=max(abs(delPercent));
% plot(X1(indexInside(indexMaxInside)),Y1(indexInside(indexMaxInside)),'om')
% delPhi2=dot(M,dIex);

varargout{1}=dIex;
% save('C:\2w\delIex','dIex')

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

