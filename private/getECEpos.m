function [ r,varargout ] = getECEpos( Bt,varargin)


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



R0=1.65;%center of vacuum vessel

for ib=1:length(Bt)
    Bt_mean=Bt(ib);
if nargin>1
    ff=varargin{1};
else 
    ff=[];
end
if Bt_mean>=2%高场（2.4T）时用的本振源110GHz，低场（1.3T）时用的本振源73GHz
    f_lo=110;
else
    f_lo=73;
end

F= f_lo+(1:16)*1.5;%每道的中心频率 GHz

r(ib,:)=100*((F.^-1)*56*Bt_mean*R0-R0);
if ~isempty(ff)
    varargout{1}=((ff.^-1)*56*Bt_mean*R0-R0)*100;
else
            if nargout==2
                varargout{1}='NaN';
            end
end


end

end

