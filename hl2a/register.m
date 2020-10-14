function s=register
s='register failed';
MyPath= which('EF');
PasswordFile=fullfile(MyPath(1:end-4), 'psw.pswl');

fid = fopen(PasswordFile,'r');
encrString= fread(fid, '*char')';
status = fclose(fid);

[~,r]=dos('ipconfig/all');
machineAddressPattern=['(?<=\x3A\x20)([0-9A-F][0-9A-F]\x2D){5}[0-9A-F][0-9A-F](?=[^\x2D])'];
machineAddress=regexp(r,machineAddressPattern,'match');

machineString=[];
defUser='input code below';
defPsw='';
[~,code]=logindlg(defUser,defPsw);

myString=encrRSA(code,143,23);
TF=strcmp(myString,encrString);
if TF
    PasswordFile(end)=[]; 
    if exist(PasswordFile,'file')
        delete(PasswordFile)
    end
    defUser='swip\';
    defPsw='';

    [user,psw]=logindlg(defUser,defPsw);
    
    machineString=[machineString encrRSA(user,143,23) char(13) char(10)];
    machineString=[machineString encrRSA(psw,143,23) char(13) char(10)];
    for i=1:length(machineAddress)
        machineString=[machineString encrRSA(machineAddress{i},143,23) char(13) char(10)];
    end
    
     
    fid = fopen(PasswordFile,'w');
    fwrite(fid,machineString, 'char');
    status = fclose(fid);
%     nPasswordFile=fullfile('d:', 'psw.psw');
%     copyfile(PasswordFile,nPasswordFile,'f');
    s='register OK';
end
return
