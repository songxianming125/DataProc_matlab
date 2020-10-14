function [treeFinded,varargout]=getTreeName(machine,CurrentChannel,varargin)
%% also return the regexp channels

    treeFinded={};
    channelFinded={};
    if nargin==2
        path=getDProot(machine);
        file=[machine '.mat'];
        file = fullfile(path,file);
    elseif nargin==3
        shot=varargin{1};
        file=getMachineChannelFile(machine,shot);
    end
    load(file)
    
    % cell exl50Chnl is loaded for machine exl50

    [~,treeNames] = getIpTree4Machine(machine);
    
    chnlList=myChnlString;

    % find channel position
    pattern=[';' CurrentChannel ';'];
    cmd=['startIndexChnl =regexpi(chnlList,pattern);'];
    eval(cmd)
    startIndexChnl=startIndexChnl(1);
    
    for i=1:length(treeNames)
        % find tree position
        pattern=[':' treeNames{i} ':'];
        cmd=['startIndexTree =regexpi(chnlList,pattern);'];
        eval(cmd)
               
        if startIndexTree>startIndexChnl
            treeFinded=treeNames(i-1);
            break;
        else
            treeFinded=treeNames(i);
        end
    end
    
    if nargout==2
        varargout{1}={CurrentChannel};
    end

end

