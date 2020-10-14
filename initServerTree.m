function initServerTree(varargin)
if nargin>0  % should be 3
    if nargin~=3
        setappdata(0,'MyErr','initServerTree, nargin ~=3');
        return
    else
        %% connect and open
        mdsconnect(varargin{1}); % server
        mdsopen(varargin{2},varargin{3}); % tree and shot
    end
else
    try
        %% close and disconnect
        mdsclose;
        mdsdisconnect;
    catch
        setappdata(0,'MyErr','initServerTree, wrong when close and disconnect');
    end
end
