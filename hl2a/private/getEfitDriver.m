function sxDriver=getEfitDriver
%%
% This is the code for registering your account 
%
%%

%%
global  efitServer isVIP
sxDriver=[];
isVIP=0;
if ispc
    efitServer='\\192.168.10.181\exp';% 
    if exist(efitServer,'dir')~=7
        %%
                [user, psw]=getPSW;
                myUserPwd=strcat('net use',char(31),efitServer,char(31),psw,char(31), '/user:',user);
                myUserPwd=strrep(myUserPwd,char(31),char(32));
                [s,r]=dos(myUserPwd);
                if s
                    efitServer='c:\das';
                    sxDriver=efitServer;
                    msgbox('database not ready, only local file')
                    return
                end

                if strmatch(user,'swip\songxm','exact')
                    isVIP=1;
                else
                    isVIP=0;
                end
                sxDriver=efitServer;%try one server
        if isempty(sxDriver)
            h = msgbox('Please use the licensed DP!','Internet is OK?','error');
        end
    else
        sxDriver=efitServer;%try one server
    end %if exist(efitServer,'dir')~=7
%%
elseif isunix
    efitServer='/hl/2adas';
    sxDriver=efitServer;
    [s,r]=unix('whoami');
    if strmatch(r,'songxm')
        isVIP=1;
    else
        isVIP=0;
    end
elseif ismac
% ��һ�ַ���: ʹ��mount
%   װ��:
%     ��һ��: ����һ����Ŀ¼, ��Ϊװ�ؽڵ�.
%     Ŀ¼������, Ŀ¼�洢λ������.
%     ����:
%         mkdir /Volumes/UDE-Mac
%        
%     �ڶ���: ��Զ�̹���Ŀ¼װ�ص���Ŀ¼��.
%     mount -t smbfs //username:password@hos_tname/share_folder
%     host_name : ������������, Ҳ������IP��ַ.
%     -t smbfs : ָ��װ�ص��ļ�ϵͳ����.
%     ��������������пո�, �� ����.
%     ����:
%         mount -t smbfs //guest:@192.168.0.132/UDE-Mac /Volumes/UDE-Mac
%         �� 192.168.0.132�ϵĹ���Ŀ¼ UDE-Mac, װ�ص�����/Volumes/UDE-MacĿ¼��. ʹ��guest�˻�, ����Ϊ��.
%        
%   ж��:
%     umount mounted_folder
%     ����:
%         umount /Volumes/UDE-Mac
%         ��������Զ�ɾ��/Volumes/UDE-MacĿ¼.
% �ڶ��ַ���: ʹ�� mount_smbfs
%   �͵�һ�ַ���������ͬ, ֻ���� mount_smbfs ������ mount -t smbfs
%   װ��:
%     mkdir /Volumes/UDE-Mac
%     mount_smbfs //guest:@192.168.0.132/UDE-Mac /Volumes/UDE-Mac
%   ж��:
%     umount /Volumes/UDE-Mac
%    
% �����ַ���: ʹ��action script
%   װ��:
%     tell application "Finder"
%         open location "smb://guest:@192.168.0.132/UDE-Mac"
%     end tell
%  
%   ж��:
%     tell application "Finder"
%         eject (every disk whose name is "UDE-Mac")
%     end tell

%%
%first link as '/Volumes/2adas' in finder
% efitServer='/Volumes/2adas';
% sxDriver=efitServer;%try one server

end
%%


