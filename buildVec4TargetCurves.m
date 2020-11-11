function s = buildVec4TargetCurves
setappdata(0,'machine','hl2m')
shot=40006;
vb;
[y,t]=hl2adb(shot,'pf8u_i',-500,2000,1);

UD.iChannels={'IF'};
UD.uChannels=[];
UD.saveInterruptive=1;
UD.MyShot='80007';
UD.t=t; % ms
UD.I=y;
UD.U=[];
UD.numNodeInWaveform=30;

setVecIn2mDB(UD)


end

