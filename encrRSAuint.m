function myRSAData=encrRSAuint(yourRSAString,n,e)
%%
% prime table: 
% p=[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113];
%p=primes(120);
%n= 143(11*13),(13,37),(23,47)


% n=11*31=341 f=10*30=300
% (7,43) (17,53) (19,79) (37,73)




%% big prime
% less than 256, the top 3 primes=[239 241 251] n=239*241=57599, f=238*240=, e=251
% its parter=19571
%(251,19571), (19,9019),(11,20771) (23,4967) (29,5909),(31,22111) (191,15551)



% less than 256, the top 3 primes=[239 241 251] n=251*241=60491, f=250*240=60000

%(7,17143), (13,23077),(23,26087), (29,2069)





% less than 300 top three 281   283   293   n=251*271=68021 f=250*270=67500
% (17,19853) (37,5473) (7,9643)


%%
myLen=length(yourRSAString);
myData=double(yourRSAString);
% f=getPhi(n);
% p=getPartner(e,f);
for i=1:myLen
    myData(i)=PowMod(myData(i),e,n);
end
% myRSAData=num2str(myData);
myRSAData=myData;
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



function r=getPartner(e,f)
%%
r=0;
[G,C,D] = gcd(e,f);
if G==1
    r=C;
end

%%
return

function f=getPhi(n)
%%
%Euler function Phi
if n==143
    p1=11;
    p2=13;
    f=(p1-1)*(p2-1);
end
%%
return
