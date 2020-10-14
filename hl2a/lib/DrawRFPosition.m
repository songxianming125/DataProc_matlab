function M=DrawRFPosition(u)

% u,l=0  mean no current
% u,l=1  mean with current


%draw the RF coil to reference the position



NumCoil=4;
X(1:NumCoil)=[1.006 2.38 1.006 2.38];
Y(1:NumCoil)=[0.8 0.537 -0.8 -0.537];
%C(1:NumCoil)=['r' 'r' 'b' 'b'];
C=zeros(4,3);

%C(1,:)=[1 0.5 0.5];
%C(2,:)=[1 0.5 0.5];
%C(3,:)=[0.5 0.5 0.5];
%C(4,:)=[0.5 0.5 0.5];
C(1,:)=[1 0.5 0];
C(2,:)=[1 0.5 0];
C(3,:)=[0 0.5 1];
C(4,:)=[0 0.5 1];

NumPoint=5;



for i=1:NumCoil
    
    for j=1:NumPoint
        
        if mod(i,2)==0
            Xr(1:NumPoint)=[-0.01 0.01 0.01 -0.01 -0.01];
            Yr(1:NumPoint)=[-0.013 -0.013 0.013 0.013 -0.013];

            xc(j)=X(i)+Xr(j);
            ycu(j)=Y(i)+Yr(j);
        else
            Xr(1:NumPoint)=[-0.013 0.013 0.013 -0.013 -0.013];
            Yr(1:NumPoint)=[-0.028 -0.028 0.028 0.028 -0.028];

            xc(j)=X(i)+Xr(j);
            ycu(j)=Y(i)+Yr(j);
        end
    end
    
        if u==0 
            line(xc,ycu,'Color',C(i,:))
        else
            fill(xc,ycu,C(i,:))
            line(xc,ycu,'Color',C(i,:))
        end
    
        hold on
    
         hold on
end
M=1;