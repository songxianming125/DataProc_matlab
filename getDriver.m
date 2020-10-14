function sxDriver=getDriver
%%
% This is the code for registering your account 
% 2019.12.6 modified
% no WINS service is needed.  all \\hl is replaced by \\192. automatically
global  newServer isVIP
newServer=getappdata(0,'newServer');
if isempty(newServer)
    machine=getOptionParameter('machine');
    changeDriver(machine);   
end
sxDriver=newServer;
isVIP=0;
if ispc
    if exist(newServer,'dir')~=7
        %%
                [user, psw]=getPSW;
                myUserPwd=strcat('net use',char(31),newServer,char(31),psw,char(31), '/user:',user);
                myUserPwd=strrep(myUserPwd,char(31),char(32));
                [s,r]=dos(myUserPwd);
                if s
                    newServer='c:\das';
                    sxDriver=newServer;
                    msgbox('internet? /or license?','not ready!','error');
                    return
                end

                if strcmp(user,'swip\songxm')
                    isVIP=1;
                else
                    isVIP=0;
                end
                sxDriver=newServer;%try one server
    else
%         [user, psw]=getPSW;
%         if strmatch(user,'swip\songxm','exact')
%             isVIP=1;
%         else
%             isVIP=0;
%         end
%         sxDriver=newServer;%try one server
    end %if exist(newServer,'dir')~=7
%%
elseif isunix
    newServer='/hl/2adas';
    sxDriver=newServer;
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
% newServer='/Volumes/2adas';
% sxDriver=newServer;%try one server

end
%%


