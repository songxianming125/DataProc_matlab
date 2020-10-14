function [y,iPF]=enlongation(C,dPhi1,dPhi2)
%%
%       This program get the PF configuration for enlongation                  
%       Developed by Song xianming 2013.11.22 
%
% input description
% C contour data

%%  at accurate boundary 
Numcoils=18;
setY=[1 0.8 -0.8 -1];

[~,fieldNullXY]=getBoundaryByC(C);
X=fieldNullXY(1,:);
Y=fieldNullXY(2,:);



% draw the same number vertical line
XX=[X;X];
YY=[Y;Y+0.0001];


h=plot(XX,YY,'.','LineWidth',1); %plasma

[Ymax,indexMax] =max(Y);
Xmax=X(indexMax);
Xmax=Xmax(1);
YL=Y(X<Xmax);
XL=X(X<Xmax);

YL=Y(X<Xmax);
XL=X(X<Xmax);
YR=Y(X>Xmax);
XR=X(X>Xmax);

for i=1:length(setY)
   [dY,index] =min(abs(YL-setY(i)))
   PL(1:2,i)=[XL(index);YL(index)];
   [dY,index] =min(abs(YR-setY(i)))
   PR(1:2,i)=[XR(index);YR(index)];

end

Point=[PL PR];


fluxPF3=getappdata(0,'fluxPF3');

if isempty(fluxPF3)
    fluxPF3=getPFfluxAtBoundary(Point);
    setappdata(0,'fluxPF3',fluxPF3)
    save('enlongation','fluxPF3')
end

b=[-0.02 -0.01 0.01 0.02 -0.02 -0.01 0.01 0.02]';
A=fluxPF3;
iPF=A\b;
y=norm(A*iPF-b);
save('iPFenlongation','iPF')

return

