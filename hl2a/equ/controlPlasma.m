function Iex=controlPlasma(Iex,j,Point)
global Ip
% 16 points close to 16 PF coils
fluxPlasmaPoint=getappdata(0,'fluxPlasmaPoint');
fluxPFPoint=getappdata(0,'fluxPFPoint');
if isempty(fluxPFPoint) || size(Point,2)~=size(fluxPFPoint,1) % point is the same
    [fluxPFPoint,fluxPlasmaPoint]=getFluxCoefAtBoundary(Point);
    setappdata(0,'fluxPlasmaPoint',fluxPlasmaPoint)
    setappdata(0,'fluxPFPoint',fluxPFPoint)
end



flux=fluxPlasmaPoint*j*Ip+fluxPFPoint*reshape(Iex,length(Iex),1);
% flux=fluxPlasmaPoint*j+fluxPFPoint*reshape(Iex,length(Iex),1);
b=flux-flux(1);
A=fluxPFPoint(:,3:18);
iPF16=A\b;
y=norm(A*iPF16-b);
Iex=Iex-[0 0 iPF16']*0.3;



