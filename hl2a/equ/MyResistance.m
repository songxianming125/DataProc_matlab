  %定义时间和电阻常数,经常要调节
  %求等离子体的电阻值
  function y=MyResistance(t1,myTime)
  %global n
  %global myTime
  %global iStep
  
  global T1  %ms  5-20
  global T2%50-200
  %电阻应该用mOh 则单位问题解决
  
  global R0 %3000-50000 uOh
  global R1  %600-3000 uOh
  global R2%0.006;    %0.1-10 uOh
  %解常微分方程
  
  
%    %气体击穿的两个时间尺度
%    T1=10;  %ms  5-20
%    T2=50;%50-200
%   
%   %等离子体电阻应该用mOh 则单位问题解决
%    R0=3; %3-50 mOh
%    R1=0.6;  %0.6-3 mOh
%    R2=0.001;    %0.0005-0.001 mOh
%  
  
  
  
  n=size(myTime,2);
  iStep=myTime(2)-myTime(1);
  
  Njunction1=fix(T1/iStep)+1;  %设置连接点
  for i=1:Njunction1
        myY(i)=R0-(R0-R1)*iStep*(i-1)/T1;
  end

  Njunction2=fix(T2/iStep);  %设置连接点
  
  alpha=((R1/R2).^(2/3)-1)/(T2-T1);
    for i=(Njunction1+1):Njunction2
        myY(i)=R1*(1/(1+alpha*iStep*(i-Njunction1-1))).^(3/2);%有出错的可能
    end
    
    for i=(Njunction2+1):n
        myY(i)=R2;
    end
  
  %选择拟合点  
  %if mod(T1,iStep)=0
  %end
y=spline(myTime,myY,t1)*1e-3; % mOhmic->Ohmic
   % MyResistance=spline(myTime,myY,t);
    
    
   
    
