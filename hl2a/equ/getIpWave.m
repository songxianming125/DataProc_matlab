function [Ip,Rp,t]=getIpWave(varargin)
%%
%       This program preset plasma curren and plasma resistance                 
%       Developed by Song xianming 2013.11.16  
%%  

  global T1  %ms  5-20
  global T2%50-200
  global T3 T4 % % 100 to 760 shape change: limiter to divertor
  global T5 T6 % % 8000 to 9000 shape change: from divertor to limiter


  
  
  
  
  %电阻应该用mOh 则单位问题解决
  
  global R0 %3000-50000 uOh
  global R1  %600-3000 uOh
  global R2%0.006;    %0.1-10 uOh



I1=[0 0 0.1 0.2 0.6 1.36 1.878 2.396 3.0 3.0 2.0 0]*1.0e6; % Ip curve
t1=[0 10 50 100 760 1470 1950 2440 3000 8000 9000 11000]; %time in ms
% Iex=[10 10 -2.42 -2.42 -1.68 -1.68 2.05 2.03 2.5 2.5 11.25 11.25 8.6 8.6 -12.8 -12.8 -6.20 -6.20]*1.0e3; % 600kA t=0.76s

t=0:11000;
Ip=interp1(t1,I1,t,'linear');
Rp=15*ones(size(t));







% plot(t,Ip)
% xlim([-1000,11000])


   %气体击穿的两个时间尺度
   T1=t1(2);  %ms  5-30
   T2=t1(3);%50-200
   
   
   
   T3=t1(4);
   T4=t1(5);
   T5=t1(end-2);
   T6=t1(end-1);
  
  %等离子体电阻应该用mOh 则单位问题解决
   R0=10; %3-50 mOh
   R1=3;  %0.6-3 mOh
   R2=0.002;    %0.0005-0.001 mOh
 

%   V1=15;
%   V2=3;
%   V3=1.2;
  V1=10;
  V2=2;
  V3=1.2;
   
   alpha=((V1/V2).^(2/3)-1)/(T2-T1);
    for i=(T1+1):T2
       Rp(i)=V1*(1/(1+alpha*(i-T1))).^(3/2);%有出错的可能
    end
     
   alpha=((V2/V3).^(2/3)-1)/(T3-T2);
    for i=(T2+1):T3
       Rp(i)=V2*(1/(1+alpha*(i-T2))).^(3/2);%有出错的可能
    end
   
   Rp(T3+1:end)=V3; 
   
   
  index=find(Ip);
  Rp(index)= Rp(index)./Ip(index);
  index=find(Ip==0);
  Rp(index)= Rp(index);
   
   
   
   
   
   
% Rp=MyResistance(t,t);
% index1=find(t>T4);
% index=find(t>T4);
% % index2=find(t<T6);
% % index=intersect(index1,index2);
% 
% Rp(index)=Rp(index1(1))*Ip(index1(1))./Ip(index); % keep (T4<t<T6) constant loopVoltage
% plot(t,Ip)
% xlim([-1000,11000])
%   semilogy(t,Rp);
% 
% xlim([-1000,11000])


return


