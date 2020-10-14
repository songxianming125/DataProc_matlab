function y=startPara(varargin)
y=1;
if nargin>0
    coreNum=varargin{1};
else
    coreNum=8; % default number
end


if coreNum>0
    if matlabpool('size')>0
        disp(['There are ' num2str(matlabpool('size')) ' Cores for parallel computing' ])
    else
        %not open
        matlabpool(coreNum)
        disp(['We set ' num2str(coreNum) ' Cores for parallel computing' ])
    end
end

if coreNum<1
    if matlabpool('size')>0
        matlabpool close
        disp(['We cancel parallel computing' ])
    else
        disp(['No parallel computing' ])
    end
end
y=0;