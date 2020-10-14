function M=setMM2A(varargin)
%% 

global  dataPath
p = mfilename('fullpath');
k = strfind(p, filesep);
p=p(1:k(end)-1);
fileName='MM2A.mat';
pf = fullfile(p, fileName);

Numcoils=11;  % 2A
M=zeros(Numcoils,Numcoils);




%% for PF coils
for j=1:Numcoils
    for i=j:Numcoils
        M(i,j)=getML2A(i,j);
    end
end

L=diag(M);
M=M+(M-diag(L))';

save(pf,'M')
return
