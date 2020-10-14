clear all

MyPath = which('DP');
pFile='*.p';
pFile=[MyPath(1:end-4) pFile];
delete(pFile);



MyPath=[MyPath(1:end-4) 'private'];
pFile='*.p';
pFile=[MyPath filesep pFile];
delete(pFile);
msgbox('PCODE delete successful')
return


