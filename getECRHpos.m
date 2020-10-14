function [R,varargout ] = getECRHpos( Bt,varargin)


%Developed by Huang Xianli,modified by Song Xianming
%   Calculating the radial resonance positions of MECE for a specific toroidal filed

%[r,rr]=rpos(Bt,ff);
%
%
% input
% option  VarName             DataType           Meaning
% 1      r:                     double array           position (cm)
% 0      rr:                    double array         additional position(cm)
% cm
%
% option=1 means the item is necessary, option=0 means the item is optional
% output:
% option    VarName             DataType        Meaning
% 1         Bt                  double          magnetic field (T)
% 0         ff                  double          frequency (GHz)



R0=1.65;% meter ;center of vacuum vessel
fECRH=68; %GHz
B0=2.45; %Tesla

if nargin>1
    ff=varargin{1};
else 
    ff=68; %ECRH frequency GHz
end


if Bt>2
    R=R0*Bt/B0*fECRH/ff; % O1 mode
else
    R=R0*Bt*2/B0*fECRH/ff; % X2 mode
end



if nargout==2
    varargout{1}=R-R0;
end




end