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
% 第一种方法: 使用mount
%   装载:
%     第一步: 创建一个空目录, 作为装载节点.
%     目录名任意, 目录存储位置任意.
%     例如:
%         mkdir /Volumes/UDE-Mac
%        
%     第二步: 把远程共享目录装载到该目录上.
%     mount -t smbfs //username:password@hos_tname/share_folder
%     host_name : 可以是主机名, 也可以是IP地址.
%     -t smbfs : 指定装载的文件系统类型.
%     如果共享名称中有空格, 用 代替.
%     例如:
%         mount -t smbfs //guest:@192.168.0.132/UDE-Mac /Volumes/UDE-Mac
%         把 192.168.0.132上的共享目录 UDE-Mac, 装载到本地/Volumes/UDE-Mac目录上. 使用guest账户, 密码为空.
%        
%   卸载:
%     umount mounted_folder
%     例如:
%         umount /Volumes/UDE-Mac
%         此命令会自动删除/Volumes/UDE-Mac目录.
% 第二种方法: 使用 mount_smbfs
%   和第一种方法基本相同, 只是用 mount_smbfs 代替了 mount -t smbfs
%   装载:
%     mkdir /Volumes/UDE-Mac
%     mount_smbfs //guest:@192.168.0.132/UDE-Mac /Volumes/UDE-Mac
%   卸载:
%     umount /Volumes/UDE-Mac
%    
% 第三种方法: 使用action script
%   装载:
%     tell application "Finder"
%         open location "smb://guest:@192.168.0.132/UDE-Mac"
%     end tell
%  
%   卸载:
%     tell application "Finder"
%         eject (every disk whose name is "UDE-Mac")
%     end tell

%%
%first link as '/Volumes/2adas' in finder
% newServer='/Volumes/2adas';
% sxDriver=newServer;%try one server

end
%%


