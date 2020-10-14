%%
% calculating the velocity from the acceleration data 
% developed by Dr Song Xianming
%%
CurrentShot=16025;
[y,x,CurrentSysName,Unit]=hl2adb(CurrentShot,'3Axis_g4x','','','','ZDA');%get the acceleration data
            delT=(x(2)-x(1))*0.001;% get the dt in second
            v(1)=0; %initial data
            s(1)=0;
            y=y+40/60000;% zero drift cancellation
            tic;
            
            %v = fnval(csapi(x,y),x); 
              v1 = fnval(fnint(csapi(x,y),0),x); 
              t1=toc;
%             
%             z=sum(y);

tic;
            for i=2:length(x)
%               v(i)=v(i-1)+y(i-1)+y(i);  
              v(i)=v(i-1)+y(i-1);  
%               s(i)=s(i-1)+v(i-1)+v(i);  
            end
t2=toc;
            y(:,1)=delT/2*v'*1000;
            
            y(:,2)=v1;
            
t=0;
