clear all



MyPath = which('DP');
pFile='*.p';
mFile='*.m';


pFile=[MyPath(1:end-4) pFile];
mFile=[MyPath(1:end-4) mFile];


dir_struct = dir(pFile);
n=length(dir_struct);
if n>10
    delete(mFile);
end


%%
MyPath=[MyPath(1:end-4) 'private'];
pFile='*.p';
mFile='*.m';
pFile=[MyPath filesep pFile];
mFile=[MyPath filesep mFile];

dir_struct = dir(pFile);
n=length(dir_struct);
if n>10
    delete(mFile);
end


msgbox('MCODE delete successful')
return
