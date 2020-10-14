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
% efitServer='/Volumes/2adas';
% sxDriver=efitServer;%try one server

end
%%


