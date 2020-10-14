%%
figure
hold on
CurrentShot=23686; % VF calibration
% CurrentChannel='FbBv';
% [y,t]=hl2aweb(CurrentShot,CurrentChannel,0,2000,1);
% plot(t,y)
CurrentChannel='Fay_I_u';
[y,t]=hl2aweb(CurrentShot,CurrentChannel,0,2000,1);
plot(t,y)

% CurrentChannel='(Fay_o_u,Fay_I_u)';
% [y,t]=hl2aweb(CurrentShot,CurrentChannel,0,2000,1);
% plot(t,y)

% CurrentChannel={'FbBv' 'Fay_I_u' 'Fay_I_d' 'Fay_o_u' 'Fay_o_d'};
% [y,t]=hl2aweb(CurrentShot,CurrentChannel,0,2000,1);

