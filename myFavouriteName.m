function strChannel=myFavouriteName(CurrentChannel)
switch lower(CurrentChannel)
    case {'ip','@ip'}
        strChannel='Ip';
    case 'ph2p'
        strChannel='pre';
    case 'vl_filter'
        strChannel='Vl';
    case {'gas_pres02','@gas_pres02'}
        strChannel='Pressure';
    case {'blockgas','@blockgas'}
        strChannel='gasCommand';
    case {'mwi_ne001','@mwi_ne001'}
        strChannel='ne';
    case {'ha001','@ha001'}
        strChannel='ha';
    case {'g1_rf4','@g1_rf4'}
        strChannel='rfPower';
    otherwise
        strChannel=CurrentChannel;
end


return
mwi_ne001