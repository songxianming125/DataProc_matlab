function [user, psw]=getPSW
%#codegen
coder.extrinsic('fullfile','exist','fopen','fread','fclose','which','dos','regexp','strtok','disp','setappdata','msgbox');
%%
% This is the code for registering your account
%
%%
coder.varsize('user', [1, 600], [0 1])
coder.varsize('psw', [1, 600], [0 1])
user='*';
psw='*';

bigPrime=60491;
keyFirst=29;
keySecond=2069;
% bigPrime=143;
% keyFirst=23;
% keySecond=23;

%%
PasswordFile='C:\psw.psw';
if exist(PasswordFile,'file')~=2
    PasswordFile=fullfile(getDProot, 'psw.psw');
end

iExistFile=exist(PasswordFile,'file');
if iExistFile==2
    fid = fopen(PasswordFile,'r');
    remain = fread(fid, '*char')';
    fclose(fid);
else
    warnstr='NO PASSWORD, ONLY local file can be read!';
    setappdata(0,'MyErr',warnstr);
    disp(warnstr)
    msgbox('Please use the licensed DP! register Now!','Internet is OK?','error');
    return
end
%%
[~,r]=dos('ipconfig/all');


% test internet link
machineAddressPattern='255.255';
machineAddress=regexp(r,machineAddressPattern,'match','once');
if isempty(machineAddress)
    disp('no internet connect, local is ok!')
    return
end


% check the machine address only first one
machineAddressPattern='(?<=\x3A\x20)([0-9A-F][0-9A-F]\x2D){5}[0-9A-F][0-9A-F](?=[^\x2D])';
machineAddress=regexp(r,machineAddressPattern,'match','once');

% machineAddress=regexp(r,machineAddressPattern,'match','once');

%%
[user, psw] = strtok(remain, [char(13) char(10)]);
[psw, ~] = strtok(psw, [char(13) char(10)]);


%%
%RSA decryption

localAddress=regexp(remain,encrRSA(machineAddress,bigPrime,keyFirst),'start','once');

if 1 % ~isempty(localAddress)
    user=decrRSA(user,bigPrime,keySecond);
    psw=decrRSA(psw,bigPrime,keySecond);
else   
    user=[];
    psw=[];
    msgbox('no register !','Internet is OK?','error');
end

