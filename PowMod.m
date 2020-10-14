
function r=PowMod(a,p,n)
%%
%p>2
    r=MulMod(a,a,n);

for i=1:p-2
    r=MulMod(r,a,n);
end

function r=MulMod(a,b,n)
%%
r=mod(a*b,n);
%%
return

