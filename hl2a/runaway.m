close all

num=2000;  % 10us for one point

a=zeros(num,1);% m/s^2
v=zeros(num,1); % m/s
vk=zeros(num,1); % m/s
ak=zeros(num,1); % m/s
dv=zeros(num,1); % m/s  different between velocity from two different ways
s=zeros(num,1);% m
Ek=zeros(num,1);% kgm^2/s^2

m=zeros(num,1);% kg
m(1)=9.1e-31;% kg, initial mass
c=3e8;% m/s
e=1.6e-19;% Coulomb=9.1e-31;
mc2=500;% keV
E0=m(1)*c*c;
%% 2M
Vloop=10; %V
R=1.78; % m
%% 2A 
% Vloop=5; %V
% R=1.65; % m
T=20; %ms



%% no relativity
dt=1.0e-5;%dt=10us
% for i=2:num  %20ms
for i=2:10  %20ms
  a(i)=e*Vloop/(2*pi*R)/m(i-1);  %a=F/m, F=E*q; E=V/(2*pi*R)
  v(i)=v(i-1)+a(i)*dt;
  s(i)=s(i-1)+dt*(v(i-1)+v(i))/2;
  Ek(i)=e*Vloop/(2*pi*R)*s(i); % Ek=F*s
  vk(i)=((1-(E0/(E0+Ek(i)))^2)^0.5)*c;
  dv(i)= v(i)-vk(i);
  m(i)=m(1)*(E0+Ek(i))/E0;
  ak(i)=(vk(i)-vk(i-1))/dt;
end
% % 
for i=11:num  %20ms
  a(i)=e*Vloop/(2*pi*R)/m(i-1);  %a=F/m, F=E*q; E=V/(2*pi*R)
  v(i)=v(i-1)+a(i)*dt;
  vk(i)=((1-(E0/(E0+Ek(i-1)))^2)^0.5)*c;
  s(i)=s(i-1)+dt*(vk(i-1)+vk(i))/2;
  Ek(i)=e*Vloop/(2*pi*R)*s(i); % Ek=F*s
  dv(i)= v(i)-vk(i);
  m(i)=m(1)*(E0+Ek(i))/E0;
  ak(i)=(vk(i)-vk(i-1))/dt;

end




t=(1:num)*dt*1e5;


Ekev=Ek/e;
figure
hold on
plot(t,s,'.r')
plot(t,Ekev,'.b')

% 
T500=find(Ekev>500,1,'first')
T5000=find(Ekev>5000,1,'first')
T50000=find(Ekev>50000,1,'first')
T500000=find(Ekev>500000,1,'first')
%  return

figure
hold on
plot(t,dv,'.r')
plot(t,v,'.b')
plot(t,vk,'.m')

figure
hold on
plot(t,a,'.r')
plot(t,ak,'.b')
figure
plot(t,m,'.m')








