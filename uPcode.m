%%  DP
clear all


p = mfilename('fullpath');
root2A=which(p);
root2A=root2A(1:end-9); %without separator /


MyPath = which('DP');
pFile='*.p';
mFile='*.m';


pFile=[MyPath(1:end-4) pFile];
mFile=[MyPath(1:end-4) mFile];
pcode(mFile, '-inplace');

% pFile=[MyPath 'uPcode.p'];
% delete(pFile);

%%
MyPath=[MyPath(1:end-4) 'private'];
pFile='*.p';
mFile='*.m';
pFile=[MyPath filesep pFile];
mFile=[MyPath filesep mFile];
pcode(mFile, '-inplace');


%%
%sigbuilder
MyPath=[root2A  filesep 'sigbuilder'];
pFile='*.p';
mFile='*.m';
pFile=[MyPath filesep pFile];
mFile=[MyPath filesep mFile];
pcode(mFile, '-inplace');
%%


MyPath=[root2A filesep 'sigbuilder' filesep 'newfun'];
pFile='*.p';
mFile='*.m';
pFile=[MyPath filesep pFile];
mFile=[MyPath filesep mFile];
pcode(mFile, '-inplace');





msgbox('PCODE OK')
return


%% signalbuilder
clear all
clc


pcode C:\sigbuilder\newfun\sigbuilder.m -inplace
pcode C:\sigbuilder\newfun\sigbuilder_makemenu.m -inplace
pcode C:\sigbuilder\newfun\sigbuilder_beveled_frame.m -inplace
pcode C:\sigbuilder\newfun\sigbuilder_block.m -inplace
pcode C:\sigbuilder\newfun\sigbuilder_tabselector.m -inplace


msgbox('new p file ok')
return
clear all
clc


if  exist('C:\Program Files\MATLAB\R2012a\toolbox\shared\sigbldr\sigbuilder_block.p')==6
    delete('C:\Program Files\MATLAB\R2012a\toolbox\shared\sigbldr\sigbuilder_block.p')
end

pcode sigbuilder_block.m -inplace


msgbox('new p file ok')
return






%function s=updatePcode
%%


%%
clc
if  exist('f:\Program Files\MATLAB\R2007a\toolbox\simulink\simulink\sigbuilder.p')==6
    delete('f:\Program Files\MATLAB\R2007a\toolbox\simulink\simulink\sigbuilder.p')
end
pcode sigbuilder.m -inplace
msgbox('update  sigbuilder OK')
return

clear all
clc
delete('D:\My Documents\MATLAB\DataProc\private\*.p')
%pcode D:\My Documents\MATLAB\DataProc\private\*.m -inplace
msgbox('update  private pfile OK')
return






clear all
clc
delete C:\MATLAB7\work\DataProc\*.p
% pcode C:\MATLAB7\work\DataProc\*.m -inplace
msgbox('update OK')
return


munlock sigbuilder.p
clear all
clc

delete('C:\Program Files\MATLAB\R2007a\toolbox\simulink\simulink\sigbuilder.p')
pcode sigbuilder.m -inplace


msgbox('new p file ok')
return

clear all
clc
delete C:\MATLAB7\work\DataProc\private\*.p
pcode C:\MATLAB7\work\DataProc\private\*.m -inplace
msgbox('update OK')
return

