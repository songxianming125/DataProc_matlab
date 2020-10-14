function [user, psw]=get2mPSW(varargin)


if nargin>0
    fileName=varargin{1};
else
    fileName='psw2m.psw';
end


bigPrime=60491;
keyFirst=29;
keySecond=2069;
% bigPrime=143;
% keyFirst=23;
% keySecond=23;




% the build the file to store the psw information

cw=which('DP');
cw=cw(1:end-5);
PasswordFile=fullfile(cw, ['\' fileName]);


iExistFile=exist(PasswordFile,'file');



fid = fopen(PasswordFile,'r');
remain = fread(fid, '*char')';
status = fclose(fid);

[user, psw] = strtok(remain, [char(13) char(10)]);
[psw, remain1] = strtok(psw, [char(13) char(10)]);
user=decrRSA(user,bigPrime,keySecond);
% domain adding
user=['swip\' user];
psw=decrRSA(psw,bigPrime,keySecond);




