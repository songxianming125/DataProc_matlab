function r=GetMyPower(y)
format='%+.1e';
    [s1,errmsg] = sprintf(format,y);
L1=size(s1,2);
if strfind(s1,'NaN')
    warnstr=strcat('The y value is/',s1,' /it is not a number, Check you curve value first');
    warndlg(warnstr)
    r=[];
else
    if ispc
%         se1=s1(L1-3:L1);
        se1=s1(L1-1:L1);
    elseif isunix
        se1=s1(L1-2:L1);
    end
    r=str2num(se1);% get the power of Lim
end
