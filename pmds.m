function  pmds
rootPath=getDProot;
cd(rootPath)
addpath(rootPath)
if ismac
    mdsPath=[rootPath filesep 'Mdsplus_mac'];
elseif ispc
    mdsPath=[rootPath filesep 'Mdsplus_win8_64bit'];
end
addpath(mdsPath)
end

