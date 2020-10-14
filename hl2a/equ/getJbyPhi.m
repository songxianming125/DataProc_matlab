function jPlasma=getJbyPhi(M,X1,Y1,Xp,betap,alphaIndex)
%find the X point in a small area
[m1,n1]=size(M);

N=M(1:fix(m1/2),1:fix(n1/2));

[V1,I1] = min(N,[],1);
[V2,I2] = max(N,[],2);
[v1,i1] = max(V1);
[v2,i2] = min(V2);

Z=Y1(I1(i1),i1);
plot(X1(I1(i1),i1),Z,'.r')  % X point

 if v1==v2
  [C,h] = contour(X1,Y1,M,v1);%,10);-1e-5 -9e-6 -8e-6-7e-6 -6.8e-6 -6.5e-6                'LineWidth',2,...
 else
     iii=0;
 end



%% calculate the current density

phiCenter=max(V2);
phiBoundary=v1;
delPhi=phiCenter-phiBoundary; %

M=(M-v1)/delPhi;  %modify flux

index=find(M>0);
index1=find(abs(Y1)<Z);
index=intersect(index,index1);


jPlasma=zeros(size(M));
jPlasma(index)=(betap.*X1(index)./Xp+(1-betap).*Xp./X1(index)).*(M(index)).^alphaIndex;
totalJ=sum(jPlasma(:));
jPlasma=jPlasma/totalJ;
jPlasma=reshape(jPlasma,numel(jPlasma),1);%

return

%% draw jPlasma

sourceLen=numel(index);
X2=reshape(X1(index),1,sourceLen);%
Y2=reshape(Y1(index),1,sourceLen);%
jPlasma4Draw=reshape(jPlasma(index),sourceLen,1);%

factor=jPlasma4Draw/max(jPlasma4Draw(:));
factorthree=[factor factor/2 1-factor];
mycolor=mat2cell(factorthree,[linspace(1,1,sourceLen)],[3]);

% draw the same number vertical line
XX=[X2;X2];
YY=[Y2;Y2+0.0001];


h=plot(XX,YY,'.','LineWidth',1); %plasma
set(h,{'Color'},mycolor)
%  

