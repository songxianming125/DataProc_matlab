function [y,x,varargout]=eastdb(CurrentShot,CurrentChannel,varargin)
z=[];
%% CurrentChannel should be definite
machine='east';

switch CurrentChannel(1)
    case '@'
        [y,x,Unit]=eastFormula(CurrentShot,CurrentChannel,varargin{:});
    case '_'
        [y,x,Unit,z]=eastFormula(CurrentShot,CurrentChannel,varargin{:});
    otherwise
        strTreeName=getTreeName(machine,CurrentChannel); %
        [server,~] = getIpTree4Machine(machine);
        
        %% connect and open
        initServerTree(server,strTreeName{1},CurrentShot)
        [y,x,Unit]=db(CurrentChannel,varargin{:});
        %% close and disconnect
        initServerTree;
end




if nargout>=3
    varargout{1}=Unit;
end
if nargout>=4
    varargout{2}=z;
end