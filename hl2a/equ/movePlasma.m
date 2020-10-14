function Iex=movePlasma(Iex,varargin)
if nargin>1
    i=varargin{1};
end
load('iPFenlongation','iPF')
Iex=Iex+0.5*iPF';
return

i=-1000;

% Iex(15:16)=Iex(15:16)+1.2*i;
Iex(17:18)=Iex(17:18)+1.2*i;

%  vertical move
% 
% Iex(11)=Iex(11)-1.2*i;
% Iex(12)=Iex(12)+1.2*i;






return



%  vertical move
Iex(13)=Iex(13)-1.2*i;
Iex(14)=Iex(14)+1.2*i;






return


Iex(15)=Iex(15)-1.2*i;
Iex(16)=Iex(16)+1.2*i;
return
%PF4 decrease
Iex(9:10)=Iex(9:10)+1*i;

%PF5 PF6 decrease

Iex(11:12)=Iex(11:12)+4*i;
Iex(13:14)=Iex(13:14)+4*i;

%PF7 PF8 increase

Iex(15:16)=Iex(15:16)+1.2*i;
Iex(17:18)=Iex(17:18)+1.2*i;
