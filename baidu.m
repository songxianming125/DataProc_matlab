function baidu(varargin)
    KeyWord=[];
    for i=1:nargin
    KeyWord=[KeyWord,'+',varargin{i}];
    end

    dos(['start http://www.baidu.com/baidu?wd=',KeyWord(2:end)])
end
