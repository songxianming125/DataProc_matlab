function M=DrawVFPosition(u)

% u=0  mean no current
% u=1  mean with current


%draw the MP coil to reference the position



NumCoil=8;
X(1:NumCoil)=[1.008 1.008 1.008 1.008 1.987 2.345 2.438 2.46];
Y(1:NumCoil)=[0.055 0.34 0.45 0.56 1.21 0.776 0.563 0.325];
C(1:NumCoil)=['m' 'm' 'm' 'm' 'k' 'k' 'k' 'k'];


NumPoint=5;
Xr(1:NumPoint)=[-0.014 0.014 0.014 -0.014 -0.014];
Yr(1:NumPoint)=[-0.04 -0.04 0.04 0.04 -0.04];


for i=1:NumCoil
    
    for j=1:NumPoint
        
        if i==NumCoil
            xc(j)=X(i)+Yr(j);
            ycu(j)=Y(i)+Xr(j);
            ycl(j)=-Y(i)+Xr(j);
        else
            xc(j)=X(i)+Xr(j);
            ycu(j)=Y(i)+Yr(j);
            ycl(j)=-Y(i)+Yr(j);
        end
    end
    
        if u==0 
            line(xc,ycu,'Color',C(i))
            line(xc,ycl,'Color',C(i))
       else
            fill(xc,ycu,C(i))
            line(xc,ycu,'Color',C(i))
            fill(xc,ycl,C(i))
            line(xc,ycl,'Color',C(i))
        end
        hold on
end
M=1;