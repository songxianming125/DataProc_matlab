function Yy=SetYTick(varargin)
%%%********************************************************%%%
%%%       This program is setting the favorite YTick       %%%
%%%       Developed by Dr SONG Xianming 2020/05/04/        %%%
%%%********************************************************%%%

%% default values
ha=gca;
n=3;
defRightDigit=1;

if nargin>=1 && ~isempty(varargin{1})
    ha=varargin{1};
end
if nargin>=2 && ~isempty(varargin{2})
    n=varargin{2};
end
if nargin>=3 && ~isempty(varargin{3})
    defRightDigit=varargin{3};
end
  
MyYTick(ha,n,defRightDigit);
Yy=0;