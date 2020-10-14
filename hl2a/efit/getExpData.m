function [fluxMeasured,BnMeasured,BtMeasured,Ip,Iex,betap]=getExpData(CurrentTime,gFit)
%% get experiment data from data base
% and smooth the experimental data

% Bn: 4 5 11 12 13 with wrong data

% get the value at CurrentTime


% fluxMeasured=
% BnMeasured=
% BtMeasured=
% Ip=
% iPF=
% betap=
% tf=
% tv=
% tm=
% te




index=find(CurrentTime<=gFit.tf,1, 'first');
fluxMeasured=gFit.fluxMeasured(index,:);

index=find(CurrentTime<=gFit.tv,1, 'first');

BnMeasured=gFit.BnMeasured(index,:)'; % Tesla
BtMeasured=gFit.BtMeasured(index,:)'; % Tesla


indexPF=find(CurrentTime<=gFit.tm,1, 'first');
Iex=[gFit.Iex(indexPF,1:3) 0 0 0 0 gFit.Iex(indexPF,4:5) gFit.Iex(indexPF,4:5)]*1e3; % kA


index=find(CurrentTime<=gFit.tf,1, 'first');
Ip=gFit.Ip(index)*1e3;
if isempty(gFit.betap)
    betap=0.1;
else
    index=find(CurrentTime<=gFit.te,1, 'first');
    betap=gFit.betap(index);
end
return

%% calibration B field

    

%% view1
figure
plot(te,betap)
%% view2
figure
plot(tf,Ip)
%% view3
figure
plot(tv,BnMeasured(:,1))
%% view4

figure
hold on
plot(tm,iPF1(:,2))
plot(tm,iPF(:,2),'r')
plot(tm,iPF1(:,3))
plot(tm,iPF(:,3),'r')


iPF2=iPF1-iPF;
plot(tm,iPF2(:,2))



 