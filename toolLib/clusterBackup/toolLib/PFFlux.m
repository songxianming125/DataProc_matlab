function Flux=PFFlux(varargin)
%%%********************************************************%%%
%%%       This program is to calculate                     %%%
%%%    the Magnetic flux of PF coils and draw the quiver  %%%
%%%      Developed by Song xianming 2008/08/15/            %%%
%%%********************************************************%%%
%%%********************************************************%%%
%%%********************************************************%%%
%%%********************************************************%%%
global debugPosition
global Numcoils %PF coil number in total
global FilledType %control the filling style
%current in PF coils
global Iex 
%field area
global X1 Y1
        repStr=regexp(debugPosition, '^\w*', 'match'); 
        debugPosition=regexprep(debugPosition, repStr, 'PFFlux');       %output 
        repStr=regexp(debugPosition, '\w*$', 'match'); 
        debugPosition=regexprep(debugPosition, repStr, '21');       %output 



FilledType=zeros(1,Numcoils);
Flux=0;
PFindex=[];


for i=1:nargin
    index=varargin{i};
    FilledType(index)=sign(Iex(index));%control the filling style
    PFindex=[PFindex num2str(index) ','];
    
    [X2,Y2,ATurnCoil]=getLocation(index);
    Flux=Flux+Iex(index).*MMutInductance(X1,Y1,X2,Y2,ATurnCoil);
end




%%
% vmin=min(Flux(:));
% vmax=max(Flux(:));
% v=85:95;
% v=(vmin+(vmax-vmin)/100.*v);
% v=[v vmax/2];
%  v=[1 2 3 4 5 10 20 50 100];
 v=[5 10 20 30 50 100];
%%

%%
% v=4:0.05:7;
% v=v*10000;
%%
% 
% v=[4 5 6 7 8];
% v=0.97+[-100:100]*1e-4;
% v=1.233+[-100:100]*1e-4;
% [C,h] = contour(X1,Y1,Flux,10);
[C,h] = contour(X1,Y1,Flux,v);
clabel(C,h,v) 
% clabel(C,h) 
colorbar;
% 
%  title('The flux in Web')
%pause
%delete(gcf) 
