function MyChanList=channelTransfer(MyChanList)
%Dr SONG Xianming 
% transfer the user channel to HL-2A channel
switch  MyChanList
    case {'IP','ip','Ip','iP'}
        MyChanList = regexprep(MyChanList, MyChanList,'fbexip','ignorecase');  %
    case {'NE','ne','Ne','nE'}
        MyChanList = regexprep(MyChanList, MyChanList,'@neh','ignorecase');  %
    case {'UL','ul','Ul','uL'}
        MyChanList = regexprep(MyChanList, MyChanList,'@vlfilter','ignorecase');  %
    case {'BT','bt','Bt','bT'}
        MyChanList = regexprep(MyChanList, MyChanList,'@bt','ignorecase');  %
    case {'HA','ha','Ha','hA'}
        MyChanList = regexprep(MyChanList, MyChanList,'@ha','ignorecase');  %
    case {'DA','da','Da','dA'}
        MyChanList = regexprep(MyChanList, MyChanList,'@ha','ignorecase');  %
    case {'GAS','gas','Gas','gAS','GAs','gaS','gAs'}
        MyChanList = regexprep(MyChanList, MyChanList,'gas_2a','ignorecase');  %
    otherwise
end



