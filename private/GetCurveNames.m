function CurveNames=GetCurveNames
%%
%Initialize the Curve Names we get from the function GetCurveByFormula
%%
machine=getappdata(0,'machine');
switch machine
    case {'hl2a','localdas','hl2m'}
        
        CurveNames={'@ha';'@ip';'@ip1';'@ne_fir';'@prev'; '@ipvf';'@Ted';'@Ned';'@tprof';'@vlfilter';'@ccdh';'@ccdv';'@bt';'@itf';'@fluxdh';'@dh';'@ie1toipfbc';'@ie2toie1fbc';...
            '@ie2toie1mmc';'@g4_fw';'@neh';'@ph2p';'@ph2';'@xww';'@poh';...
            '@tedd1';'@tedd3';'@tedd5';'@tedd7';'@tedd8';'@tedd10';'@tedd12';'@tedd14';...
            '@pohmmc';'@v2i';'@v2islow';'@prad';'@pion';'@nbi';'@nbi2';'@pecrh';'@flux';'@fitvl';'@fitioh';'@ivf';'@hf';'@hfs';'@newe'};
    case 'exl50'
        CurveNames={'@itf4','@gaspre', '@neG','@ciiiG','@ipG','@dh','@dv','ph','P_ECRH','ip','ipf1','ipf2','ipf3','ipf5','ipf6','ne','ha','G1_RF4','gas_pres02','blockgas','m1_pin','m2_pin','m1_pout','m2_pout'};
    case 'east'
        CurveNames={'pcpf1','pcrl01','pcpf10'};
end
