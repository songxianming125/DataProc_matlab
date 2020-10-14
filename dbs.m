function [y,x,varargout]=dbs(machine,CurrentShot,CurrentChannel,varargin)
%% support more channels
%% get data from MDSplus database for exl50 and east
channelFinded=CurrentChannel; % only one channel
strTreeName=[];
Unit='au';
x=0;
y=0;
zMatrix=[];


%% init
if iscell(CurrentChannel)
    % support more channels only here
    strTreeName=getTreeName(machine,CurrentChannel{1}); % 
    [server,~] = getIpTree4Machine(machine);
    %% connect and open
    
    initServerTree(server,strTreeName{1},CurrentShot) 
    hwait=waitbar(0,'please wait ...');

    for i=1:length(CurrentChannel)
        % with the same x and Unit

        if i==1
            [z,x,Unit]=db(CurrentChannel{i},varargin{:});
            y=zeros(length(z),length(CurrentChannel));
            y(:,i)=z;

        else
            [z,x,Unit]=db(CurrentChannel{i},varargin{:});
            y(:,i)=z;
        end
        waitbar(i/(1+length(CurrentChannel)));
    end
    close(hwait)
    %% close and disconnect
    initServerTree; 

else
    try
        [treeFinded,channelFinded]=getTreeName(machine,CurrentChannel);
        
    catch
         setappdata(0,'MyErr','dbs, wrong when get tree name');
    end
    
    
    
    if isempty(treeFinded)
        setappdata(0,'MyErr','dbs, no tree for this channel');
    elseif ischar(channelFinded{1})
        % only one channel
        strTreeName=getTreeName(machine,channelFinded{1}); %
        [server,~] = getIpTree4Machine(machine);
        
        %% connect and open       
        initServerTree(server,strTreeName{1},CurrentShot)
        [y,x,Unit]=db(channelFinded{1},varargin{:});
        %% close and disconnect
        initServerTree;
       
    elseif iscell(channelFinded{1})
        %% call itself
        %% do not support more tree channels
        strTreeName=treeFinded;
        for i=1:1 % length(treeFinded)
            [y,x,Unit]=dbs(machine,CurrentShot,channelFinded{i},varargin{:});
        end
    end
end



if nargout>=3
    varargout{1}=Unit;
    if nargout>=4
        varargout{2}=strTreeName;
        if nargout>=5
            varargout{3}=channelFinded;
            if nargout>=6
                varargout{4}=zMatrix;
            end
        end
    end
end
return
end

