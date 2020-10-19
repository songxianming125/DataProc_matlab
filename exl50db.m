function [y,x,varargout]=exl50db(CurrentShot,CurrentChannel,varargin)
%% CurrentChannel should be definite
machine='exl50';

%build a bridge to transfer the client channel to database one

CurrentChannel=channelTransfer(CurrentChannel);


z=[];
Unit='au';
if strcmp('@',CurrentChannel(1))
    [y,x,Unit]=exl50Formula(CurrentShot,CurrentChannel,varargin{:});
elseif strcmp('_',CurrentChannel(1))
    [y,x,Unit,z]=exl50Formula(CurrentShot,CurrentChannel,varargin{:});
elseif strcmp('=',CurrentChannel(1))
    [Expression,Dependence]=GetFormula(CurrentChannel);
    [y,x]=Formula(CurrentShot,Expression,Dependence);
    % check whether there is any inf
    index=find(isinf(y));
    y(index)=1./max(abs(y));
else
    strTreeName=getTreeName(machine,CurrentChannel); %
    [server,~] = getIpTree4Machine(machine);
    
    %% connect and open
    initServerTree(server,strTreeName{1},CurrentShot)
    [y,x,Unit]=db(CurrentChannel,varargin{:});
    
    %% close and disconnect
    initServerTree;
    %% SetTimeContext sometimes does not work, I don't know why. 
    if length(x)<2
        %% connect and open
        initServerTree(server,strTreeName{1},CurrentShot)
        [y,x,Unit]=db(CurrentChannel);
        %% close and disconnect
        initServerTree;
    end
    
end
if nargout>=3
    varargout{1}=Unit;
end
if nargout>=4
    varargout{2}=z;
end
