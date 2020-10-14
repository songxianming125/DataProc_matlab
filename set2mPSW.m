function y=set2mPSW(varargin)
y=1;

if nargin>0
    fileName=varargin{1};
else
    fileName='psw2m.psw';
end
bigPrime=60491;
keyFirst=29;
keySecond=2069;

%%  generate the psw information
% input the psw information
defUser='';
defPsw='';

[user,psw]=logindlg(defUser,defPsw);
machineString=[];
machineString=[machineString encrRSA(user,bigPrime,keyFirst) char(13) char(10)];
machineString=[machineString encrRSA(psw,bigPrime,keyFirst) char(13) char(10)];




% the build the file to store the psw information
cw=cd;
PasswordFile=fullfile(cw, ['\' fileName]);

% save psw information
fid = fopen(PasswordFile,'w');
fwrite(fid,machineString, 'char');
status = fclose(fid);
y=0;
return
