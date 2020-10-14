function s=register
s='register failed';
PasswordFile=fullfile(getDProot, 'psw.pswl');

fid = fopen(PasswordFile,'r');
encrString= fread(fid, '*char')';
status = fclose(fid);

[~,r]=dos('ipconfig/all');
machineAddressPattern='(?<=\x3A\x20)([0-9A-F][0-9A-F]\x2D){5}[0-9A-F][0-9A-F](?=[^\x2D])';
machineAddress=regexp(r,machineAddressPattern,'match','once');

machineString=[];



% dlg_title = 'authorization';
% prompt = {'input the code number for authorization!','0=hl2a,1=localdas,2=exl50,3=east,4=hl2m'};
% def   = {'','0'};
% num_lines= 1;
% answer  = inputdlg(prompt,dlg_title,num_lines,def);
% if isempty(answer)
%     ShowWarning(0,'no property change',handles)
%     return
% end
% code=answer{1};

defUser='0';
defPsw='';

[machinecode,code]=registerdlg(defUser,defPsw);



%% initial

bigPrime=60491;
keyFirst=29;
% bigPrime=143;
% keyFirst=23;

myString=encrRSA(code,bigPrime,keyFirst);
TF=strcmp(myString,encrString);
if TF
    PasswordFile(end)=[]; 
    if exist(PasswordFile,'file')
        delete(PasswordFile)
    end
    defUser='swip\';
    defPsw='';

    [user,psw]=logindlg(defUser,defPsw);
    
    machineString=[machineString encrRSA(user,bigPrime,keyFirst) char(13) char(10)];
    machineString=[machineString encrRSA(psw,bigPrime,keyFirst) char(13) char(10)];
    
    machineString=[machineString encrRSA(machineAddress,bigPrime,keyFirst) char(13) char(10)];
     
    fid = fopen(PasswordFile,'w');
    fwrite(fid,machineString, 'char');
    status = fclose(fid);
    %% copy the psw to c:, once register, validate forever!
    
    %     dos('runas /noprofile /user:administrator cmd &')
    %     pause(10)
    try
        nPasswordFile=fullfile('c:', 'psw.psw');
        copyfile(PasswordFile,nPasswordFile,'f');
    catch
    end
    s='register OK';
    
    switch machinecode
        case 0
            machine='hl2a';
        case 1
            machine='localdas';
        case 2
            machine='exl50';
        case 3
            machine='east';
        case 4
            machine='hl2m';
    end
    
    
    %% save the machine name to options
    setOptionParameter('machine',machine)
end
return
