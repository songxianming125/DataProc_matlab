function myRSAString=decrRSA(yourRSAData,n,e)
%%
% prime table: 
% p=[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113];
%p=primes(120);
% 11,13,143,13,37,23,47
%%

myData=str2num(yourRSAData);
myLen=length(myData);
% f=getPhi(n);
% p=getPartner(e,f);


for i=1:myLen
    myData(i)=PowMod(myData(i),e,n);
end
myRSAString=char(myData);

return



function r=MulMod(a,b,n)
%%
r=mod(a*b,n);
%%
return



function r=PowMod(a,p,n)
%%
%p>2
    r=MulMod(a,a,n);

for i=1:p-2
    r=MulMod(r,a,n);
end
%%
return

