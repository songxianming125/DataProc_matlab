  %����ʱ��͵��賣��,����Ҫ����
  %���������ĵ���ֵ
  function y=MyResistance(t1,myTime)
  %global n
  %global myTime
  %global iStep
  
  global T1  %ms  5-20
  global T2%50-200
  %����Ӧ����mOh ��λ������
  
  global R0 %3000-50000 uOh
  global R1  %600-3000 uOh
  global R2%0.006;    %0.1-10 uOh
  %�ⳣ΢�ַ���
  
  
%    %�������������ʱ��߶�
%    T1=10;  %ms  5-20
%    T2=50;%50-200
%   
%   %�����������Ӧ����mOh ��λ������
%    R0=3; %3-50 mOh
%    R1=0.6;  %0.6-3 mOh
%    R2=0.001;    %0.0005-0.001 mOh
%  
  
  
  
  n=size(myTime,2);
  iStep=myTime(2)-myTime(1);
  
  Njunction1=fix(T1/iStep)+1;  %�������ӵ�
  for i=1:Njunction1
        myY(i)=R0-(R0-R1)*iStep*(i-1)/T1;
  end

  Njunction2=fix(T2/iStep);  %�������ӵ�
  
  alpha=((R1/R2).^(2/3)-1)/(T2-T1);
    for i=(Njunction1+1):Njunction2
        myY(i)=R1*(1/(1+alpha*iStep*(i-Njunction1-1))).^(3/2);%�г���Ŀ���
    end
    
    for i=(Njunction2+1):n
        myY(i)=R2;
    end
  
  %ѡ����ϵ�  
  %if mod(T1,iStep)=0
  %end
y=spline(myTime,myY,t1)*1e-3; % mOhmic->Ohmic
   % MyResistance=spline(myTime,myY,t);
    
    
   
    
