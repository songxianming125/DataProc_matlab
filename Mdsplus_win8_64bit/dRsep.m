clear
clc
shotnum=42315;
shot=int2str(shotnum);
mdsconnect('202.127.204.12');
%----------------------------------------------------------------------
shotnumber=mdsopen('PCS_EAST',shotnum);
tdrsep=mdsvalue('dim_of(\idtdrsep)');
drsep=mdsvalue('\idtdrsep');
ta=tdrsep(1);
tb=tdrsep(end);
%----------------------------------------------------------------------
shotnumber=mdsopen('efitrt_east',shotnum);
tefit=mdsvalue('\atime');
R=mdsvalue('\R');
Z=mdsvalue('\Z');
PSI=mdsvalue('\psirz');
RMAXIS=mdsvalue('\Rmaxis');   % R position of axis
ZMAXIS=mdsvalue('\Zmaxis');   % z position of axis
Rxpt1=mdsvalue('\rxpt1');         % major radius of lower x point
Zxpt1=mdsvalue('\zxpt1');         % Z position of lower x point
Rxpt2=mdsvalue('\rxpt2');         % major radius of uper x point
Zxpt2=mdsvalue('\zxpt2');         % Z position of uper x point
%----------------------------------------------------------------------
[Y,Ia]=min(abs(tefit-ta));
[Y,Ib]=min(abs(tefit-tb));
i=0;
for k=Ia:Ib
    psiRZ=PSI(:,:,k)';
    Rxpt=[Rxpt1(k) Rxpt2(k)];     % major radius of (lower,upper) x point
    Zxpt=[Zxpt1(k) Zxpt2(k)];     % Z position 0f  (lower,upper) x point
    PsiXpt=interp2(R,Z,psiRZ,Rxpt,Zxpt,'spline');  % psiRZ value at  X-points,index(k)对应时刻

%% 将中平面磁轴以外的所有处磁面值找出
    Rmaxis=RMAXIS(k);
    Zmaxis=ZMAXIS(k);
    Rmid=Rmaxis:0.0001:R(end);
    Zmid=Zmaxis*ones(size(Rmid));
    psimid=interp2(R,Z,psiRZ,Rmid,Zmid);        % 将中平面磁轴以外所有处磁面值找出, 或psimid=interp2(Z,R,psiRZ',Zm,Rm);
    Rm=interp1(psimid,Rmid,PsiXpt,'spline');     % X-point投影到外中平面的R
    i=i+1;
    tDrsep(i)=tefit(k);
    Drsep(i)=(Rm(1)-Rm(2));         % m
end
%----------------------------------------------------------------------
figure(3)
clf
plot(tdrsep,drsep,tDrsep,Drsep,'r')
grid on
xlabel('time  ( s )')
ylabel('dR_s_e_p  ( m )')
title(shot)
%--------------------------------------------------------------------------
mdsclose;
mdsdisconnect;