figure
plot(x3,y1,'kp',x4,y2,'ro')
h = legend('after','before','BEST');
xlim([0 1.5])
ylim([0 60])
xlabel('U_L_o_o_p(kW)')
text_handle=ylabel('Tdelay(ms)');
set(text_handle,'FontName','FixedWidth')
% plot(x1,y1,'kp', 'MarkerFaceColor','k')
% hold on
% plot(x2,y2,'ro','MarkerFaceColor','r')
return
figure
plot(x1,y1,'kp',x2,y2,'ro')
h = legend('after','before','BEST');
xlim([400 1000])
ylim([0 60])
xlabel('P_E_C_R_H(kW)')
text_handle=ylabel('Tdelay(ms)');
set(text_handle,'FontName','FixedWidth')



return

myDelayTime='C:\myDelayTime.mat';
save(myDelayTime)

return
