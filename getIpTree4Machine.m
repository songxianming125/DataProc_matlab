% function [IpAddress,strTreeName,varargout] = getIpTree4Machine(Machine)
function [IpAddress,strTreeName] = getIpTree4Machine(machine)
    IpAddress=[];
    switch lower(machine)
        case 'exl50'
            pmds
            if ispc
                [~,r]=dos('ipconfig');
                IPAddressPattern='192\x{2E}168\x{2E}20\x{2E}\d{1,3}';  %(?<=test)expr
%                  IPAddressPattern='(?<=IPv4.{30,40})10\x{2E}2\x{2E}70\x{2E}\d{1,3}';  %(?<=test)expr
                IPAddressPattern=regexp(r,IPAddressPattern,'match');
                if length(IPAddressPattern)>0
                    IpAddress='192.168.20.11';
                else
                    IPAddressPattern='192\x{2E}168\x{2E}10\x{2E}\d{1,3}';
                    IPAddressPattern=regexp(r,IPAddressPattern,'match');
                    if length(IPAddressPattern)>0
                        IpAddress='192.168.10.11';
                    else
                        IpAddress='192.168.0.11';
                    end
                end
            elseif ismac
                IpAddress='192.168.20.11';
            end

            strTreeName={'exl50'};

        case 'ehl'
            %%
            pmds
            IpAddress='192.168.20.183';
            strTreeName={'pcs_east','east','efitrt_east'};
        case 'east'
            %%
            pmds
            % IpAddress='mds.ipp.ac.cn';
            IpAddress='202.127.204.12';
            strTreeName={'pcs_east','east','efitrt_east'};
        case 'hl2a'
             strTreeName={'2adas'};
            if ispc
                IpAddress='192.168.20.11';
            elseif ismac
                IpAddress='192.168.20.11';
            end
        case 'hl2m'
             strTreeName={'2mdas'};
            if ispc
                IpAddress='192.168.20.11';
            elseif ismac
                IpAddress='192.168.20.11';
            end
            
            
        case 'localdas'
            strTreeName={''};
            
            dlg_title = 'Set local driver';
            prompt = {'input the local driver'};
            def   = {'c:\das'};
            num_lines= 1;
            answer  = inputdlg(prompt,dlg_title,num_lines,def);
            
            IpAddress=answer{1};
            
            %%
    end
end

