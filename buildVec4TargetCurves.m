function s = buildVec4TargetCurves
setappdata(0,'machine','hl2m')
shot=40109;

[y0,t]=hl2adb(shot,'cs_i',-500,2000,1);
[y6,t]=hl2adb(shot,'pf6u_i',-500,2000,1);
[y8,t]=hl2adb(shot,'pf8u_i',-500,2000,1);
y=[y0 y6 y8];
UD.iChannels={'I0','IB','IF'};
UD.uChannels=[];
UD.saveInterruptive=1;
UD.MyShot='88890';
UD.t=t; % ms
UD.I=y;
UD.U=[];
UD.numNodeInWaveform=30;

setVecIn2mDB(UD)
disp('save ok!')

end

