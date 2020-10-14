function [i1,x1] = jround(xe,x)
% function [i1,x1] = jround(xe,x)
% Generalisation de iround :
%    - x et xe peuvent ne pas etre monotones
%    - xe peut contenir des doublons
%

Ne        = length(xe);

x1        = NaN * ones(size(x));
i1        = NaN * ones(size(x));

[xeu,ieu] = unique(xe);

xmn       = min(x);
xmx       = max(x);

msk_inf   = x >= min(xe);
msk_sup   = x <= max(xe);
msk       = msk_inf & msk_sup;

if ~isempty(find(~msk))

   ind_inf = find(~msk_inf);
   
   if ~isempty(ind_inf)
   
      i1(ind_inf) = ones(size(ind_inf));
   
   end
   
   ind_sup = find(~msk_sup);
   
   if ~isempty(ind_sup)
   
      i1(ind_sup) = Ne * ones(size(ind_sup));
   
   end
   
end

ind          = find(msk);

if length(xeu) > 1

   inum      = ind(find(~isnan(x(ind))));
   [xs,is]   = sort(x(inum));
%
%  interp1 trop lent   
%
   k         = ieu(interp1(xeu,[1:length(xeu)],xs,'nearest'));
   %k         = ieu(iround(xeu,xs));
%
%
%
%   x1_(is)   = xe(k);
   i1_(is)   = k;
%   x1(inum)  = x1_;
   i1(inum)  = i1_;

elseif length(xeu) > 0

   inum      = ind(find(~isnan(x(ind))));
   i1        = find(x(inum) == xeu);
%   x1(inum)  = x(inum(i1));
           
end

x1           = xe(i1);
