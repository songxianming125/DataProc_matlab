function TF= isMachineReady(machine)
    % IpAddress = 'mds.ipp.ac.cn'  # 202.127.204.12
    % IpAddress = '192.168.20.11'  # exl50
    

    [IpAddress, tree] = getIpTree4Machine(machine);
    cmd = ['ping '  IpAddress '>temp.txt' ];
    tic ;
        dos(cmd);
    elapsedSeconds=toc;

    if  elapsedSeconds > 6
        TF=0;
        msgbox(['no internet connection to: ' machine ', 请检查网络连接，是否连上数据库！'])
        dos('ipconfig')
    else
        TF=1;
    end
end

