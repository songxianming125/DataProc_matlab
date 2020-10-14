function MyChanList=channelTransfer(MyChanList)
%% Dr SONG Xianming
%% transfer the user channel to HL-2A channel

if 1  %% exl50
    switch  MyChanList
        case {'IP','ip','Ip','iP'}
            MyChanList = regexprep(MyChanList, MyChanList,'ip','ignorecase');  %
        case {'NEM','nem','Ne','nE'}
            MyChanList = regexprep(MyChanList, MyChanList,'mwi_ne001','ignorecase');  %
        case {'UL','ul','Ul','uL'}
            MyChanList = regexprep(MyChanList, MyChanList,'@vlfilter','ignorecase');  %
        case {'BT','bt','Bt','bT'}
            MyChanList = regexprep(MyChanList, MyChanList,'@bt','ignorecase');  %
        case {'HA','ha','Ha','hA','@ha'}
            MyChanList = regexprep(MyChanList, MyChanList,'@ha','ignorecase');  %
        case {'DA','da','Da','dA'}
            MyChanList = regexprep(MyChanList, MyChanList,'@ha','ignorecase');  %
        case {'GAS','gas','Gas','gAS'}
            MyChanList = regexprep(MyChanList, MyChanList,'gas_2a','ignorecase');  %
        otherwise
    end
end






% transfer the user channel to HL-2A channel
if 0  %% HL2A
    switch  MyChanList
        case {'IP','ip','Ip','iP'}
            MyChanList = regexprep(MyChanList, MyChanList,'fbexip','ignorecase');  %
        case {'NE','ne','Ne','nE'}
            MyChanList = regexprep(MyChanList, MyChanList,'@ne4','ignorecase');  %
        case {'UL','ul','Ul','uL'}
            MyChanList = regexprep(MyChanList, MyChanList,'@vlfilter','ignorecase');  %
        case {'BT','bt','Bt','bT'}
            MyChanList = regexprep(MyChanList, MyChanList,'@bt','ignorecase');  %
        case {'HA','ha','Ha','hA','@ha'}
            MyChanList = regexprep(MyChanList, MyChanList,'@ha','ignorecase');  %
        case {'DA','da','Da','dA'}
            MyChanList = regexprep(MyChanList, MyChanList,'@ha','ignorecase');  %
        case {'GAS','gas','Gas','gAS'}
            MyChanList = regexprep(MyChanList, MyChanList,'gas_2a','ignorecase');  %
        otherwise
    end
end



