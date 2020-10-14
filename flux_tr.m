function flux_tr(shot,range)  %计算time spatial evolution of ne,te or qdiv, m: channale numbers for strike point
% tic
% s=read(shot,range,'ep01','ep02','ep03','ep04','ep05','ep06','ep07');%,'ep08','ep09','ep10');
% t1=toc
tic
[s,t]=hl2adb(shot,{'ep01','ep02','ep03','ep04','ep05','ep06','ep07'},range(1),range(2),1,'EPC');
t2=toc

% s5=(s(:,4)+s(:,6))./2;
% s4=(s(:,3)+s(:,5))./2;
% s3=(s(:,2)+s(:,4))./2;
% s=[s(:,1),s(:,2),s(:,3),s(:,4),s(:,5),s(:,6),s(:,7)];
% s_4=read(shot,range,'ep47','ep48','ep49','ep50');

[s_4,t]=hl2adb(shot,{'ep47','ep48','ep49','ep50'},range(1),range(2),1,'EPC');


Is4=s_4(:,2)-s_4(:,1);% 
t=linspace(range(1),range(2),length(Is4));
n=min(size(s));
z_m=6; % Z numbers ;4
coef=[10,10,10,10,10,10,10];

for i=1:n
   temp=ag_mm(s(:,i).*coef(i));% varargin{i};%smooth(s(:,i),1);%
   L=length(temp);
   mn(i)=mean(s(:,i));
   er(i)=std(s(:,i));
   C(i,:)=temp;
end
%index_c=3:L-2;% Cut the former and latter 2-points
x=linspace(range(1),range(2),L);%(495,530,L); % x方向的数据点
y=linspace(-87,-81,n);%(1,n,n);% y方向的数据点
[X,Y]=meshgrid(x,y);




figure
[c,h]=contourf(X,Y,C); %contourf(X,Y,C,v); 
set(h,'LineStyle','none');
xlabel('t(ms)')
ylabel('Z(cm)')
zlabel('Heat flux (Mw/m^2)')
figure
plot(x,smooth(C(z_m,:),50))

%ag(s(:,z_m).*1e3,range);

figure
errorbar(y,mn,er,'-s')
%ag(C(4,:),range);
%ag(Is4,range);

function s=ag_mm(sig)%Sign)
n=length(sig);
%Sign=Sign(end:-1:1);
Ag_t=5;%0.05 1;%0.165;%165;%0.25; 0.15 for L-I-L; 0.21 for LI-H averaged
N=floor(n/(1000*Ag_t));
k=floor(n/N);
for i=1:N
     index=(1+k*(i-1):k*i);
     s(i)=mean(sig(index)); % +12:imporve(km/s) 
end




