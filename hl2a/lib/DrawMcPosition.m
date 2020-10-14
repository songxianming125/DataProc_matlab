function M=DrawMcPosition(u,l)

% u,l=0  mean no current
% u,l=1  mean with current


%draw the MP coil to reference the position
NumCoil=4;
NumPoint=5;
X(1:NumCoil)=[1.008 1.825 2.284 2.3841];
Y(1:NumCoil)=[0.165 1.312 0.745 0.371];
Xr(1:NumPoint)=[-0.014 0.014 0.014 -0.014 -0.014];
Yr(1:NumPoint)=[-0.04 -0.04 0.04 0.04 -0.04];
C(1:NumCoil)=['b' 'r' 'r' 'b'];


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
        else
            fill(xc,ycu,C(i))
            line(xc,ycu,'Color',C(i))
        end
    
        hold on
    
        if l==0 
            line(xc,ycl,'Color',C(i))
        else
            fill(xc,ycl,C(i))
            line(xc,ycl,'Color',C(i))
        end
        hold on
end
M=1;